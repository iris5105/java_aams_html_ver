/**
 * AAMS Dynamic Code Search Component (u_dynamiccodesearch web implementation)
 * - Modal popup code search (ue_getcode)
 * - Inline input code validation (ue_setcode)
 * - Display format: (Code) CodeName
 */
window.DynamicCodeSearch = (function() {

    // Helper: resolve CorpGr (Guideline 1: No default hardcoded value)
    function resolveCorpGr() {
        if (window.currentCorpGr) return window.currentCorpGr;

        const globalSelect = document.getElementById("corpGrSelect");
        if (globalSelect && globalSelect.value) return globalSelect.value;

        const matchSaved = document.cookie.match(/(?:^|;\s*)savedCorpGr=([^;]*)/);
        if (matchSaved && matchSaved[1]) return decodeURIComponent(matchSaved[1]);

        const matchCorp = document.cookie.match(/(?:^|;\s*)corpGr=([^;]*)/);
        if (matchCorp && matchCorp[1]) return decodeURIComponent(matchCorp[1]);

        return "";
    }

    /**
     * Bind a code search component to an input, search button, and name label
     * @param {Object} options
     *   - inputEl: input element or selector (e.g. '#filterXx')
     *   - btnEl: search button element or selector (e.g. '#btnCodeSearchXx')
     *   - textEl: label span element or selector (e.g. '#textXxName')
     *   - columnNm: column name in WDCS01M (e.g. 'rcd')
     *   - seq: column seq in WDCS01M (e.g. 2)
     *   - pane: container element (optional)
     *   - getCorpGr: function returning current corpGr (optional)
     *   - onSelect: callback function(code, name, rowData)
     */
    function bind(options) {
        if (!options) return null;

        const pane = options.pane || document;
        let input = typeof options.inputEl === "string" ? (pane.querySelector(options.inputEl) || document.querySelector(options.inputEl)) : options.inputEl;
        let btn = typeof options.btnEl === "string" ? (pane.querySelector(options.btnEl) || document.querySelector(options.btnEl)) : options.btnEl;
        let textLabel = typeof options.textEl === "string" ? (pane.querySelector(options.textEl) || document.querySelector(options.textEl)) : options.textEl;

        const columnNm = options.columnNm || (input ? input.getAttribute("data-column-nm") : "rcd") || "rcd";
        const seq = options.seq || (input ? parseInt(input.getAttribute("data-seq") || "2", 10) : 2) || 2;
        const getCorpGr = options.getCorpGr || resolveCorpGr;
        const onSelect = options.onSelect || null;

        if (!input) {
            console.warn("DynamicCodeSearch.bind: input element not found for", options.inputEl);
            return null;
        }

        // Prevent double binding
        if (input._dcs_bound) {
            return input._dcs_instance || null;
        }
        input._dcs_bound = true;

        let lastValidatedCode = input.value ? input.value.trim() : null;

        function openModalForCurrent() {
            const corpGr = getCorpGr();
            openModal({
                columnNm: columnNm,
                seq: seq,
                corpGr: corpGr,
                initialKeyword: input.value ? input.value.trim() : "",
                onSelect: function(selectedCode, selectedName, rowData) {
                    input.value = selectedCode;
                    if (textLabel) {
                        textLabel.textContent = `(${selectedCode}) ${selectedName}`;
                    }
                    lastValidatedCode = selectedCode;
                    if (typeof onSelect === "function") {
                        onSelect(selectedCode, selectedName, rowData);
                    }
                }
            });
        }

        function validateAndApply(codeVal, triggerCallback) {
            const corpGr = getCorpGr();
            const trimmed = (codeVal || "").trim();

            if (!trimmed) {
                if (textLabel) textLabel.textContent = "";
                lastValidatedCode = "";
                if (triggerCallback && typeof onSelect === "function") {
                    onSelect("", "", null);
                }
                return;
            }

            fetch(`/api/common/code-search/get?columnNm=${encodeURIComponent(columnNm)}&seq=${seq}&corpGr=${encodeURIComponent(corpGr)}&code=${encodeURIComponent(trimmed)}`)
                .then(res => res.json())
                .then(data => {
                    if (data && data.code) {
                        lastValidatedCode = data.code;
                        input.value = data.code;
                        if (textLabel) {
                            textLabel.textContent = data.display || `(${data.code}) ${data.codeName || ''}`;
                        }
                        if (triggerCallback && typeof onSelect === "function") {
                            onSelect(data.code, data.codeName, data);
                        }
                    } else {
                        // 일치하는 단일 코드가 없으면 모달창을 오픈하여 검색 유도
                        openModalForCurrent();
                    }
                })
                .catch(err => {
                    console.error("DynamicCodeSearch validate error:", err);
                    openModalForCurrent();
                });
        }

        // Enter key in input
        input.addEventListener("keydown", function(e) {
            if (e.key === "Enter") {
                e.preventDefault();
                const trimmed = (input.value || "").trim();
                if (!trimmed) {
                    openModalForCurrent();
                } else {
                    validateAndApply(input.value, true);
                }
            }
        });

        // Focus out (blur)
        input.addEventListener("blur", function() {
            setTimeout(() => {
                // 모달창이 열린 상태가 아니면 blur 검증
                if (document.getElementById("aamsDynamicCodeSearchModal")) return;
                if (input.value.trim() !== (lastValidatedCode || "")) {
                    validateAndApply(input.value, true);
                }
            }, 150);
        });

        // 2. Magnifying glass button click (ue_getcode)
        if (btn) {
            btn._dcs_bound = true;
            btn.addEventListener("click", function(e) {
                e.preventDefault();
                e.stopPropagation();
                openModalForCurrent();
            });
        }

        const instance = {
            setValue: function(codeVal) {
                validateAndApply(codeVal, false);
            },
            getValue: function() {
                return input.value;
            },
            clear: function() {
                input.value = "";
                if (textLabel) textLabel.textContent = "";
                lastValidatedCode = "";
            },
            openModal: openModalForCurrent
        };

        input._dcs_instance = instance;
        return instance;
    }

    /**
     * Open Modal Code Search Popup (w_DynamicCodeSearch)
     */
    function openModal(modalOptions) {
        if (!modalOptions) modalOptions = {};
        const columnNm = modalOptions.columnNm || "rcd";
        const seq = modalOptions.seq || 2;
        const corpGr = modalOptions.corpGr || resolveCorpGr();
        const initialKeyword = modalOptions.initialKeyword || "";
        const onSelect = modalOptions.onSelect;

        // Remove existing modal if any
        closeModal();

        // 1. Fetch Config and initial List in parallel
        Promise.all([
            fetch(`/api/common/code-search/config?columnNm=${encodeURIComponent(columnNm)}&seq=${seq}`).then(res => res.json()),
            fetch(`/api/common/code-search/list?columnNm=${encodeURIComponent(columnNm)}&seq=${seq}&corpGr=${encodeURIComponent(corpGr)}`).then(res => res.json())
        ]).then(([config, allData]) => {
            renderModalDOM(config, allData, initialKeyword, onSelect);
        }).catch(err => {
            console.error("Failed to load code search modal data:", err);
            alert("코드 목록을 불러오는데 실패했습니다: " + err.message);
        });
    }

    function closeModal() {
        const existing = document.getElementById("aamsDynamicCodeSearchModal");
        if (existing) existing.remove();
        document.removeEventListener("keydown", handleModalEscKey);
    }

    function handleModalEscKey(e) {
        if (e.key === "Escape") {
            closeModal();
        }
    }

    /**
     * Render the modal DOM and handle interactions
     */
    function renderModalDOM(config, fullList, initialKeyword, onSelectCallback) {
        let title = (config && config.cmnt) ? config.cmnt : "모펀드(더블클릭) 선택";
        if (!title.includes("선택") && !title.includes("더블클릭")) {
            title += "(더블클릭) 선택";
        }

        // Headers: e.g. [{title: '펀드'}, {title: '펀드명'}, {title: '기준통화'}]
        const rawHeaders = (config && config.headers) ? config.headers : [
            { title: "펀드" },
            { title: "펀드명" },
            { title: "기준통화" }
        ];
        const headers = [{ title: "No.", width: "45px" }];
        rawHeaders.forEach(h => {
            let w = "80px";
            if (h.title.includes("명")) w = "170px";
            else if (h.title.includes("코드") || h.title.includes("펀드")) w = "75px";
            headers.push({ title: h.title, width: w });
        });

        // Create overlay
        const overlay = document.createElement("div");
        overlay.id = "aamsDynamicCodeSearchModal";
        overlay.className = "dynamic-code-modal-overlay";

        overlay.innerHTML = `
            <div class="dynamic-code-modal-window">
                <div class="dynamic-code-modal-header">
                    <div class="dynamic-code-modal-title">
                        <span class="modal-icon-badge"><i class="fa-solid fa-list-check"></i></span>
                        <span class="modal-title-text">${escapeHtml(title)}</span>
                    </div>
                    <button type="button" class="dynamic-code-modal-close" title="닫기">&times;</button>
                </div>
                <div class="dynamic-code-modal-filter">
                    <input type="text" class="dynamic-code-filter-input" placeholder="검색어 입력..." value="${escapeHtml(initialKeyword)}" />
                    <button type="button" class="dynamic-code-filter-btn">필터조회</button>
                </div>
                <div class="dynamic-code-modal-body">
                    <div class="dynamic-code-table-wrapper">
                        <table class="dynamic-code-table">
                            <thead>
                                <tr>
                                    ${headers.map((h, i) => `<th style="width: ${h.width}; text-align: ${i === 2 ? 'left' : 'center'};">${escapeHtml(h.title)}</th>`).join("")}
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Rows injected dynamically -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        `;

        document.body.appendChild(overlay);
        document.addEventListener("keydown", handleModalEscKey);

        const modalWindow = overlay.querySelector(".dynamic-code-modal-window");
        const closeBtn = overlay.querySelector(".dynamic-code-modal-close");
        const filterInput = overlay.querySelector(".dynamic-code-filter-input");
        const filterBtn = overlay.querySelector(".dynamic-code-filter-btn");
        const tbody = overlay.querySelector("tbody");

        closeBtn.onclick = closeModal;
        overlay.onclick = function(e) {
            if (e.target === overlay) closeModal();
        };

        // Filter Rows logic
        let currentFilteredList = [];
        let selectedRowIndex = 0;

        function applyFilter(kw) {
            const term = (kw || "").trim().toLowerCase();
            const list = fullList || [];
            if (!term) {
                currentFilteredList = list.slice();
            } else {
                currentFilteredList = list.filter(item => {
                    for (let key in item) {
                        if (item[key] != null && String(item[key]).toLowerCase().includes(term)) {
                            return true;
                        }
                    }
                    return false;
                });
            }

            renderTableRows();
        }

        function renderTableRows() {
            tbody.innerHTML = "";
            selectedRowIndex = 0;

            if (currentFilteredList.length === 0) {
                tbody.innerHTML = `<tr><td colspan="${headers.length}" style="text-align: center; height: 260px; line-height: 260px; color: #64748b; font-size: 13px;">일치하는 데이터가 없습니다.</td></tr>`;
                return;
            }

            currentFilteredList.forEach((item, index) => {
                const tr = document.createElement("tr");
                tr.className = "dynamic-code-row" + (index === 0 ? " selected" : "");
                tr.setAttribute("data-index", index);

                // Column values: No, Code, Name, Currency (or rest)
                const keys = Object.keys(item).filter(k => k !== "fseq" && k !== "codeVal" && k !== "codeName");
                const colValues = [
                    index + 1,
                    item.codeVal != null ? item.codeVal : (keys.length > 0 ? item[keys[0]] : ""),
                    item.codeName != null ? item.codeName : (keys.length > 1 ? item[keys[1]] : ""),
                    keys.length > 2 && item[keys[2]] != null ? item[keys[2]] : ""
                ];

                tr.innerHTML = colValues.map((val, cIdx) => {
                    const align = cIdx === 2 ? "left" : "center";
                    return `<td style="text-align: ${align};">${escapeHtml(String(val))}</td>`;
                }).join("");

                // Click select
                tr.onclick = function() {
                    tbody.querySelectorAll(".dynamic-code-row").forEach(r => r.classList.remove("selected"));
                    tr.classList.add("selected");
                    selectedRowIndex = index;
                };

                // Double click choose
                tr.ondblclick = function() {
                    chooseItem(item);
                };

                tbody.appendChild(tr);
            });
        }

        function chooseItem(item) {
            if (!item) return;
            const keys = Object.keys(item).filter(k => k !== "fseq" && k !== "codeVal" && k !== "codeName");
            const code = item.codeVal != null ? String(item.codeVal) : (keys.length > 0 ? String(item[keys[0]]) : "");
            const name = item.codeName != null ? String(item.codeName) : (keys.length > 1 ? String(item[keys[1]]) : "");

            closeModal();
            if (typeof onSelectCallback === "function") {
                onSelectCallback(code, name, item);
            }
        }

        // 1. Real-time live filtering on input (typing, IME composition, deletion)
        filterInput.addEventListener("input", function() {
            applyFilter(filterInput.value);
        });
        filterInput.addEventListener("compositionupdate", function() {
            applyFilter(filterInput.value);
        });
        filterInput.addEventListener("compositionend", function() {
            applyFilter(filterInput.value);
        });

        // 2. Filter button click
        filterBtn.onclick = function() {
            applyFilter(filterInput.value);
        };

        // 3. Filter input keydown navigation & selection
        filterInput.onkeydown = function(e) {
            if (e.key === "Enter") {
                e.preventDefault();
                if (e.isComposing) return;

                if (currentFilteredList && currentFilteredList.length > 0) {
                    const targetIndex = (selectedRowIndex >= 0 && selectedRowIndex < currentFilteredList.length) ? selectedRowIndex : 0;
                    chooseItem(currentFilteredList[targetIndex]);
                }
            } else if (e.key === "ArrowDown") {
                e.preventDefault();
                moveSelection(1);
            } else if (e.key === "ArrowUp") {
                e.preventDefault();
                moveSelection(-1);
            }
        };

        // Table keyboard navigation
        function moveSelection(delta) {
            const rows = tbody.querySelectorAll(".dynamic-code-row");
            if (rows.length === 0) return;
            selectedRowIndex = Math.max(0, Math.min(rows.length - 1, selectedRowIndex + delta));
            rows.forEach((r, idx) => {
                if (idx === selectedRowIndex) {
                    r.classList.add("selected");
                    r.scrollIntoView({ block: "nearest" });
                } else {
                    r.classList.remove("selected");
                }
            });
        }

        // Keyboard Enter on modal window to choose selected row
        modalWindow.onkeydown = function(e) {
            if (e.key === "Enter" && e.target !== filterInput) {
                if (currentFilteredList[selectedRowIndex]) {
                    chooseItem(currentFilteredList[selectedRowIndex]);
                }
            }
        };

        // Initial render & focus
        applyFilter(initialKeyword);
        setTimeout(() => {
            filterInput.focus();
            if (filterInput.value) filterInput.select();
        }, 50);
    }

    function escapeHtml(str) {
        if (str == null) return "";
        return String(str)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    // =========================================================================
    // Global Event Delegation (Fallback for any .btn-code-search and .code-search-input)
    // Ensures magnifying glass click & input Enter always work regardless of timing
    // =========================================================================
    document.addEventListener("click", function(e) {
        const btn = e.target.closest(".btn-code-search");
        if (!btn) return;
        // If already bound by bind(), the local listener handles it
        if (btn._dcs_bound) return;

        const wrapper = btn.closest(".code-search-input-wrapper") || btn.closest(".filter-code-search-item");
        const input = wrapper ? wrapper.querySelector(".code-search-input, input[type='text']") : null;
        const textLabel = wrapper ? (wrapper.parentElement.querySelector(".code-search-name") || wrapper.querySelector(".code-search-name")) : null;

        const columnNm = btn.getAttribute("data-column-nm") || (input ? input.getAttribute("data-column-nm") : null) || "rcd";
        const seq = parseInt(btn.getAttribute("data-seq") || (input ? input.getAttribute("data-seq") : "2"), 10) || 2;
        const corpGr = resolveCorpGr();

        e.preventDefault();
        e.stopPropagation();

        openModal({
            columnNm: columnNm,
            seq: seq,
            corpGr: corpGr,
            initialKeyword: input ? input.value.trim() : "",
            onSelect: function(code, name, rowData) {
                if (input) input.value = code;
                if (textLabel) textLabel.textContent = `(${code}) ${name}`;
                if (input) input.dispatchEvent(new Event("change", { bubbles: true }));
                const pane = btn.closest(".tab-pane");
                if (pane && typeof pane.onSearch === "function") {
                    pane.onSearch();
                }
            }
        });
    });

    document.addEventListener("keydown", function(e) {
        if (e.key !== "Enter") return;
        const input = e.target.closest(".code-search-input");
        if (!input) return;
        if (input.classList.contains("dynamic-code-filter-input")) return;
        // If already bound by bind(), the local listener handles it
        if (input._dcs_bound) return;

        e.preventDefault();
        e.stopPropagation();

        const wrapper = input.closest(".code-search-input-wrapper") || input.closest(".filter-code-search-item");
        const btn = wrapper ? wrapper.querySelector(".btn-code-search") : null;
        const textLabel = wrapper ? (wrapper.parentElement.querySelector(".code-search-name") || wrapper.querySelector(".code-search-name")) : null;

        const columnNm = input.getAttribute("data-column-nm") || (btn ? btn.getAttribute("data-column-nm") : null) || "rcd";
        const seq = parseInt(input.getAttribute("data-seq") || (btn ? btn.getAttribute("data-seq") : "2"), 10) || 2;
        const corpGr = resolveCorpGr();
        const codeVal = (input.value || "").trim();

        if (!codeVal) {
            openModal({
                columnNm: columnNm,
                seq: seq,
                corpGr: corpGr,
                initialKeyword: "",
                onSelect: function(code, name, rowData) {
                    input.value = code;
                    if (textLabel) textLabel.textContent = `(${code}) ${name}`;
                    input.dispatchEvent(new Event("change", { bubbles: true }));
                    const pane = input.closest(".tab-pane");
                    if (pane && typeof pane.onSearch === "function") {
                        pane.onSearch();
                    }
                }
            });
            return;
        }

        fetch(`/api/common/code-search/get?columnNm=${encodeURIComponent(columnNm)}&seq=${seq}&corpGr=${encodeURIComponent(corpGr)}&code=${encodeURIComponent(codeVal)}`)
            .then(res => res.json())
            .then(data => {
                if (data && data.code) {
                    input.value = data.code;
                    if (textLabel) textLabel.textContent = data.display || `(${data.code}) ${data.codeName || ''}`;
                    input.dispatchEvent(new Event("change", { bubbles: true }));
                    const pane = input.closest(".tab-pane");
                    if (pane && typeof pane.onSearch === "function") {
                        pane.onSearch();
                    }
                } else {
                    openModal({
                        columnNm: columnNm,
                        seq: seq,
                        corpGr: corpGr,
                        initialKeyword: codeVal,
                        onSelect: function(code, name, rowData) {
                            input.value = code;
                            if (textLabel) textLabel.textContent = `(${code}) ${name}`;
                            input.dispatchEvent(new Event("change", { bubbles: true }));
                            const pane = input.closest(".tab-pane");
                            if (pane && typeof pane.onSearch === "function") {
                                pane.onSearch();
                            }
                        }
                    });
                }
            })
            .catch(err => {
                console.error("Global keydown code validate error:", err);
            });
    });

    return {
        bind: bind,
        openModal: openModal,
        closeModal: closeModal
    };
})();
