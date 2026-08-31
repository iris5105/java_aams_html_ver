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
 * Toolbar Action: [새로고침] (Refresh Active Tab)
 * @param {HTMLElement} btn
 */
function onToolbarRefresh(btn) {
    const pane = getActiveTabPane(btn);
    if (!pane) return;

    if (typeof pane.onRefresh === 'function') {
        pane.onRefresh(btn);
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

    if (typeof window.onRefresh === 'function' && window.onRefresh !== onToolbarRefresh) {
        window.onRefresh(btn);
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
