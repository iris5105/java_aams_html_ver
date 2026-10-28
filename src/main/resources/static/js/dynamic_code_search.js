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
        if (existing) {
            if (existing._tabulatorInstance) {
                try { existing._tabulatorInstance.destroy(); } catch (e) {}
            }
            existing.remove();
        }
        document.removeEventListener("keydown", handleModalEscKey);
    }

    function handleModalEscKey(e) {
        if (e.key === "Escape") {
            closeModal();
        }
    }

    /**
     * Render the modal DOM with Tabulator grid and handle interactions
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

        // 각 컬럼 너비 및 전체 모달 너비 계산
        let totalGridWidth = 50; // No. 컬럼 너비
        const columns = [
            { title: "No.", formatter: "rownum", width: 50, hozAlign: "center", headerHozAlign: "center", headerSort: false, resizable: false }
        ];

        let firstDataField = "code";

        rawHeaders.forEach((h, idx) => {
            let colW = 110;
            const t = (h.title || "").trim();

            if (rawSizes.length > idx && rawSizes[idx] > 0) {
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
            const fieldKey = (idx === 0) ? "code" : (idx === 1 ? "name" : "col_" + idx);
            if (idx === 0) firstDataField = fieldKey;

            const colDef = {
                title: t,
                field: fieldKey,
                width: colW,
                hozAlign: isAlignLeft ? "left" : "center",
                headerHozAlign: "center",
                headerSort: true
            };

            // 첫 번째 데이터 컬럼(코드)에 표준 코드(ASCII) 및 '%' 우선 정렬 소터 지정
            if (idx === 0) {
                colDef.sorter = function(a, b, aRow, bRow, column, dir, sorterParams) {
                    const sA = String(a ?? "").trim();
                    const sB = String(b ?? "").trim();
                    if (sA === sB) return 0;
                    // 단독 '%' 전체 행은 항상 최우선 정렬
                    if (sA === "%") return -1;
                    if (sB === "%") return 1;
                    // 표준 ASCII 사전순 정렬 (자연 정렬 numeric:true 배제 -> 00000, 0IRIS, 0001A 등의 코드 왜곡 방지)
                    return (sA < sB) ? -1 : 1;
                };
            }

            columns.push(colDef);
            totalGridWidth += colW;
        });

        // 내부 그리드 너비에 맞춰 모달창 전체 너비(WIDTH) 자동 계산 (최소 440px ~ 최대 92vw)
        const modalWidth = Math.max(440, Math.min(Math.round(window.innerWidth * 0.92), totalGridWidth + 34));

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
                <div class="dynamic-code-modal-body" style="padding: 6px; flex: 1 1 auto; min-height: 0; display: flex; flex-direction: column;">
                    <div id="dynamicCodeSearchGrid" class="tabulator-aams-grid" style="width: 100%; height: 100%;"></div>
                </div>
            </div>
        `;

        document.body.appendChild(overlay);
        document.addEventListener("keydown", handleModalEscKey);

        const modalWindow = overlay.querySelector(".dynamic-code-modal-window");
        const closeBtn = overlay.querySelector(".dynamic-code-modal-close");
        const filterInput = overlay.querySelector(".dynamic-code-filter-input");
        const filterBtn = overlay.querySelector(".dynamic-code-filter-btn");
        const gridContainer = overlay.querySelector("#dynamicCodeSearchGrid");

        closeBtn.onclick = closeModal;
        // 창 외부(overlay 배경) 클릭 시 닫히는 현상 방지: x버튼 클릭 또는 그리드 더블클릭으로만 닫힘

        // 데이터 매핑: 각 행에 code, name, col_... 필드 바인딩
        const tableData = (fullList || []).map((item, idx) => {
            const keys = Object.keys(item).filter(k => k !== "fseq" && k !== "codeVal" && k !== "codeName");
            const codeVal = item.codeVal != null ? String(item.codeVal) : (keys.length > 0 ? String(item[keys[0]] ?? "") : "");
            const codeName = item.codeName != null ? String(item.codeName) : (keys.length > 1 ? String(item[keys[1]] ?? "") : "");

            const rowObj = {
                _raw: item,
                code: codeVal,
                name: codeName
            };

            rawHeaders.forEach((h, hIdx) => {
                const fieldKey = (hIdx === 0) ? "code" : (hIdx === 1 ? "name" : "col_" + hIdx);
                if (hIdx >= 2) {
                    rowObj[fieldKey] = (keys.length > hIdx && item[keys[hIdx]] != null) ? String(item[keys[hIdx]] ?? "") : "";
                }
            });

            return rowObj;
        });

        function chooseRow(rowObj) {
            if (!rowObj) return;
            const rawItem = rowObj._raw || rowObj;
            const code = rowObj.code != null ? String(rowObj.code) : "";
            const name = rowObj.name != null ? String(rowObj.name) : "";

            closeModal();
            if (typeof onSelectCallback === "function") {
                onSelectCallback(code, name, rawItem);
            }
        }

        // Tabulator 인스턴스 빌드 (현재 시스템의 .tabulator-aams-grid 스타일 적용)
        const tabulatorInstance = new Tabulator(gridContainer, {
            data: tableData,
            height: "100%",
            layout: "fitColumns",
            selectableRows: 1,
            headerSort: true,
            // [핵심] No. 컬럼을 제외한 첫 번째 데이터 컬럼 기준 오름차순 기본 정렬 적용
            initialSort: [
                { column: firstDataField, dir: "asc" }
            ],
            columns: columns,
            placeholder: "<div style='text-align:center; padding: 40px; color:#64748b;'>일치하는 데이터가 없습니다.</div>",
            rowFormatter: function(row) {
                const el = row.getElement();
                if (el) {
                    el.setAttribute("tabindex", "0");
                }
            }
        });

        overlay._tabulatorInstance = tabulatorInstance;

        let isFiltered = false;

        // [핵심 기능] 정렬된 첫 번째 보이는 행 선택 헬퍼 (shouldFocus가 true일 때만 DOM 포커스 이동)
        function selectFirstSortedRow(shouldFocus) {
            if (!tabulatorInstance) return;
            const visibleRows = tabulatorInstance.getRows("visible");
            if (!visibleRows || visibleRows.length === 0) return;

            tabulatorInstance.deselectRow();
            const firstRow = visibleRows[0];
            firstRow.select();
            try { firstRow.scrollTo("nearest", false); } catch (e) {
                try { firstRow.scrollTo(); } catch (err) {}
            }

            if (shouldFocus) {
                const rowEl = firstRow.getElement();
                if (rowEl) {
                    rowEl.setAttribute("tabindex", "0");
                    rowEl.focus();
                }
            }
        }
        const focusFirstSortedRow = () => selectFirstSortedRow(true);

        // 인덱스 기반 행 포커스 & 선택 이동 헬퍼
        function focusRowByIndex(idx) {
            if (!tabulatorInstance) return;
            const visibleRows = tabulatorInstance.getRows("visible");
            if (!visibleRows || visibleRows.length === 0) return;

            const nextIdx = Math.max(0, Math.min(visibleRows.length - 1, idx));
            const targetRow = visibleRows[nextIdx];
            tabulatorInstance.deselectRow();
            targetRow.select();
            try { targetRow.scrollTo("nearest", false); } catch (e) {
                try { targetRow.scrollTo(); } catch (err) {}
            }

            const rowEl = targetRow.getElement();
            if (rowEl) {
                rowEl.setAttribute("tabindex", "0");
                rowEl.focus();
            }
        }

        // 검색어 입력 시 현재 조회되어 있는 데이터 그리드의 위치로 스크롤 및 선택 이동
        function scrollToMatchingRow(kw) {
            if (!tabulatorInstance) return;

            // 이전에 필터가 적용되어 있었다면 전체 목록 복원
            if (isFiltered) {
                tabulatorInstance.clearFilter();
                isFiltered = false;
            }

            const term = (kw || "").trim().toLowerCase();
            const rows = tabulatorInstance.getRows();
            if (!rows || rows.length === 0) return;

            if (!term) {
                selectFirstSortedRow(false);
                return;
            }

            let targetRow = null;

            // 1순위: code 또는 name 컬럼의 접두사 일치 (startsWith)
            for (let i = 0; i < rows.length; i++) {
                const d = rows[i].getData();
                const c = (d.code != null ? String(d.code) : "").toLowerCase();
                const n = (d.name != null ? String(d.name) : "").toLowerCase();
                if (c.startsWith(term) || n.startsWith(term)) {
                    targetRow = rows[i];
                    break;
                }
            }

            // 2순위: code 또는 name 컬럼의 부분 일치 (includes)
            if (!targetRow) {
                for (let i = 0; i < rows.length; i++) {
                    const d = rows[i].getData();
                    const c = (d.code != null ? String(d.code) : "").toLowerCase();
                    const n = (d.name != null ? String(d.name) : "").toLowerCase();
                    if (c.includes(term) || n.includes(term)) {
                        targetRow = rows[i];
                        break;
                    }
                }
            }

            // 3순위: 기타 컬럼의 부분 일치 (includes)
            if (!targetRow) {
                for (let i = 0; i < rows.length; i++) {
                    const d = rows[i].getData();
                    let matched = false;
                    for (let key in d) {
                        if (key !== "_raw" && key !== "code" && key !== "name" && d[key] != null) {
                            if (String(d[key]).toLowerCase().includes(term)) {
                                matched = true;
                                break;
                            }
                        }
                    }
                    if (matched) {
                        targetRow = rows[i];
                        break;
                    }
                }
            }

            if (targetRow) {
                tabulatorInstance.deselectRow();
                targetRow.select();
                try {
                    targetRow.scrollTo("nearest", false);
                } catch (e) {
                    try { targetRow.scrollTo(); } catch (err) {}
                }
            }
        }

        // 엔터키 또는 필터조회 버튼 클릭 시 실행되는 필터 로직
        function applyFilter(kw) {
            if (!tabulatorInstance) return;
            const term = (kw || "").trim().toLowerCase();
            if (!term) {
                tabulatorInstance.clearFilter();
                isFiltered = false;
            } else {
                tabulatorInstance.setFilter(function(data) {
                    for (let key in data) {
                        if (key !== "_raw" && data[key] != null && String(data[key]).toLowerCase().includes(term)) {
                            return true;
                        }
                    }
                    return false;
                });
                isFiltered = true;
            }

            // 필터링 후 정렬된 첫 번째 보이는 행을 시각적으로 선택만 유지 (검색창 포커스 유지)
            setTimeout(() => selectFirstSortedRow(false), 30);
        }

        // 행 클릭 시 선택 및 포커스 부여
        tabulatorInstance.on("rowClick", function(e, row) {
            tabulatorInstance.deselectRow();
            row.select();
            const el = row.getElement();
            if (el) {
                el.setAttribute("tabindex", "0");
                el.focus();
            }
        });

        // 행 더블클릭 시 즉시 항목 선택 완료 및 창 닫기
        tabulatorInstance.on("rowDblClick", function(e, row) {
            chooseRow(row.getData());
        });

        // 테이블 빌드 완료 시 키워드가 있으면 위치 이동, 없으면 첫 행 선택
        tabulatorInstance.on("tableBuilt", function() {
            if (initialKeyword && initialKeyword.trim()) {
                scrollToMatchingRow(initialKeyword);
            } else {
                setTimeout(() => selectFirstSortedRow(false), 30);
            }
        });

        // 헤더 클릭 정렬 등 정렬 이벤트 발생 시 첫 번째 행으로 선택 동기화 (검색창 포커스 탈취 금지)
        tabulatorInstance.on("dataSorted", function() {
            const keepInputFocus = (document.activeElement === filterInput);
            setTimeout(() => selectFirstSortedRow(!keepInputFocus), 30);
        });

        // 실시간 검색어 입력 이벤트 (한글 조합 고려) -> 위치 이동만 실행
        filterInput.addEventListener("input", function() {
            scrollToMatchingRow(filterInput.value);
        });
        filterInput.addEventListener("compositionupdate", function() {
            scrollToMatchingRow(filterInput.value);
        });
        filterInput.addEventListener("compositionend", function() {
            scrollToMatchingRow(filterInput.value);
        });

        // 필터조회 버튼 클릭 -> 필터 실행
        filterBtn.onclick = function() {
            applyFilter(filterInput.value);
        };

        // 검색창 키보드 탐색: Enter키 입력 시 필터 조회 실행
        filterInput.onkeydown = function(e) {
            if (e.key === "Enter") {
                e.preventDefault();
                if (e.isComposing) return;
                applyFilter(filterInput.value);
            } else if (e.key === "ArrowDown") {
                e.preventDefault();
                selectFirstSortedRow(true);
            }
        };

        // 그리드 영역 키보드 탐색 (위/아래 방향키 행 이동, 문자 타이핑 시 검색창 인계)
        gridContainer.addEventListener("keydown", function(e) {
            const visibleRows = tabulatorInstance.getRows("visible");
            if (!visibleRows || visibleRows.length === 0) return;

            const selected = tabulatorInstance.getSelectedRows();
            let curIdx = 0;
            if (selected && selected.length > 0) {
                curIdx = visibleRows.indexOf(selected[0]);
                if (curIdx < 0) curIdx = 0;
            }

            if (e.key === "ArrowDown") {
                e.preventDefault();
                focusRowByIndex(curIdx + 1);
            } else if (e.key === "ArrowUp") {
                e.preventDefault();
                if (curIdx === 0) {
                    // 최상단 첫 번째 행에서 위로 가면 상단 검색창으로 포커스 전환
                    filterInput.focus();
                    if (filterInput.value) filterInput.select();
                } else {
                    focusRowByIndex(curIdx - 1);
                }
            } else if (e.key === "Escape") {
                e.preventDefault();
                closeModal();
            } else if (e.key.length === 1 && !e.ctrlKey && !e.altKey && !e.metaKey) {
                // 사용자가 행에 커서가 있는 상태에서 일반 문자/숫자/한글을 타이핑하면 상단 검색창으로 포커스 인계
                filterInput.focus();
                filterInput.value += e.key;
                scrollToMatchingRow(filterInput.value);
                e.preventDefault();
            }
        });

        // 모달창 오픈 시: 첫 행 선택 유지 및 검색창에 포커스 부여 (지속적인 검색어 입력 및 백스페이스 보장)
        setTimeout(() => {
            if (initialKeyword && initialKeyword.trim()) {
                scrollToMatchingRow(initialKeyword);
            } else {
                selectFirstSortedRow(false);
            }
            if (filterInput) {
                filterInput.focus();
                if (filterInput.value) filterInput.select();
            }
        }, 60);
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
