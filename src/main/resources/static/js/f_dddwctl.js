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
     *   f_dddwctl(dddwId, seq, corpGr, addWhere, addOrderBy)
     *   f_dddwctl(dddwId, seq, addWhere, addOrderBy)
     *
     * @param {string} dddwId DropDownDataWindow ID (e.g. 'CORP_GR', 'series_g1', 'type_gb', 'mg_cd')
     * @param {number|string} [seq=1] Sequence number
     * @param {string} [corpGr=""] Query variable value (e.g. targetCorpGr / "2200") to replace :corp_gr
     * @param {string} [addWhere=""] Dynamic WHERE clause (e.g. "corp_gr='2200'")
     * @param {string} [addOrderBy=""] Dynamic ORDER BY clause
     * @returns {Promise<Array<{code: string, name: string}>>}
     */
    function f_dddwctl(dddwId, param2, param3, param4, param5) {
        let actualDddwId = dddwId;
        let targetSeq = null;
        let actualCorpGr = "";
        let actualWhere = "";
        let actualOrderBy = "";
        let prependHeaderItem = null;

        // Check if 3rd parameter (param3) contains ',' to prepend header option item (e.g. '%,전체,')
        if (typeof param3 === 'string' && param3.includes(',')) {
            const parts = param3.split(',').map(s => s.trim());
            const codeVal = parts[0] || "";
            const nameVal = parts[1] || codeVal || "";
            // Ignore if only commas with no content (e.g. ',,', ',')
            if (codeVal !== "" || nameVal !== "") {
                prependHeaderItem = {
                    code: codeVal,
                    name: nameVal,
                    SEBU_CD: codeVal,
                    SEBU_CD_NM: nameVal,
                    cd: codeVal,
                    dscr: nameVal
                };
            }
        }

        // Helper to read cookie value
        function getCookieVal(name) {
            const value = `; ${document.cookie}`;
            const parts = value.split(`; ${name}=`);
            if (parts.length === 2) return decodeURIComponent(parts.pop().split(';').shift());
            return "";
        }

        const cookieAdmin = getCookieVal("admin") || getCookieVal("adminYn") || getCookieVal("role") || "";
        const isAdmin = (cookieAdmin === "Y" || cookieAdmin === "true" || cookieAdmin === "1" || String(cookieAdmin).toUpperCase() === "ADMIN");

        // 1. Standard JS signature: f_dddwctl(dddwId, seq, corpGr, addWhere, addOrderBy)
        if (typeof param2 === 'number' || (typeof param2 === 'string' && /^\d{1,2}$/.test(param2.trim()) && (param4 == null || isNaN(Number(param4))))) {
            targetSeq = parseInt(param2, 10);
            actualCorpGr = (param3 && !param3.includes(',')) ? param3 : "";
            actualWhere = param4 || "";
            actualOrderBy = param5 || "";
        } 
        // 2. HTML screen PB-mapped signature (without THIS): f_dddwctl(dddwId, corpGr, addWhere1, seq, addWhere2)
        //    [1] dddwId   : 'series_g1' / 'gugan'
        //    [2] corpGr   : targetCorpGr / ''
        //    [3] addWhere1/prependHeader: '%,전체,' / ',,' / ''
        //    [4] seq      : 1 / 9
        //    [5] addWhere2: "corp_gr='2402'" / '' (5th parameter WHERE clause - added ONLY IF NOT ADMIN)
        else {
            actualCorpGr = param2 || "";
            targetSeq = (param4 != null && !isNaN(Number(param4))) ? parseInt(param4, 10) : 1;
            
            // 5th parameter (param5) WHERE clause handling:
            // Omit ONLY IF it is strictly a direct single corp_gr='...' equality clause for ADMIN (e.g. "corp_gr='2402'").
            // Complex subqueries (e.g. "tr_co_cd in (select mg_cd from szm0ia where corp_gr='...')"), multi-column, or general conditions are ALWAYS included for everyone!
            if (param5) {
                const isDirectCorpGrOnly = /^\s*corp_gr\s*=\s*'[^']*'\s*$/i.test(param5.trim());
                if (isDirectCorpGrOnly) {
                    if (!isAdmin) {
                        actualWhere = param5;
                    } else {
                        actualWhere = ""; // Omit ONLY pure single corp_gr='...' clause for Admin
                    }
                } else {
                    actualWhere = param5; // Always include complex subqueries or general conditions
                }
            } else if (param3 && !param3.includes(',')) {
                actualWhere = param3;
            }
        }

        // Apply fallback seq 1 only if seq was omitted by caller
        if (targetSeq == null || isNaN(targetSeq)) {
            targetSeq = 1;
        }

        // Strip 'dddw |' if present and extract key text after '|'
        if (typeof actualDddwId === 'string' && actualDddwId.includes('|')) {
            actualDddwId = actualDddwId.split('|').pop().trim();
        }

        let url = `/api/common/dddw?dddwId=${encodeURIComponent(actualDddwId || 'corp_gr')}&seq=${encodeURIComponent(targetSeq)}`;
        if (actualCorpGr) url += `&corpGr=${encodeURIComponent(actualCorpGr)}`;
        if (actualWhere) url += `&addWhere=${encodeURIComponent(actualWhere)}`;
        if (actualOrderBy) url += `&addOrderBy=${encodeURIComponent(actualOrderBy)}`;

        // Use safeFetchJson if available, otherwise native fetch
        const fetchPromise = (typeof global.safeFetchJson === 'function')
            ? global.safeFetchJson(url)
            : fetch(url).then(res => res.ok ? res.json() : []);

        return fetchPromise
            .then(list => {
                const resultList = Array.isArray(list) ? list.slice() : [];
                if (prependHeaderItem) {
                    resultList.unshift(prependHeaderItem);
                }
                return resultList;
            })
            .catch(err => {
                console.warn(`[f_dddwctl] Error loading DDDW (${actualDddwId}):`, err);
                return prependHeaderItem ? [prependHeaderItem] : [];
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
