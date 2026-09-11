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
