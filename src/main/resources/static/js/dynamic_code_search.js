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

        function resolveAddWhere() {
            if (typeof options.addWhere === "function") {
                try {
                    return options.addWhere() || "";
                } catch (e) {
                    console.warn("DynamicCodeSearch addWhere function error:", e);
                    return "";
                }
            }
            return options.addWhere || "";
        }

        function openModalForCurrent() {
            const corpGr = getCorpGr();
            const addWhere = resolveAddWhere();
            openModal({
                columnNm: columnNm,
                seq: seq,
                corpGr: corpGr,
                addWhere: addWhere,
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
            const addWhere = resolveAddWhere();

            if (!trimmed) {
                if (textLabel) textLabel.textContent = "";
                lastValidatedCode = "";
                if (triggerCallback && typeof onSelect === "function") {
                    onSelect("", "", null);
                }
                return;
            }

            let url = `/api/common/code-search/get?columnNm=${encodeURIComponent(columnNm)}&seq=${seq}&corpGr=${encodeURIComponent(corpGr)}&code=${encodeURIComponent(trimmed)}`;
            if (addWhere) {
                url += `&addWhere=${encodeURIComponent(addWhere)}`;
            }

            fetch(url)
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
        const addWhere = typeof modalOptions.addWhere === "function" ? modalOptions.addWhere() : (modalOptions.addWhere || "");
        const onSelect = modalOptions.onSelect;

        // Remove existing modal if any
        closeModal();

        // 1. 단일 통합 API(/modal-data)를 통해 모달 틀(config)과 데이터 목록(list)을 1회 호출로 수신
        let modalUrl = `/api/common/code-search/modal-data?columnNm=${encodeURIComponent(columnNm)}&seq=${seq}&corpGr=${encodeURIComponent(corpGr)}`;
        if (addWhere) {
            modalUrl += `&addWhere=${encodeURIComponent(addWhere)}`;
        }

        fetch(modalUrl)
            .then(res => {
                if (!res.ok) throw new Error("HTTP " + res.status);
                return res.json();
            })
            .then(resData => {
                const config = resData ? (resData.config || {}) : {};
                const allData = resData ? (resData.list || []) : [];
                renderModalDOM(config, allData, initialKeyword, onSelect);
            })
            .catch(err => {
                console.error("Failed to load code search modal data:", err);
                if (typeof showToast === "function") {
                    showToast("코드 목록을 불러오는데 실패했습니다.", "error");
                } else {
                    alert("코드 목록을 불러오는데 실패했습니다: " + err.message);
                }
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
    /**
     * Render the modal DOM and handle interactions
     */
    function renderModalDOM(config, fullList, initialKeyword, onSelectCallback) {
        let title = (config && config.cmnt) ? config.cmnt : "코드(더블클릭) 선택";
        if (!title.includes("선택") && !title.includes("더블클릭")) {
            title += "(더블클릭) 선택";
        }

        // Headers: e.g. [{title: '자산분류(유형)'}, {title: '자산분류(유형)명'}]
        const rawHeaders = (config && config.headers && config.headers.length > 0) ? config.headers : [
            { title: "코드" },
            { title: "명칭" }
        ];

        // Column sizes parsing (if WDCS01M.column_size exists e.g. '10:80')
        let rawSizes = [];
        if (config && config.columnSize && typeof config.columnSize === "string") {
            rawSizes = config.columnSize.split(":").map(s => {
                const n = parseInt(s.trim(), 10);
                return isNaN(n) ? 0 : n;
            });
        }

        // 각 컬럼 너비 및 전체 그리드 너비 계산 (내부 그리드 너비에 딱 맞추기)
        let totalGridWidth = 50; // No. 컬럼 너비
        const headers = [{ title: "No.", width: 50, align: "center" }];

        rawHeaders.forEach((h, idx) => {
            let colW = 110;
            const t = (h.title || "").trim();

            if (rawSizes.length > idx && rawSizes[idx] > 0) {
                // column_size 값이 있으면 (파워빌더 문자수 기준: 약 9~10px per unit)
                colW = Math.max(80, Math.min(420, rawSizes[idx] * 9));
            } else if (t.includes("명") || t.includes("내역") || t.includes("내용") || t.includes("설명") || t.includes("한글")) {
                colW = 260; // 명칭 컬럼은 넉넉하게 260px
            } else if (t.includes("코드") || t.includes("펀드") || t.includes("종목") || t.includes("유형") || t.includes("분류") || t.includes("구분")) {
                colW = 120;
            } else if (t.length <= 3) {
                colW = 80;
            } else if (t.length <= 6) {
                colW = 110;
            } else {
                colW = 150;
            }

            const isAlignLeft = (t.includes("명") || t.includes("내역") || t.includes("내용") || t.includes("설명") || t.includes("한글"));
            headers.push({
                title: t,
                width: colW,
                align: isAlignLeft ? "left" : "center"
            });
            totalGridWidth += colW;
        });

        // 내부 그리드 너비에 맞춰 모달창 전체 너비(WIDTH) 자동 계산
        // 좌/우 5px 여백(총 10px), 테이블 테두리(2px), 스크롤바(약 16~18px) 및 여유분을 감안하여 모달 윈도우 너비 결정
        // 최소 420px (상단 검색창 및 타이틀 영역 가독성 보장), 최대 92vw
        const modalWidth = Math.max(420, Math.min(Math.round(window.innerWidth * 0.92), totalGridWidth + 34));

        // Create overlay
        const overlay = document.createElement("div");
        overlay.id = "aamsDynamicCodeSearchModal";
        overlay.className = "dynamic-code-modal-overlay";

        overlay.innerHTML = `
            <div class="dynamic-code-modal-window" style="width: ${modalWidth}px;">
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
                                    ${headers.map((h, i) => `<th style="width: ${h.width}px; text-align: ${h.align};">${escapeHtml(h.title)}</th>`).join("")}
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

                // Column values: No, Code, Name, ... (headers.length와 1:1 일치)
                const keys = Object.keys(item).filter(k => k !== "fseq" && k !== "codeVal" && k !== "codeName");
                const colValues = [ index + 1 ];

                rawHeaders.forEach((h, hIdx) => {
                    let val = "";
                    if (hIdx === 0) {
                        val = item.codeVal != null ? item.codeVal : (keys.length > 0 ? item[keys[0]] : "");
                    } else if (hIdx === 1) {
                        val = item.codeName != null ? item.codeName : (keys.length > 1 ? item[keys[1]] : "");
                    } else {
                        val = (keys.length > hIdx && item[keys[hIdx]] != null) ? item[keys[hIdx]] : "";
                    }
                    colValues.push(val != null ? String(val) : "");
                });

                tr.innerHTML = colValues.map((val, cIdx) => {
                    const headerDef = headers[cIdx] || { align: "center" };
                    return `<td style="text-align: ${headerDef.align};">${escapeHtml(String(val))}</td>`;
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
