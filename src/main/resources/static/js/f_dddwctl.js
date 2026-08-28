/**
 * ============================================================================
 * Dynamic DropDownDataWindow (DDDW) Controller - f_dddwctl.js
 * PowerBuilder DDDW Dynamic Control & Data Retrieval Utility
 * ============================================================================
 */

(function (global) {
    'use strict';

    /**
     * Cache storage for DDDW options to avoid redundant network calls.
     */
    const dddwCache = new Map();

    /**
     * PowerBuilder f_dddwctl Core Helper
     * Dynamically retrieves DropDownDataWindow code/name options via REST API (/api/common/dddw)
     *
     * Overload Signatures:
     *   f_dddwctl(dddwId, seq, addWhere, addOrderBy)
     *   f_dddwctl(dddwId, addWhere, addOrderBy)  --> (seq defaults to 1)
     *
     * @param {string} dddwId DropDownDataWindow ID (e.g. 'CORP_GR', 'series_g1', 'bm_gr', 'gugan', 'ga')
     * @param {number|string} [seq=1] Sequence number or dynamic WHERE clause if omitted
     * @param {string} [addWhere=""] Dynamic WHERE clause (e.g. "corp_gr='2200'")
     * @param {string} [addOrderBy=""] Dynamic ORDER BY clause
     * @returns {Promise<Array<{code: string, name: string}>>}
     */
    function f_dddwctl(dddwId, seq = 1, addWhere = "", addOrderBy = "") {
        let targetDddwId = dddwId || 'CORP_GR';
        let targetSeq = 1;
        let actualWhere = addWhere;
        let actualOrderBy = addOrderBy;

        if (typeof seq === 'number') {
            targetSeq = seq;
        } else if (typeof seq === 'string' && /^\d+$/.test(seq)) {
            targetSeq = parseInt(seq, 10);
        } else if (typeof seq === 'string') {
            // Handle argument shift if seq was omitted (e.g. f_dddwctl('series_g1', "corp_gr='2200'"))
            actualOrderBy = addWhere;
            actualWhere = seq;
        }

        let url = `/api/common/dddw?dddwId=${encodeURIComponent(targetDddwId)}&seq=${encodeURIComponent(targetSeq)}`;
        if (actualWhere) url += `&addWhere=${encodeURIComponent(actualWhere)}`;
        if (actualOrderBy) url += `&addOrderBy=${encodeURIComponent(actualOrderBy)}`;

        // Use safeFetchJson if available, otherwise native fetch
        const fetchPromise = (typeof global.safeFetchJson === 'function')
            ? global.safeFetchJson(url)
            : fetch(url).then(res => res.ok ? res.json() : []);

        return fetchPromise
            .then(list => Array.isArray(list) ? list : [])
            .catch(err => {
                console.warn(`[f_dddwctl] Error loading DDDW (${targetDddwId}):`, err);
                return [];
            });
    }

    /**
     * Retrieve multiple DDDW datasets simultaneously using Promise.all
     *
     * Example:
     *   f_dddwctl.retrieveMultiple({
     *       series_g1: ['series_g1', 1, "corp_gr='2200'"],
     *       bm_gr: ['bm_gr', 1],
     *       gugan: ['gugan', 1],
     *       ga: ['ga', 1]
     *   }).then(results => {
     *       console.log(results.series_g1, results.bm_gr);
     *   });
     *
     * @param {Object.<string, Array>} requestsMap Map of keys to f_dddwctl arguments
     * @returns {Promise<Object.<string, Array<{code: string, name: string}>>>}
     */
    f_dddwctl.retrieveMultiple = function (requestsMap) {
        const keys = Object.keys(requestsMap);
        const promises = keys.map(key => {
            const args = Array.isArray(requestsMap[key]) ? requestsMap[key] : [requestsMap[key]];
            return f_dddwctl(...args);
        });

        return Promise.all(promises).then(results => {
            const resultMap = {};
            keys.forEach((key, idx) => {
                resultMap[key] = results[idx] || [];
            });
            return resultMap;
        });
    };

    /**
     * Dynamic DDDW Dropdown Options Loader Helper
     * Loads DDDW data from server and populates a target HTML <select> element.
     *
     * @param {string} selectId DOM Element ID for the <select> element
     * @param {string} dddwId DDDW Identifier
     * @param {number|string} [seq=1] Sequence number
     * @param {string} [addWhere=""] Dynamic WHERE clause
     * @param {string} [addOrderBy=""] Dynamic ORDER BY clause
     * @param {string} [defaultVal=""] Default selected code value
     */
    f_dddwctl.loadOptions = function (selectId, dddwId, seq, addWhere, addOrderBy, defaultVal) {
        const selectEl = document.getElementById(selectId);
        if (!selectEl) return Promise.resolve([]);

        let actualDefault = defaultVal;
        if (typeof seq !== 'number' && !(typeof seq === 'string' && /^\d+$/.test(seq))) {
            actualDefault = addOrderBy;
        }

        return f_dddwctl(dddwId, seq, addWhere, addOrderBy).then(list => {
            if (!list || list.length === 0) return list;
            let html = '';
            list.forEach(item => {
                const itemCode = (item.code != null ? item.code : (item.SEBU_CD != null ? item.SEBU_CD : item.cd));
                const itemName = (item.name != null ? item.name : (item.SEBU_CD_NM != null ? item.SEBU_CD_NM : item.dscr));
                const isSelected = (actualDefault && String(itemCode) === String(actualDefault)) ? 'selected' : '';
                const escapedCode = global.escapeHtml ? global.escapeHtml(itemCode) : itemCode;
                const escapedName = global.escapeHtml ? global.escapeHtml(itemName) : itemName;
                html += `<option value="${escapedCode}" ${isSelected}>${escapedName}</option>`;
            });
            selectEl.innerHTML = html;
            return list;
        });
    };

    /**
     * Helper to look up DDDW Label/Name by Code value (useful for Tabulator formatters)
     * Maps SEBU_CD (code) -> SEBU_CD_NM (name)
     *
     * Overload Signatures:
     *   f_dddwctl.getLabel(optionsMap, columnKey, codeVal)
     *   f_dddwctl.getLabel(dddwList, codeVal)
     *
     * @param {Object|Array} mapOrList DDDW options map or option list
     * @param {string|number} keyOrCode Column key if 3 args, or codeVal if 2 args
     * @param {string|number} [codeVal] Code value (SEBU_CD) to look up if 3 args
     * @returns {string} Matching name label (SEBU_CD_NM) or original codeVal if not found
     */
    f_dddwctl.getLabel = function (mapOrList, keyOrCode, codeVal) {
        let dddwList;
        let targetCode;

        if (arguments.length >= 3 || (typeof mapOrList === 'object' && !Array.isArray(mapOrList) && mapOrList !== null)) {
            // Overload 1: (optionsMap, columnKey, codeVal)
            dddwList = mapOrList ? mapOrList[keyOrCode] : null;
            targetCode = codeVal;
        } else {
            // Overload 2: (dddwList, codeVal)
            dddwList = mapOrList;
            targetCode = keyOrCode;
        }

        if (targetCode == null || targetCode === '') return '';
        if (!Array.isArray(dddwList)) return String(targetCode);

        const strCode = String(targetCode).trim();
        const found = dddwList.find(item => {
            if (!item) return false;
            const itemCodeRaw = item.code != null ? item.code : (item.SEBU_CD != null ? item.SEBU_CD : item.cd);
            if (itemCodeRaw == null) return false;
            const itemCode = String(itemCodeRaw).trim();
            if (itemCode === strCode) return true;
            if (strCode !== '' && itemCode !== '' && !isNaN(strCode) && !isNaN(itemCode) && Number(strCode) === Number(itemCode)) {
                return true;
            }
            return false;
        });

        if (!found) return String(targetCode);
        const itemName = (found.name != null ? found.name : (found.SEBU_CD_NM != null ? found.SEBU_CD_NM : found.dscr));
        return itemName != null ? itemName : String(targetCode);
    };

    // Expose to global window scope
    global.f_dddwctl = f_dddwctl;

    // Backward-compatible global alias for loadDddwOptions
    global.loadDddwOptions = function (selectId, dddwId, seq, addWhere, addOrderBy, defaultVal) {
        return f_dddwctl.loadOptions(selectId, dddwId, seq, addWhere, addOrderBy, defaultVal);
    };

})(typeof window !== 'undefined' ? window : this);
