/**
 * AAMS MDI Toolbar Button Action Handlers (button.js)
 * Manages standard toolbar actions (닫기, 새로고침, 조회, 입력, 저장, 엑셀)
 * Fully decoupled architecture: 0% hardcoded screen names, contract-based auto discovery
 */

/**
 * Helper: Find active tab pane or current view container
 * @param {HTMLElement} btn - Clicked button element
 * @returns {HTMLElement} - Scoped pane container
 */
function getActiveTabPane(btn) {
    if (btn) {
        const p = btn.closest('.tab-pane') || btn.closest('.view-container');
        if (p) return p;
    }
    return document.querySelector('.tab-pane.active') || document.querySelector('.view-container') || document;
}

/**
 * Toolbar Action: [닫기] (Close Current Active Tab)
 * @param {HTMLElement} btn
 */
function onToolbarClose(btn) {
    if (window.tabManager && typeof window.tabManager.closeCurrentTab === 'function') {
        window.tabManager.closeCurrentTab();
    }
}

/**
 * Toolbar Action: [입력] (Insert New Row into Master Grid)
 * @param {HTMLElement} btn
 */
function onToolbarInput(btn) {
    const pane = getActiveTabPane(btn);
    if (!pane) return;

    // 1. Check pane-scoped custom onInput / onInsert handler
    if (typeof pane.onInput === 'function') {
        pane.onInput(btn);
        return;
    }
    if (typeof pane.onInsert === 'function') {
        pane.onInsert(btn);
        return;
    }

    // 2. Generic Automatic Master Grid Discovery and Row Insertion
    const gridEl = pane.querySelector('#master-grid')
                || pane.querySelector('.master-grid-section .tabulator-aams-grid')
                || pane.querySelector('.master-grid-wrapper .tabulator-aams-grid')
                || pane.querySelector('.tabulator-aams-grid');

    if (gridEl && typeof Tabulator !== 'undefined' && typeof Tabulator.findTable === 'function') {
        let table = Tabulator.findTable(gridEl);
        if (Array.isArray(table)) {
            table = table[0];
        }
        if (table && typeof table.addRow === 'function') {
            let newRowData = { isNew: true };
            if (typeof pane.getNewRowData === 'function') {
                newRowData = Object.assign(newRowData, pane.getNewRowData() || {});
            } else {
                const filterSelect = pane.querySelector('select[name="corpGr"]') || pane.querySelector('#filterCorpGr');
                if (filterSelect && filterSelect.value) {
                    newRowData.corpGr = filterSelect.value;
                }
            }

            table.addRow(newRowData, true).then(function(newRow) {
                table.deselectRow();
                newRow.select();
                try { newRow.scrollTo(); } catch (e) {}

                if (typeof pane.onRowSelect === 'function') {
                    pane.onRowSelect(newRow.getData(), newRow);
                }

                pane.dispatchEvent(new CustomEvent('masterRowInserted', {
                    bubbles: true,
                    detail: { row: newRow, data: newRow.getData() }
                }));
            }).catch(function(err) {
                console.warn("Tabulator addRow warning:", err);
            });
            return;
        }
    }

    // 3. Fallback to global onInput if exists and is not this function
    if (typeof window.onInput === 'function' && window.onInput !== onToolbarInput) {
        window.onInput(btn);
    }
}

/**
 * Helper: 어떤 화면이든 해당 pane(또는 viewContainer)에 속한 모든 Tabulator 인스턴스를 자동 탐색하여 초기화
 * 100% 자동 감지(Auto-Discovery) - 0% 하드코딩으로 모든 화면의 Tabulator 데이터를 완전히 비움
 * @param {HTMLElement} pane
 * @returns {number} 초기화된 Tabulator 인스턴스 수
 */
function clearAllTabulatorsInPane(pane) {
    if (!pane) return 0;

    const tablesToClear = new Set();

    // 1. Tabulator 전역 레지스트리 탐색 (Tabulator v5/v6 표준 내부 레지스트리)
    try {
        if (typeof Tabulator !== 'undefined') {
            const registry = Tabulator.registry || (Tabulator.__proto__ && Tabulator.__proto__.registry);
            if (registry && Array.isArray(registry.tables)) {
                registry.tables.forEach(tbl => {
                    if (tbl && tbl.element) {
                        if (pane === document || pane.contains(tbl.element)) {
                            tablesToClear.add(tbl);
                        }
                    }
                });
            }
        }
    } catch (e) {
        console.warn('[clearAllTabulatorsInPane] 전역 레지스트리 조회 중 예외:', e);
    }

    // 2. DOM 엘리먼트 기반 탐색 (Tabulator.findTable)
    try {
        if (typeof Tabulator !== 'undefined' && typeof Tabulator.findTable === 'function') {
            const gridEls = pane.querySelectorAll('.tabulator, .tabulator-aams-grid, [id$="-grid"], [id*="grid"], [class*="grid"]');
            gridEls.forEach(el => {
                try {
                    const found = Tabulator.findTable(el);
                    if (found) {
                        if (Array.isArray(found)) {
                            found.forEach(t => { if (t) tablesToClear.add(t); });
                        } else {
                            tablesToClear.add(found);
                        }
                    }
                } catch (e) {}
            });
        }
    } catch (e) {
        console.warn('[clearAllTabulatorsInPane] DOM 엘리먼트 기반 조회 중 예외:', e);
    }

    // 3. pane 및 하위/상위 컨테이너에 직접 바인딩된 Tabulator 객체 탐색
    try {
        const containers = [pane];
        const vc = pane.querySelector ? pane.querySelector('.view-container') : null;
        if (vc && vc !== pane) containers.push(vc);
        const pp = pane.closest ? pane.closest('.tab-pane') : null;
        if (pp && pp !== pane) containers.push(pp);

        containers.forEach(c => {
            if (!c) return;
            for (let prop in c) {
                try {
                    const obj = c[prop];
                    if (obj && typeof obj.clearData === 'function' && typeof obj.deselectRow === 'function') {
                        tablesToClear.add(obj);
                    }
                } catch (e) {}
            }
        });
    } catch (e) {}

    // 4. 발견된 모든 Tabulator 인스턴스에 대해 clearData 및 deselectRow 강제 실행
    tablesToClear.forEach(tbl => {
        try {
            if (typeof tbl.clearData === 'function') {
                tbl.clearData();
            }
            if (typeof tbl.deselectRow === 'function') {
                tbl.deselectRow();
            }
        } catch (err) {
            console.warn('[clearAllTabulatorsInPane] 테이블 데이터 초기화 중 경고:', err);
        }
    });

    return tablesToClear.size;
}

/**
 * Toolbar Action: [새로고침] (Reset Active Tab to initial state)
 * 개발지침: 새로고침 버튼은 수정사항이나 조회한 내용을 초기화하여 화면에서 데이터를 조회하기 전인 초기화 상태로 되돌린다.
 * 어떤 화면이든 새로고침 버튼을 눌렀을 때 tabulator의 데이터를 반드시 초기화한다.
 * @param {HTMLElement} btn
 */
function onToolbarRefresh(btn) {
    const pane = getActiveTabPane(btn);
    if (!pane) return;

    // 1. [선행 안전망] 어떤 화면이든 무조건 해당 탭 내의 모든 Tabulator 그리드 데이터 초기화
    clearAllTabulatorsInPane(pane);

    // 2. 화면 전용 초기화(onRefresh / onReset) 계약 함수 우선 실행
    let customRefreshed = false;
    const containers = [pane];
    const vc = pane.querySelector ? pane.querySelector('.view-container') : null;
    if (vc && vc !== pane) containers.push(vc);
    const pp = pane.closest ? pane.closest('.tab-pane') : null;
    if (pp && pp !== pane) containers.push(pp);

    for (const c of containers) {
        if (c && typeof c.onRefresh === 'function') {
            try {
                c.onRefresh(btn);
                customRefreshed = true;
                break;
            } catch (err) {
                console.warn('[onToolbarRefresh] onRefresh 실행 중 오류:', err);
            }
        } else if (c && typeof c.onReset === 'function') {
            try {
                c.onReset(btn);
                customRefreshed = true;
                break;
            } catch (err) {
                console.warn('[onToolbarRefresh] onReset 실행 중 오류:', err);
            }
        }
    }

    // 3. 커스텀 초기화가 없었던 경우 기본 폼/입력 필드 초기화 폴백
    if (!customRefreshed) {
        try {
            const forms = pane.querySelectorAll('form');
            forms.forEach(f => f.reset());

            const textareas = pane.querySelectorAll('textarea');
            textareas.forEach(t => t.value = '');

            if (typeof showToast === 'function') {
                showToast("화면이 초기화되었습니다.", "info");
            }
        } catch (err) {
            console.warn('[onToolbarRefresh] 기본 초기화 처리 중 경고:', err);
        }
    }

    // 4. [후행 안전망] 커스텀 onRefresh 실행 후에도 다시 한 번 모든 Tabulator 그리드가 완전히 비워졌는지 확인 및 초기화
    clearAllTabulatorsInPane(pane);

    if (typeof window.onRefresh === 'function' && window.onRefresh !== onToolbarRefresh) {
        try {
            window.onRefresh(btn);
        } catch (e) {}
    }
}

/**
 * Toolbar Action: [조회] (Search Active Tab)
 * @param {HTMLElement} btn
 */
function onToolbarSearch(btn) {
    const pane = getActiveTabPane(btn);
    if (!pane) return;

    if (typeof pane.onSearch === 'function') {
        pane.onSearch(btn);
        return;
    }
    if (typeof pane.loadData === 'function') {
        pane.loadData();
        return;
    }
    if (typeof pane.onCorpGrChange === 'function') {
        const filterSelect = pane.querySelector('select[name="corpGr"]') || pane.querySelector('#filterCorpGr');
        const val = filterSelect ? filterSelect.value : "";
        pane.onCorpGrChange(val);
        return;
    }

    if (typeof window.onSearch === 'function' && window.onSearch !== onToolbarSearch) {
        window.onSearch(btn);
    }
}

/**
 * Toolbar Action: [저장] (Save Active Tab)
 * @param {HTMLElement} btn
 */
function onToolbarSave(btn) {
    const pane = getActiveTabPane(btn);
    if (!pane) return;

    if (typeof pane.onSave === 'function') {
        pane.onSave(btn);
        return;
    }

    pane.dispatchEvent(new CustomEvent('toolbarSave', { bubbles: true, detail: { pane: pane } }));

    if (typeof window.onSave === 'function' && window.onSave !== onToolbarSave) {
        window.onSave(btn);
    }
}

/**
 * Toolbar Action: [엑셀] (Export Active Master Grid to Excel)
 * @param {HTMLElement} btn
 */
function onToolbarExcel(btn) {
    const pane = getActiveTabPane(btn);
    if (!pane) return;

    if (typeof pane.onExcel === 'function') {
        pane.onExcel(btn);
        return;
    }

    const gridEl = pane.querySelector('#master-grid')
                || pane.querySelector('.master-grid-section .tabulator-aams-grid')
                || pane.querySelector('.master-grid-wrapper .tabulator-aams-grid')
                || pane.querySelector('.tabulator-aams-grid');

    if (gridEl && typeof Tabulator !== 'undefined' && typeof Tabulator.findTable === 'function') {
        let table = Tabulator.findTable(gridEl);
        if (Array.isArray(table)) {
            table = table[0];
        }
        if (table && typeof table.download === 'function') {
            const titleEl = pane.querySelector('.breadcrumb span') || document.querySelector('.tab-item.active .tab-title');
            const fileName = (titleEl ? titleEl.textContent.trim().replace(/[\\/:*?"<>|]/g, '_') : 'export') + '.xlsx';
            try {
                table.download("xlsx", fileName);
            } catch (e) {
                table.download("csv", (titleEl ? titleEl.textContent.trim() : 'export') + '.csv');
            }
            return;
        }
    }

    if (typeof window.onExcel === 'function' && window.onExcel !== onToolbarExcel) {
        window.onExcel(btn);
    }
}

/**
 * Toolbar Action: [복사] (Copy Selected Row in Master Grid to New Row)
 * 개발지침: 복사는 선택한 마스터 그리드의 row를 복사해서 마스터 그리드에 새로운 행을 만든다.
 * 신규로 추가된 행(isNew: true)에 대해서 인라인 수정을 허용한다.
 * @param {HTMLElement} btn
 */
function onToolbarCopy(btn) {
    const pane = getActiveTabPane(btn);
    if (!pane) return;

    // 1. 화면 전용 onCopy / onRowCopy 계약 함수 우선 실행
    if (typeof pane.onCopy === 'function') {
        pane.onCopy(btn);
        return;
    }
    if (typeof pane.onRowCopy === 'function') {
        pane.onRowCopy(btn);
        return;
    }

    // 2. 마스터 그리드 자동 탐색
    const gridEl = pane.querySelector('#master-grid')
                || pane.querySelector('.master-grid-section .tabulator-aams-grid')
                || pane.querySelector('.master-grid-wrapper .tabulator-aams-grid')
                || pane.querySelector('.tabulator-aams-grid');

    if (!gridEl || typeof Tabulator === 'undefined' || typeof Tabulator.findTable !== 'function') {
        console.warn('[onToolbarCopy] 복사 대상 그리드를 찾을 수 없습니다.');
        return;
    }

    let table = Tabulator.findTable(gridEl);
    if (Array.isArray(table)) table = table[0];
    if (!table) return;

    // 3. 선택된 행 확인
    const selectedRows = typeof table.getSelectedRows === 'function' ? table.getSelectedRows() : [];
    if (!selectedRows || selectedRows.length === 0) {
        if (typeof showToast === 'function') {
            showToast("복사할 행을 먼저 선택해주세요.", "warning");
        } else {
            alert("복사할 행을 먼저 선택해주세요.");
        }
        return;
    }

    const selectedRow = selectedRows[0];
    const originalData = selectedRow.getData ? selectedRow.getData() : {};

    // 4. 데이터 딥 카피 & 신규 행 플래그 설정 (예외규칙: isNew: true)
    let copiedData = JSON.parse(JSON.stringify(originalData));
    copiedData.isNew = true;

    // 화면 전용 복사 행 보정 함수가 있다면 적용
    if (typeof pane.getCopiedRowData === 'function') {
        copiedData = Object.assign(copiedData, pane.getCopiedRowData(copiedData, originalData) || {});
    }

    // 5. 그리드 최상단에 신규 행 추가
    table.addRow(copiedData, true).then(function(newRow) {
        table.deselectRow();
        newRow.select();
        try { newRow.scrollTo(); } catch (e) {}

        if (typeof pane.onRowSelect === 'function') {
            pane.onRowSelect(newRow.getData(), newRow);
        }

        pane.dispatchEvent(new CustomEvent('masterRowCopied', {
            bubbles: true,
            detail: { row: newRow, data: newRow.getData(), originalData: originalData }
        }));

        if (typeof showToast === 'function') {
            showToast("선택한 행이 복사되어 최상단에 추가되었습니다.", "success");
        }
    }).catch(function(err) {
        console.error('[onToolbarCopy] 행 복사 처리 실패:', err);
    });

    if (typeof window.onCopy === 'function' && window.onCopy !== onToolbarCopy) {
        window.onCopy(btn);
    }
}

/**
 * Toolbar Action: [삭제] (Delete Selected Row in Master Grid)
 * @param {HTMLElement} btn
 */
function onToolbarDelete(btn) {
    const pane = getActiveTabPane(btn);
    if (!pane) return;

    if (typeof pane.onDelete === 'function') {
        pane.onDelete(btn);
        return;
    }

    const gridEl = pane.querySelector('#master-grid')
                || pane.querySelector('.master-grid-section .tabulator-aams-grid')
                || pane.querySelector('.master-grid-wrapper .tabulator-aams-grid')
                || pane.querySelector('.tabulator-aams-grid');

    if (gridEl && typeof Tabulator !== 'undefined' && typeof Tabulator.findTable === 'function') {
        let table = Tabulator.findTable(gridEl);
        if (Array.isArray(table)) table = table[0];
        if (table) {
            const selectedRows = typeof table.getSelectedRows === 'function' ? table.getSelectedRows() : [];
            if (!selectedRows || selectedRows.length === 0) {
                if (typeof showToast === 'function') {
                    showToast("삭제할 행을 먼저 선택해주세요.", "warning");
                } else {
                    alert("삭제할 행을 먼저 선택해주세요.");
                }
                return;
            }

            if (!confirm("선택한 행을 삭제하시겠습니까?")) {
                return;
            }

            const targetRow = selectedRows[0];
            const rowData = targetRow.getData ? targetRow.getData() : {};
            targetRow.delete().then(function() {
                if (typeof showToast === 'function') {
                    showToast("행이 삭제되었습니다.", "info");
                }
                pane.dispatchEvent(new CustomEvent('masterRowDeleted', {
                    bubbles: true,
                    detail: { data: rowData }
                }));
            }).catch(function(err) {
                console.error('[onToolbarDelete] 행 삭제 실패:', err);
            });
            return;
        }
    }

    if (typeof window.onDelete === 'function' && window.onDelete !== onToolbarDelete) {
        window.onDelete(btn);
    }
}

/**
 * Helper: 화면의 제목(타이틀) 추출
 * @param {HTMLElement} pane
 * @returns {string}
 */
function getPaneTitle(pane) {
    if (!pane) return 'AAMS 인쇄';
    const titleEl = pane.querySelector('.breadcrumb strong.active')
                 || pane.querySelector('.breadcrumb span')
                 || document.querySelector('.tab-item.active .tab-title');
    return titleEl ? titleEl.textContent.trim() : 'AAMS 리포트';
}

/**
 * Toolbar Action: [인쇄] (Print Specified Grid, MRD Report, or Tab Content)
 * 개발지침: 화면에서 변수로 특정그리드(printGrid) 또는 mrd 파일(mrdName) 등을 전달받아서 해당 부분을 인쇄한다.
 * @param {HTMLElement} btn
 */
function onToolbarPrint(btn) {
    const pane = getActiveTabPane(btn);
    if (!pane) return;

    // 1. 화면 전용 커스텀 onPrint 훅 우선 실행
    if (typeof pane.onPrint === 'function') {
        pane.onPrint(btn);
        return;
    }

    const title = getPaneTitle(pane);

    // 2. [MRD 리포트 인쇄] 화면에 변수로 mrdName이 지정되었거나, 화면 내에 이미 로드된 리포트 iframe이 있는 경우
    const mrdName = pane.mrdName
                 || pane.mrdFile
                 || pane.reportName
                 || (pane.dataset ? (pane.dataset.mrdName || pane.dataset.mrdFile || pane.dataset.reportName) : null);

    // 2-1. 화면 내에 이미 활성화된 리포트 미리보기 iframe이 있는 경우
    const reportFrame = pane.querySelector('#report-frame, iframe.report-iframe, iframe[id*="report"]');
    if (reportFrame && reportFrame.contentWindow && reportFrame.src && !reportFrame.src.includes('about:blank')) {
        try {
            reportFrame.contentWindow.focus();
            reportFrame.contentWindow.print();
            return;
        } catch (err) {
            console.warn('[onToolbarPrint] 리포트 iframe 직접 인쇄 실패, 백엔드 URL로 재시도:', err);
        }
    }

    // 2-2. 화면에 mrdName 변수가 전달된 경우 백엔드 리포트 생성 후 무간섭 인쇄
    if (mrdName) {
        let params = {};
        if (typeof pane.getMrdParams === 'function') {
            params = pane.getMrdParams(pane) || {};
        } else if (pane.mrdParams) {
            params = typeof pane.mrdParams === 'function' ? pane.mrdParams() : pane.mrdParams;
        } else if (typeof pane.getReportParams === 'function') {
            params = pane.getReportParams(pane) || {};
        }

        const corpGrSelect = pane.querySelector('select[name="corpGr"]') || pane.querySelector('#filterCorpGr');
        const corpGr = (corpGrSelect && corpGrSelect.value) ? corpGrSelect.value : (window.currentCorpGr || '');

        printMrdReport(mrdName, params, { corpGr: corpGr, downloadName: title });
        return;
    }

    // 3. [특정 그리드 인쇄] 화면에 변수로 특정 그리드가 지정된 경우 (pane.printGrid 또는 pane.dataset.printGrid)
    const gridTarget = pane.printGrid
                    || pane.targetGrid
                    || (pane.dataset ? pane.dataset.printGrid : null);

    if (gridTarget) {
        let targetEl = null;
        let targetTable = null;

        if (typeof gridTarget === 'string') {
            targetEl = pane.querySelector(gridTarget) || document.querySelector(gridTarget);
            if (targetEl && typeof Tabulator !== 'undefined' && typeof Tabulator.findTable === 'function') {
                targetTable = Tabulator.findTable(targetEl);
                if (Array.isArray(targetTable)) targetTable = targetTable[0];
            }
        } else if (gridTarget && gridTarget.addRow) {
            // Tabulator 인스턴스가 직접 전달된 경우
            targetTable = gridTarget;
        } else if (gridTarget instanceof HTMLElement) {
            targetEl = gridTarget;
            if (typeof Tabulator !== 'undefined' && typeof Tabulator.findTable === 'function') {
                targetTable = Tabulator.findTable(targetEl);
                if (Array.isArray(targetTable)) targetTable = targetTable[0];
            }
        }

        if (targetTable) {
            printTabulatorGrid(targetTable, title);
            return;
        } else if (targetEl) {
            printElementHtml(targetEl, title);
            return;
        }
    }

    // 4. [기본 마스터 그리드 인쇄] 별도 변수 지정이 없으면 pane 내의 기본 마스터 그리드 자동 탐색 및 인쇄
    const defaultGridEl = pane.querySelector('#master-grid')
                       || pane.querySelector('.master-grid-section .tabulator-aams-grid')
                       || pane.querySelector('.master-grid-wrapper .tabulator-aams-grid')
                       || pane.querySelector('.tabulator-aams-grid');

    if (defaultGridEl && typeof Tabulator !== 'undefined' && typeof Tabulator.findTable === 'function') {
        let masterTable = Tabulator.findTable(defaultGridEl);
        if (Array.isArray(masterTable)) masterTable = masterTable[0];
        if (masterTable) {
            printTabulatorGrid(masterTable, title);
            return;
        }
    }

    // 5. [전체 영역 인쇄 폴백] 그리드도 없는 경우 활성 탭 전체 인쇄
    printElementHtml(pane, title);

    if (typeof window.onPrint === 'function' && window.onPrint !== onToolbarPrint) {
        window.onPrint(btn);
    }
}

/**
 * MRD 리포트 인쇄 헬퍼: PDF 미리보기 스트림을 숨김 iframe에 로드 후 인쇄 대화상자 호출
 * @param {string} mrdName - MRD 파일명 (예: "rd_ja010b.mrd")
 * @param {Object} params - 파라미터 맵
 * @param {Object} options - 옵션 { corpGr, downloadName }
 */
function printMrdReport(mrdName, params, options) {
    if (!mrdName) return;
    options = options || {};
    const corpGr = options.corpGr || (typeof getFilterCorpGr === 'function' ? getFilterCorpGr() : (window.currentCorpGr || ''));
    
    const previewUrl = window.AamsReport && typeof window.AamsReport.buildPreviewUrl === 'function'
        ? window.AamsReport.buildPreviewUrl(mrdName, params, { corpGr: corpGr, downloadName: options.downloadName })
        : ('/api/common/rd/preview?mrdName=' + encodeURIComponent(mrdName) + '&corpGr=' + encodeURIComponent(corpGr));

    if (typeof showToast === 'function') {
        showToast("리포트 인쇄를 준비하고 있습니다...", "info");
    }

    let printFrame = document.getElementById('aams-hidden-print-frame');
    if (!printFrame) {
        printFrame = document.createElement('iframe');
        printFrame.id = 'aams-hidden-print-frame';
        printFrame.style.position = 'fixed';
        printFrame.style.right = '0';
        printFrame.style.bottom = '0';
        printFrame.style.width = '0';
        printFrame.style.height = '0';
        printFrame.style.border = '0';
        document.body.appendChild(printFrame);
    }

    printFrame.onload = function() {
        setTimeout(function() {
            try {
                printFrame.contentWindow.focus();
                printFrame.contentWindow.print();
            } catch (e) {
                console.warn('[printMrdReport] iframe 인쇄 실패, 새 창으로 인쇄 시도:', e);
                window.open(previewUrl, '_blank');
            }
        }, 500);
    };

    printFrame.src = previewUrl;
}

/**
 * Tabulator 그리드 인쇄 헬퍼
 * @param {Object} table - Tabulator 인스턴스
 * @param {string} title - 인쇄 문서 제목
 */
function printTabulatorGrid(table, title) {
    if (!table) return;

    // 1. Tabulator 내장 print 모듈 시도
    try {
        if (typeof table.print === 'function') {
            table.print(false, true);
            return;
        }
    } catch (err) {
        console.warn('[printTabulatorGrid] table.print() 실패, HTML 직접 추출 인쇄 폴백:', err);
    }

    // 2. HTML 추출 기반 인쇄 팝업 폴백
    const tableEl = table.element || table;
    printElementHtml(tableEl, title);
}

/**
 * DOM 엘리먼트 HTML 추출 인쇄 헬퍼 (깔끔한 전용 인쇄 창 생성)
 * @param {HTMLElement} element
 * @param {string} title
 */
function printElementHtml(element, title) {
    if (!element) {
        window.print();
        return;
    }

    const printWin = window.open('', '_blank', 'width=1100,height=800,menubar=no,status=no,toolbar=no');
    if (!printWin) {
        // 팝업 차단된 경우 기본 브라우저 인쇄
        window.print();
        return;
    }

    const styles = Array.from(document.querySelectorAll('link[rel="stylesheet"], style'))
        .map(s => s.outerHTML).join('\n');

    printWin.document.open();
    printWin.document.write(`
        <!DOCTYPE html>
        <html lang="ko">
        <head>
            <meta charset="UTF-8">
            <title>${title || 'AAMS 문서 인쇄'}</title>
            ${styles}
            <style>
                @media print {
                    @page { size: auto; margin: 10mm; }
                    body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
                }
                body {
                    background: #ffffff !important;
                    color: #000000 !important;
                    font-family: -apple-system, BlinkMacSystemFont, "Malgun Gothic", "맑은 고딕", sans-serif;
                    padding: 20px;
                }
                .print-header {
                    margin-bottom: 16px;
                    padding-bottom: 8px;
                    border-bottom: 2px solid #0f172a;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }
                .print-header h2 {
                    margin: 0;
                    font-size: 18px;
                    color: #0f172a;
                }
                .print-header .print-date {
                    font-size: 11px;
                    color: #64748b;
                }
            </style>
        </head>
        <body>
            <div class="print-header">
                <h2>${title || 'AAMS 데이터 출력'}</h2>
                <div class="print-date">인쇄일시: ${new Date().toLocaleString()}</div>
            </div>
            <div class="print-body">
                ${element.innerHTML}
            </div>
            <script>
                window.onload = function() {
                    window.focus();
                    window.print();
                    setTimeout(function() { window.close(); }, 1000);
                };
            </script>
        </body>
        </html>
    `);
    printWin.document.close();
}

