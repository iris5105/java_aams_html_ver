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
                const rawList = Array.isArray(list) ? list : [];
                const normalizedList = rawList.map(item => {
                    const c = (item.code != null ? item.code : (item.SEBU_CD != null ? item.SEBU_CD : (item.cd != null ? item.cd : ''))).toString().trim();
                    const n = (item.name != null ? item.name : (item.SEBU_CD_NM != null ? item.SEBU_CD_NM : (item.dscr != null ? item.dscr : c))).toString().trim();
                    return {
                        code: c,
                        name: n,
                        // Backward-compatible aliases for legacy access
                        SEBU_CD: c,
                        SEBU_CD_NM: n,
                        cd: c,
                        dscr: n
                    };
                });

                if (prependHeaderItem) {
                    normalizedList.unshift({
                        code: prependHeaderItem.code,
                        name: prependHeaderItem.name,
                        SEBU_CD: prependHeaderItem.code,
                        SEBU_CD_NM: prependHeaderItem.name,
                        cd: prependHeaderItem.code,
                        dscr: prependHeaderItem.name
                    });
                }
                return normalizedList;
            })
            .catch(err => {
                console.warn(`[f_dddwctl] Error loading DDDW (${actualDddwId}):`, err);
                return prependHeaderItem ? [{ code: prependHeaderItem.code, name: prependHeaderItem.name }] : [];
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

    /**
     * Standard Tabulator editor: "list" valuesLookup helper
     * Formats options so that label is the code name (for display after selection)
     * and value is the code value.
     */
    f_dddwctl.getOptions = function (optionsMap, columnKey) {
        const list = (optionsMap && optionsMap[columnKey]) ? optionsMap[columnKey] : (Array.isArray(optionsMap) ? optionsMap : []);
        return list.map(item => {
            const code = (item.code != null ? item.code : (item.SEBU_CD != null ? item.SEBU_CD : (item.cd != null ? item.cd : ''))).toString().trim();
            const name = (item.name != null ? item.name : (item.SEBU_CD_NM != null ? item.SEBU_CD_NM : (item.dscr != null ? item.dscr : code))).toString().trim();
            return {
                label: name || code,
                value: code,
                code: code,
                name: name || code
            };
        });
    };

    /**
     * Standard 2-Column Dropdown Item Formatter for Tabulator List Editor (PowerBuilder DDDW Style)
     * Mandated by Development Guide Rule 6:
     * - Left column: Code (auto-adjusts width dynamically to longest code or manual width)
     * - Right column: Code Name (auto-adjusts width to fit longest name)
     * - Top: Sticky table header [ Code | Name ]
     * - Selection result on screen: Code Name
     *
     * Overload Signatures:
     *   f_dddwctl.get2ColItemFormatter() -> Auto-fit width, '코드', '명칭'
     *   f_dddwctl.get2ColItemFormatter(codeTitle, nameTitle) -> Auto-fit width, custom titles
     *   f_dddwctl.get2ColItemFormatter(codeWidth, codeTitle, nameTitle) -> Manual width, custom titles
     *
     * @param {number|string} [customCodeWidth] Optional manual code column width in px or code title
     * @param {string} [codeTitle='코드'] Title for code column header
     * @param {string} [nameTitle='명칭'] Title for name column header
     * @returns {function} Tabulator itemFormatter callback
     */
    f_dddwctl.get2ColItemFormatter = function (customCodeWidth, codeTitle, nameTitle) {
        let manualWidth = null;
        let cTitle = "코드";
        let nTitle = "명칭";

        if (typeof customCodeWidth === 'number' && customCodeWidth > 0) {
            manualWidth = customCodeWidth;
            if (codeTitle) cTitle = codeTitle;
            if (nameTitle) nTitle = nameTitle;
        } else if (typeof customCodeWidth === 'string') {
            cTitle = customCodeWidth;
            if (typeof codeTitle === 'string') nTitle = codeTitle;
        } else {
            if (codeTitle) cTitle = codeTitle;
            if (nameTitle) nTitle = nameTitle;
        }

        return function (label, value, item, element) {
            const code = (item && item.code != null) ? item.code : value;
            const name = (item && item.name != null) ? item.name : label;

            setTimeout(() => {
                if (element && element.parentElement) {
                    const listEl = element.parentElement;
                    listEl.classList.add('dddw-2col-list');

                    // 1. Insert sticky header row if not present
                    let header = listEl.querySelector('.dddw-header-row');
                    if (!header) {
                        header = document.createElement('div');
                        header.className = 'dddw-header-row';
                        header.innerHTML = `
                            <span class="dddw-hdr-code">${cTitle}</span>
                            <span class="dddw-hdr-name">${nTitle}</span>
                        `;
                        listEl.insertBefore(header, listEl.firstChild);
                    }

                    // 2. Auto-fit column widths dynamically based on the longest code badge in this list
                    if (!listEl.dataset.autoFitted) {
                        listEl.dataset.autoFitted = "true";

                        // Ensure listEl shrinks or expands tightly to its content
                        listEl.style.minWidth = "0px";
                        listEl.style.width = "max-content";

                        const applyAutoFit = () => {
                            const headerCode = header.querySelector('.dddw-hdr-code');
                            const codeBadges = listEl.querySelectorAll('.dddw-col-code');
                            if (!headerCode || codeBadges.length === 0) return;

                            let maxCodeW = manualWidth;
                            if (!manualWidth) {
                                headerCode.style.width = 'auto';
                                headerCode.style.minWidth = 'auto';
                                let maxW = headerCode.scrollWidth || 28;

                                codeBadges.forEach(b => {
                                    b.style.width = 'auto';
                                    b.style.minWidth = 'auto';
                                    const w = b.offsetWidth || b.scrollWidth;
                                    if (w > maxW) maxW = w;
                                });
                                // Add 4px comfort margin and ensure minimum 26px
                                maxCodeW = Math.max(26, maxW + 4);
                            }

                            // Apply uniform width to code column (header + all row badges)
                            headerCode.style.width = maxCodeW + 'px';
                            headerCode.style.minWidth = maxCodeW + 'px';
                            codeBadges.forEach(b => {
                                b.style.width = maxCodeW + 'px';
                                b.style.minWidth = maxCodeW + 'px';
                            });
                        };

                        applyAutoFit();
                        requestAnimationFrame(applyAutoFit);
                    }
                }
            }, 0);

            return `<div class="dddw-2col-row">
                <span class="dddw-col-code">${code}</span>
                <span class="dddw-col-name">${name}</span>
            </div>`;
        };
    };

    /**
     * Standard Filter Bar 2-Column DDDW Custom Dropdown Converter
     * Transforms a native <select> element into a 2-column DDDW dropdown widget:
     * - Shows code name on the select button
     * - Opens a 2-column list popup: [Code] [Code Name] with sticky header
     * - Auto-fits column and popup widths based on content
     * - Keeps native <select> value and 'change' event synchronized
     *
     * @param {HTMLSelectElement|string} targetSelect The native select element or its ID
     * @param {Array} options Array of {code, name} objects
     * @param {Object} [config] Configuration options: { codeTitle, nameTitle, defaultVal, placeholder }
     */
    f_dddwctl.create2ColSelect = function (targetSelect, options, config) {
        config = config || {};
        const el = (typeof targetSelect === 'string') ? document.getElementById(targetSelect) : targetSelect;
        if (!el) return null;

        const codeTitle = config.codeTitle || "코드";
        const nameTitle = config.nameTitle || "명칭";
        const defaultVal = (config.defaultVal != null) ? config.defaultVal : el.value;

        // Hide original select
        el.style.display = "none";

        // Check if wrapper already exists
        let wrapper = el.nextElementSibling;
        if (!wrapper || !wrapper.classList.contains("dddw-select-custom")) {
            wrapper = document.createElement("div");
            wrapper.className = "dddw-select-custom";
            el.parentNode.insertBefore(wrapper, el.nextSibling);
        }
        wrapper.innerHTML = "";

        // Create display button
        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = "dddw-select-btn";
        btn.innerHTML = `
            <span class="dddw-select-label">선택</span>
            <i class="fa-solid fa-chevron-down dddw-select-arrow"></i>
        `;
        wrapper.appendChild(btn);

        // Create popup container
        const popup = document.createElement("div");
        popup.className = "tabulator-edit-list dddw-2col-list dddw-select-popup";
        popup.style.display = "none";
        wrapper.appendChild(popup);

        // 1. Create sticky header
        const header = document.createElement("div");
        header.className = "dddw-header-row";
        header.innerHTML = `
            <span class="dddw-hdr-code">${codeTitle}</span>
            <span class="dddw-hdr-name">${nameTitle}</span>
        `;
        popup.appendChild(header);

        // 2. Create items
        const optList = options || [];
        let activeItemEl = null;

        optList.forEach(item => {
            const code = (item.code != null ? item.code : (item.SEBU_CD != null ? item.SEBU_CD : (item.cd != null ? item.cd : ''))).toString().trim();
            const name = (item.name != null ? item.name : (item.SEBU_CD_NM != null ? item.SEBU_CD_NM : (item.dscr != null ? item.dscr : code))).toString().trim();

            const itemEl = document.createElement("div");
            itemEl.className = "tabulator-edit-list-item";
            itemEl.dataset.value = code;
            itemEl.dataset.name = name;
            itemEl.innerHTML = `
                <div class="dddw-2col-row">
                    <span class="dddw-col-code">${code}</span>
                    <span class="dddw-col-name">${name}</span>
                </div>
            `;

            itemEl.addEventListener("click", (e) => {
                e.stopPropagation();
                selectValue(code, name, itemEl, true);
                closePopup();
            });

            popup.appendChild(itemEl);
        });

        function selectValue(code, name, itemEl, triggerChange) {
            el.value = code;
            btn.querySelector(".dddw-select-label").textContent = name ? name : code;

            popup.querySelectorAll(".tabulator-edit-list-item").forEach(it => it.classList.remove("active"));
            if (itemEl) {
                itemEl.classList.add("active");
                activeItemEl = itemEl;
            } else {
                const match = popup.querySelector(`.tabulator-edit-list-item[data-value="${code}"]`);
                if (match) {
                    match.classList.add("active");
                    activeItemEl = match;
                }
            }

            if (triggerChange) {
                el.dispatchEvent(new Event("change", { bubbles: true }));
            }
        }

        // Auto-fit code column width
        function adjustWidths() {
            const headerCode = header.querySelector(".dddw-hdr-code");
            const codeBadges = popup.querySelectorAll(".dddw-col-code");
            if (!headerCode || codeBadges.length === 0) return;

            headerCode.style.width = "auto";
            headerCode.style.minWidth = "auto";
            let maxW = headerCode.scrollWidth || 28;
            codeBadges.forEach(b => {
                b.style.width = "auto";
                b.style.minWidth = "auto";
                const w = b.offsetWidth || b.scrollWidth;
                if (w > maxW) maxW = w;
            });
            maxW = Math.max(26, maxW + 4);
            headerCode.style.width = maxW + "px";
            headerCode.style.minWidth = maxW + "px";
            codeBadges.forEach(b => {
                b.style.width = maxW + "px";
                b.style.minWidth = maxW + "px";
            });
        }

        function openPopup() {
            // Close other open popups first
            document.querySelectorAll(".dddw-select-custom.open").forEach(w => {
                if (w !== wrapper) {
                    w.classList.remove("open");
                    const p = w.querySelector(".dddw-select-popup");
                    if (p) p.style.display = "none";
                }
            });

            wrapper.classList.add("open");
            popup.style.display = "block";
            popup.style.width = "max-content";
            popup.style.minWidth = "0px";
            adjustWidths();
            if (activeItemEl) {
                activeItemEl.scrollIntoView({ block: "nearest" });
            }
        }

        function closePopup() {
            wrapper.classList.remove("open");
            popup.style.display = "none";
        }

        btn.addEventListener("click", (e) => {
            e.stopPropagation();
            if (wrapper.classList.contains("open")) {
                closePopup();
            } else {
                openPopup();
            }
        });

        // Click outside listener
        const outsideListener = function (e) {
            if (!wrapper.contains(e.target)) {
                closePopup();
            }
        };
        document.addEventListener("click", outsideListener);

        // Set initial selected value
        const initialCode = (defaultVal != null && defaultVal !== '') ? defaultVal : el.value;
        const found = optList.find(o => {
            const c = (o.code != null ? o.code : (o.SEBU_CD != null ? o.SEBU_CD : o.cd));
            return String(c).trim() === String(initialCode).trim();
        }) || optList[0];

        if (found) {
            const code = (found.code != null ? found.code : (found.SEBU_CD != null ? found.SEBU_CD : (found.cd != null ? found.cd : ''))).toString().trim();
            const name = (found.name != null ? found.name : (found.SEBU_CD_NM != null ? found.SEBU_CD_NM : (found.dscr != null ? found.dscr : code))).toString().trim();
            selectValue(code, name, null, false);
        }

        return wrapper;
    };

    // Expose to global window scope
    global.f_dddwctl = f_dddwctl;

    // Backward-compatible global alias for loadDddwOptions
    global.loadDddwOptions = function (selectId, dddwId, seq, addWhere, addOrderBy, defaultVal) {
        return f_dddwctl.loadOptions(selectId, dddwId, seq, addWhere, addOrderBy, defaultVal);
    };

})(typeof window !== 'undefined' ? window : this);
