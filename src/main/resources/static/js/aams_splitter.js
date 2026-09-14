/**
 * ==========================================================================
 * AAMS Interactive Splitter Module
 * File: aams_splitter.js
 * Description: Draggable resizer gutters for .layout-split-h and .layout-split-v
 *              Maintains default 60:40 ratio with user localStorage persistence
 * ==========================================================================
 */

(function (global) {
    'use strict';

    const AamsSplitter = {
        DEFAULT_RATIO_H: 60, // 60% Left : 40% Right
        DEFAULT_RATIO_V: 60, // 60% Top : 40% Bottom
        MIN_PANEL_PERCENT: 15,
        MAX_PANEL_PERCENT: 85,
        MIN_PANEL_PX: 200,

        /**
         * Initialize all split layouts inside a given container (or document)
         * @param {HTMLElement|Document} rootEl Root DOM element to search within
         */
        init: function (rootEl) {
            const root = rootEl || document;

            // 1. Initialize Horizontal Splits (.layout-split-h)
            const hSplits = root.querySelectorAll ? root.querySelectorAll('.layout-split-h') : [];
            hSplits.forEach(container => this.setupHorizontal(container));

            // 2. Initialize Vertical Splits (.layout-split-v)
            const vSplits = root.querySelectorAll ? root.querySelectorAll('.layout-split-v') : [];
            vSplits.forEach(container => this.setupVertical(container));
        },

        /**
         * Resolve unique storage key for a split container (by screen/tab ID)
         */
        getStorageKey: function (container) {
            if (container.dataset.splitKey) return 'aams_split_' + container.dataset.splitKey;

            const tabPane = container.closest('.tab-pane');
            if (tabPane && tabPane.id) {
                return 'aams_split_' + tabPane.id.replace('tab-pane-', '');
            }

            const viewContainer = container.closest('.view-container') || container;
            if (viewContainer.id) {
                return 'aams_split_' + viewContainer.id;
            }

            const match = viewContainer.className.match(/([a-zA-Z0-9_-]+-container)/);
            if (match) {
                return 'aams_split_' + match[1];
            }

            return 'aams_split_default';
        },

        /**
         * Parse custom default ratio from container (e.g. data-default-ratio="40:60")
         */
        getDefaultRatio: function (container, isVertical) {
            const defaultAttr = container.dataset.defaultRatio;
            if (defaultAttr && defaultAttr.includes(':')) {
                const parts = defaultAttr.split(':');
                const parsed = parseFloat(parts[0]);
                if (!isNaN(parsed) && parsed > 5 && parsed < 95) {
                    return parsed;
                }
            }
            return isVertical ? this.DEFAULT_RATIO_V : this.DEFAULT_RATIO_H;
        },

        /**
         * Trigger Tabulator Grid Redraw inside elements
         */
        redrawGrids: function (container) {
            if (!container) return;
            const tabulatorEls = container.querySelectorAll('.tabulator');
            tabulatorEls.forEach(el => {
                if (el.tabulator && typeof el.tabulator.redraw === 'function') {
                    el.tabulator.redraw(true);
                }
            });
        },

        /**
         * Setup Horizontal Splitter (.layout-split-h)
         */
        setupHorizontal: function (container) {
            if (container._aamsSplitterInit) return;
            container._aamsSplitterInit = true;

            const leftPane = container.querySelector(':scope > .pane-left, :scope > .master-section');
            const rightPane = container.querySelector(':scope > .pane-right, :scope > .detail-section');
            if (!leftPane || !rightPane) return;

            // Ensure Gutter exists between left and right panes
            let gutter = container.querySelector(':scope > .split-gutter-h');
            if (!gutter) {
                gutter = document.createElement('div');
                gutter.className = 'split-gutter-h';
                gutter.title = '드래그하여 좌우 비율 조절 (더블클릭 시 기본 비율로 복원)';
                container.insertBefore(gutter, rightPane);
            }

            const storageKey = this.getStorageKey(container);
            const defaultRatio = this.getDefaultRatio(container, false);

            // Apply saved ratio from localStorage or fallback to default
            let currentRatio = defaultRatio;
            const saved = localStorage.getItem(storageKey);
            if (saved !== null) {
                const parsed = parseFloat(saved);
                if (!isNaN(parsed) && parsed >= this.MIN_PANEL_PERCENT && parsed <= this.MAX_PANEL_PERCENT) {
                    currentRatio = parsed;
                }
            }

            const applyRatio = (ratioPercent) => {
                leftPane.style.flex = `0 0 calc(${ratioPercent}% - 3px)`;
                leftPane.style.maxWidth = `calc(100% - 240px)`;
                rightPane.style.flex = '1 1 auto';
                container.style.setProperty('--left-size', `calc(${ratioPercent}% - 3px)`);
                this.redrawGrids(container);
            };

            applyRatio(currentRatio);

            // Double Click on Gutter: Reset to default ratio
            gutter.addEventListener('dblclick', () => {
                currentRatio = defaultRatio;
                localStorage.removeItem(storageKey);
                applyRatio(currentRatio);
            });

            // Drag Resizing Logic
            let isDragging = false;
            let startX = 0;
            let startLeftWidth = 0;
            let containerWidth = 0;

            const onMouseDown = (e) => {
                if (window.innerWidth <= 876) return; // Disable in mobile mode
                isDragging = true;
                gutter.classList.add('is-dragging');
                document.body.style.cursor = 'col-resize';
                document.body.style.userSelect = 'none';

                startX = e.clientX;
                startLeftWidth = leftPane.getBoundingClientRect().width;
                containerWidth = container.getBoundingClientRect().width;

                document.addEventListener('mousemove', onMouseMove);
                document.addEventListener('mouseup', onMouseUp);
                e.preventDefault();
            };

            const onMouseMove = (e) => {
                if (!isDragging) return;
                const deltaX = e.clientX - startX;
                let newLeftWidth = startLeftWidth + deltaX;

                // Boundary limits
                const minPx = Math.max(AamsSplitter.MIN_PANEL_PX, (containerWidth * AamsSplitter.MIN_PANEL_PERCENT) / 100);
                const maxPx = containerWidth - Math.max(AamsSplitter.MIN_PANEL_PX, (containerWidth * (100 - AamsSplitter.MAX_PANEL_PERCENT)) / 100);

                if (newLeftWidth < minPx) newLeftWidth = minPx;
                if (newLeftWidth > maxPx) newLeftWidth = maxPx;

                const newPercent = Math.round((newLeftWidth / containerWidth) * 1000) / 10;
                currentRatio = newPercent;
                applyRatio(newPercent);
            };

            const onMouseUp = () => {
                if (!isDragging) return;
                isDragging = false;
                gutter.classList.remove('is-dragging');
                document.body.style.cursor = '';
                document.body.style.userSelect = '';

                document.removeEventListener('mousemove', onMouseMove);
                document.removeEventListener('mouseup', onMouseUp);

                // Save to localStorage
                localStorage.setItem(storageKey, String(currentRatio));
                setTimeout(() => AamsSplitter.redrawGrids(container), 30);
            };

            gutter.addEventListener('mousedown', onMouseDown);
        },

        /**
         * Setup Vertical Splitter (.layout-split-v)
         */
        setupVertical: function (container) {
            if (container._aamsSplitterInit) return;
            container._aamsSplitterInit = true;

            const topPane = container.querySelector(':scope > .pane-top, :scope > .split-top-section');
            const bottomPane = container.querySelector(':scope > .pane-bottom, :scope > .split-bottom-section');
            if (!topPane || !bottomPane) return;

            // Ensure Gutter exists between top and bottom panes
            let gutter = container.querySelector(':scope > .split-gutter-v');
            if (!gutter) {
                gutter = document.createElement('div');
                gutter.className = 'split-gutter-v';
                gutter.title = '드래그하여 상하 비율 조절 (더블클릭 시 기본 비율로 복원)';
                container.insertBefore(gutter, bottomPane);
            }

            const storageKey = this.getStorageKey(container);
            const defaultRatio = this.getDefaultRatio(container, true);

            // Apply saved ratio from localStorage or fallback to default
            let currentRatio = defaultRatio;
            const saved = localStorage.getItem(storageKey);
            if (saved !== null) {
                const parsed = parseFloat(saved);
                if (!isNaN(parsed) && parsed >= this.MIN_PANEL_PERCENT && parsed <= this.MAX_PANEL_PERCENT) {
                    currentRatio = parsed;
                }
            }

            const applyRatio = (ratioPercent) => {
                topPane.style.flex = `0 0 calc(${ratioPercent}% - 3px)`;
                topPane.style.maxHeight = `calc(100% - 140px)`;
                bottomPane.style.flex = '1 1 auto';
                container.style.setProperty('--top-size', `calc(${ratioPercent}% - 3px)`);
                this.redrawGrids(container);
            };

            applyRatio(currentRatio);

            // Double Click on Gutter: Reset to default ratio
            gutter.addEventListener('dblclick', () => {
                currentRatio = defaultRatio;
                localStorage.removeItem(storageKey);
                applyRatio(currentRatio);
            });

            // Drag Resizing Logic
            let isDragging = false;
            let startY = 0;
            let startTopHeight = 0;
            let containerHeight = 0;

            const onMouseDown = (e) => {
                if (window.innerWidth <= 876) return; // Disable in mobile mode
                isDragging = true;
                gutter.classList.add('is-dragging');
                document.body.style.cursor = 'row-resize';
                document.body.style.userSelect = 'none';

                startY = e.clientY;
                startTopHeight = topPane.getBoundingClientRect().height;
                containerHeight = container.getBoundingClientRect().height;

                document.addEventListener('mousemove', onMouseMove);
                document.addEventListener('mouseup', onMouseUp);
                e.preventDefault();
            };

            const onMouseMove = (e) => {
                if (!isDragging) return;
                const deltaY = e.clientY - startY;
                let newTopHeight = startTopHeight + deltaY;

                // Boundary limits
                const minPx = Math.max(140, (containerHeight * AamsSplitter.MIN_PANEL_PERCENT) / 100);
                const maxPx = containerHeight - Math.max(120, (containerHeight * (100 - AamsSplitter.MAX_PANEL_PERCENT)) / 100);

                if (newTopHeight < minPx) newTopHeight = minPx;
                if (newTopHeight > maxPx) newTopHeight = maxPx;

                const newPercent = Math.round((newTopHeight / containerHeight) * 1000) / 10;
                currentRatio = newPercent;
                applyRatio(newPercent);
            };

            const onMouseUp = () => {
                if (!isDragging) return;
                isDragging = false;
                gutter.classList.remove('is-dragging');
                document.body.style.cursor = '';
                document.body.style.userSelect = '';

                document.removeEventListener('mousemove', onMouseMove);
                document.removeEventListener('mouseup', onMouseUp);

                // Save to localStorage
                localStorage.setItem(storageKey, String(currentRatio));
                setTimeout(() => AamsSplitter.redrawGrids(container), 30);
            };

            gutter.addEventListener('mousedown', onMouseDown);
        }
    };

    // Export to global scope
    global.AamsSplitter = AamsSplitter;

    // Auto-init on DOMContentLoaded for standalone/initial load
    document.addEventListener('DOMContentLoaded', () => {
        AamsSplitter.init(document);
    });

})(window);
