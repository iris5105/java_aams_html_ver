/**
 * Common Filter Bar Manager & Event Delegation (filter.js)
 * Handles all 24 PowerBuilder dc_* condition filter controls and event bindings
 */
class FilterManager {
    constructor() {
        this.initEventListeners();
    }

    initEventListeners() {
        // Global Unobtrusive 'change' Event Delegation for Filter Bar Controls
        document.addEventListener('change', (e) => {
            if (!e.target) return;
            const target = e.target;
            const filterBar = target.closest('.filter-bar');
            if (!filterBar) return;

            const name = target.name || target.id;
            const val = target.value;

            // 1. Check custom data-onchange attribute
            const customHandler = target.getAttribute('data-onchange');
            if (customHandler && typeof window[customHandler] === 'function') {
                window[customHandler](val, e, target);
                return;
            }

            // 2. Corp Group Select Change (운용사 선택 변경)
            if (name === 'corpGr' || target.id === 'filterCorpGr' || target.id === 'corpGrSelect') {
                if (typeof window.onCorpGrChange === 'function') {
                    window.onCorpGrChange(val, e);
                } else if (typeof window.onJa010bCorpGrChange === 'function') {
                    window.onJa010bCorpGrChange(val, e);
                }
            }

            // 3. Date / Month / Year Filter Change
            if (name === 'ymd' || name === 'fYmd' || name === 'tYmd' || name === 'ym' || name === 'fMm' || name === 'tMm' || name === 'yyyy') {
                if (typeof window.onFilterDateChange === 'function') {
                    window.onFilterDateChange(name, val, e);
                }
            }

            // 4. DDDW / Select Filter Change
            if (name.startsWith('dddw') || name === 'fundKind' || name === 'planKind' || name === 'taskKind') {
                if (typeof window.onFilterSelectChange === 'function') {
                    window.onFilterSelectChange(name, val, e);
                }
            }

            // 5. Generic page-level filter change callback
            if (typeof window.onFilterChange === 'function') {
                window.onFilterChange(name, val, e);
            }
        });

        // Global Unobtrusive 'keyup/Enter' Event Delegation for Text Filter Inputs
        document.addEventListener('keyup', (e) => {
            if (!e.target || e.key !== 'Enter') return;
            const target = e.target;
            const filterBar = target.closest('.filter-bar');
            if (!filterBar) return;

            const name = target.name || target.id;
            const val = target.value;

            if (typeof window.onFilterEnter === 'function') {
                window.onFilterEnter(name, val, e);
            } else if (typeof window.onSearch === 'function') {
                window.onSearch();
            } else if (typeof window.loadJa010bMaster === 'function') {
                window.loadJa010bMaster();
            }
        });
    }

    /**
     * Get all filter values from a given filter bar container element or active view
     */
    getValues(container) {
        const root = container || document.querySelector('.tab-pane.active .filter-bar') || document.querySelector('.filter-bar');
        if (!root) return {};

        const data = {};
        root.querySelectorAll('input, select, textarea').forEach(el => {
            const key = el.name || el.id;
            if (key) {
                data[key] = el.value;
            }
        });
        return data;
    }

    /**
     * Set filter values in a container
     */
    setValues(container, data) {
        const root = container || document.querySelector('.tab-pane.active .filter-bar') || document.querySelector('.filter-bar');
        if (!root || !data) return;

        Object.keys(data).forEach(key => {
            const el = root.querySelector(`[name="${key}"], #${key}`);
            if (el) {
                el.value = data[key];
            }
        });
    }
}

// Global Singleton Instance
window.filterManager = new FilterManager();
