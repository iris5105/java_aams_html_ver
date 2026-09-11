/**
 * AAMS Pure JavaScript Highlight Calendar Component
 * Dynamically constructs input wrapper, calendar icon button, and PowerBuilder-style calendar popover DOM entirely via JS.
 */
window.AamsCalendar = (function() {
    const instances = (window.AamsCalendar && window.AamsCalendar.instances) ? window.AamsCalendar.instances : {};

    return {
        instances: instances,

        /**
         * Attach/Initialize calendar instance on an input element ID (Highlight Mode / General Mode)
         */
        init: function(inputId, options) {
            // [방어 코드 1] inputId가 DOM Element인 경우 ID 및 pane 자동 추출
            if (inputId && typeof inputId === 'object' && inputId.nodeType === 1) {
                options = options || {};
                if (!options.pane) {
                    options.pane = (typeof inputId.closest === 'function') ? inputId.closest('.tab-pane') : null;
                }
                inputId = inputId.id || inputId.getAttribute('name') || 'filterYmd';
            }

            // [방어 코드 2] options가 문자열(초기 날짜)로 전달된 경우 정규화
            if (typeof options === 'string') {
                options = { initialYmd: options };
            }
            options = options || {};
            const initialYmd = options.initialYmd || "";
            let initialYear = new Date().getFullYear();
            let initialMonth = new Date().getMonth(); // 0-indexed (0=1월, 11=12월)

            if (initialYmd && initialYmd.length >= 7) {
                const parts = initialYmd.split("-");
                if (parts.length === 3) {
                    initialYear = parseInt(parts[0], 10);
                    initialMonth = parseInt(parts[1], 10) - 1;
                }
            }

            const isSimple = !!(options.isSimple || options.simple || options.highlight === false);

            instances[inputId] = {
                inputId: inputId,
                pane: options.pane || null,
                popoverId: inputId + "_popover",
                titleId: inputId + "_title",
                monthsGridId: inputId + "_monthsGrid",
                daysGridId: inputId + "_daysGrid",
                calYear: initialYear,
                calMonth: initialMonth,
                isSimple: isSimple,
                trDatesSet: isSimple ? new Set() : new Set(options.highlightDates || []),
                datesApiUrl: isSimple ? null : (options.datesApiUrl || null),
                historyTitle: options.historyTitle || "데이터 존재",
                onSelect: options.onSelect || null,
                clickBound: false
            };

            this.buildDOM(inputId, initialYmd);
            this.render(inputId);
            this.bindOutsideClick(inputId);

            if (!isSimple && options.datesApiUrl && (!options.highlightDates || options.highlightDates.length === 0)) {
                this.loadHighlightDates(inputId, options.datesApiUrl, options.corpGr);
            }
        },

        /**
         * 순정 상태의 달력 초기화 (데이터 존재 여부 파악/하이라이트 없이 날짜 선택만 지원)
         * @param {string|HTMLElement} inputId - 날짜 input 요소 ID 또는 DOM Element
         * @param {object|string} options - { initialYmd, pane, onSelect } 또는 initialYmd 문자열
         */
        initSimple: function(inputId, options) {
            if (typeof options === 'string') {
                options = { initialYmd: options };
            }
            options = options || {};
            options.isSimple = true;
            options.highlight = false;
            options.datesApiUrl = null;
            options.highlightDates = [];
            this.init(inputId, options);
        },

        /**
         * 캘린더 인스턴스 제거 및 DOM 정리
         */
        destroy: function(inputId) {
            if (inputId && typeof inputId === 'object' && inputId.nodeType === 1) {
                inputId = inputId.id || inputId.getAttribute('name') || 'filterYmd';
            }
            const inst = instances[inputId];
            if (!inst) return;
            const popover = this.getElement(inst.popoverId, inst.pane);
            if (popover) popover.remove();
            delete instances[inputId];
        },

        getElement: function(inputId, pane) {
            if (!inputId) return null;
            if (typeof inputId === 'object' && inputId.nodeType === 1) return inputId;
            if (typeof inputId !== 'string') return null;

            try {
                if (pane && typeof pane.querySelector === 'function') {
                    const el = pane.querySelector('#' + inputId);
                    if (el) return el;
                }
            } catch (e) {
                // Ignore querySelector syntax errors
            }
            return document.getElementById(inputId);
        },

        buildDOM: function(inputId, initialYmd) {
            const inst = instances[inputId];
            if (!inst) return;

            const inputEl = this.getElement(inputId, inst.pane);
            if (!inputEl) return;

            // 1. Create or ensure input wrapper
            let wrapper = inputEl.closest('.aams-calendar-wrapper');
            if (!wrapper) {
                wrapper = document.createElement('div');
                wrapper.className = 'aams-calendar-wrapper';
                wrapper.style.cssText = 'position: relative; display: inline-flex; align-items: center;';

                inputEl.parentNode.insertBefore(wrapper, inputEl);
                wrapper.appendChild(inputEl);

                // Style input element
                try { inputEl.type = 'text'; } catch(e) {}
                inputEl.className = 't-input aams-calendar-input';
                inputEl.style.cssText = 'width: 110px; padding: 4px 8px; font-size: 13px; text-align: center; border: 1px solid #cbd5e1; border-radius: 4px 0 0 4px; cursor: pointer; background: #ffffff;';
                inputEl.readOnly = true;
                if (initialYmd) inputEl.value = initialYmd;
                inputEl.onclick = function(e) {
                    if (e) e.stopPropagation();
                    AamsCalendar.toggle(inputId, e);
                };

                // Create calendar icon button
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 't-btn btn-calendar';
                btn.style.cssText = 'padding: 5px 10px; border-radius: 0 4px 4px 0; border-left: none; background-color: #3b82f6; color: #ffffff; border: 1px solid #3b82f6; cursor: pointer;';
                btn.innerHTML = '<i class="fa-regular fa-calendar-days"></i>';
                btn.onclick = function(e) {
                    if (e) e.stopPropagation();
                    AamsCalendar.toggle(inputId, e);
                };
                wrapper.appendChild(btn);
            } else {
                if (initialYmd && !inputEl.value) inputEl.value = initialYmd;
                inputEl.onclick = function(e) {
                    if (e) e.stopPropagation();
                    AamsCalendar.toggle(inputId, e);
                };
                const btn = wrapper.querySelector('.btn-calendar');
                if (btn) {
                    btn.onclick = function(e) {
                        if (e) e.stopPropagation();
                        AamsCalendar.toggle(inputId, e);
                    };
                }
            }

            // 2. Create or recreate Popover DOM
            let popover = document.getElementById(inst.popoverId);
            if (popover) {
                popover.remove();
            }

            popover = document.createElement('div');
            popover.id = inst.popoverId;
            popover.className = 'calendar-popover';
            popover.style.cssText = 'display: none; position: absolute; top: 100%; left: 0; margin-top: 6px; z-index: 9999; background: #ffffff; border: 1px solid #708090; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2); width: 235px; padding: 4px; font-family: "맑은 고딕", sans-serif;';

            popover.innerHTML = `
                <div style="display: flex; align-items: center; justify-content: space-between; padding: 4px 2px; border-bottom: 1px solid #e2e8f0; font-size: 13px;">
                    <div style="display: flex; align-items: center; gap: 3px;">
                        <button type="button" onclick="AamsCalendar.prevYear('${inputId}')" title="이전 년도" style="background: none; border: none; cursor: pointer; color: #2563eb; font-weight: bold; font-size: 13px; padding: 0 2px;">«</button>
                        <button type="button" onclick="AamsCalendar.prevMonth('${inputId}')" title="이전 월" style="background: none; border: none; cursor: pointer; color: #2563eb; font-weight: bold; font-size: 13px; padding: 0 2px;">‹</button>
                        <span id="${inst.titleId}" style="font-weight: 700; font-size: 13px; color: #1e293b; margin: 0 4px;"></span>
                        <button type="button" onclick="AamsCalendar.nextMonth('${inputId}')" title="다음 월" style="background: none; border: none; cursor: pointer; color: #2563eb; font-weight: bold; font-size: 13px; padding: 0 2px;">›</button>
                        <button type="button" onclick="AamsCalendar.nextYear('${inputId}')" title="다음 년도" style="background: none; border: none; cursor: pointer; color: #2563eb; font-weight: bold; font-size: 13px; padding: 0 2px;">»</button>
                    </div>
                    <button type="button" onclick="AamsCalendar.setToday('${inputId}')" style="background: #ffffff; border: 1px solid #16a34a; color: #16a34a; font-weight: bold; padding: 1px 7px; font-size: 11px; cursor: pointer; border-radius: 2px;">오늘</button>
                </div>
                <div style="background-color: #3b4859; color: #ffffff; padding: 4px 3px; margin: 3px 0;">
                    <div id="${inst.monthsGridId}" style="display: grid; grid-template-columns: repeat(6, 1fr); gap: 2px; text-align: center; font-size: 11px;"></div>
                </div>
                <div style="display: grid; grid-template-columns: repeat(7, 1fr); text-align: center; font-weight: 600; font-size: 12px; padding: 3px 0; background: #fafafa;">
                    <span style="color: #ef4444;">일</span>
                    <span style="color: #334155;">월</span>
                    <span style="color: #334155;">화</span>
                    <span style="color: #334155;">수</span>
                    <span style="color: #334155;">목</span>
                    <span style="color: #334155;">금</span>
                    <span style="color: #2563eb;">토</span>
                </div>
                <div id="${inst.daysGridId}" style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 1px; text-align: center; font-size: 12px; padding: 2px 0;"></div>
            `;

            wrapper.appendChild(popover);
        },

        loadHighlightDates: function(inputId, apiUrl, paramCorpGr) {
            const inst = instances[inputId];
            if (!inst || inst.isSimple) return;
            const targetUrl = (apiUrl || inst.datesApiUrl) + (paramCorpGr ? '?corpGr=' + encodeURIComponent(paramCorpGr) : '');
            fetch(targetUrl)
                .then(res => res.json())
                .then(dates => {
                    if (Array.isArray(dates)) {
                        inst.trDatesSet = new Set(dates);
                        this.render(inputId);
                    }
                })
                .catch(err => console.error("AamsCalendar error loading dates:", err));
        },

        toggle: function(inputId, e) {
            if (inputId && typeof inputId === 'object' && inputId.nodeType === 1) {
                inputId = inputId.id || inputId.getAttribute('name') || 'filterYmd';
            }
            let inst = instances[inputId];
            
            // Event target에서 현재 활성 tab-pane 감지 및 인스턴스 pane 보정
            const eventPane = (e && e.target && typeof e.target.closest === 'function') ? e.target.closest('.tab-pane') : null;
            if (eventPane) {
                if (!inst) {
                    const paneInput = eventPane.querySelector('#' + inputId);
                    this.initSimple(inputId, { pane: eventPane, initialYmd: paneInput ? paneInput.value : "" });
                    inst = instances[inputId];
                } else if (inst.pane && inst.pane !== eventPane) {
                    inst.pane = eventPane;
                }
            }

            if (!inst) {
                const inputEl = this.getElement(inputId, null);
                if (inputEl) {
                    this.initSimple(inputId, { initialYmd: inputEl.value });
                    inst = instances[inputId];
                }
            }
            if (!inst) {
                console.warn("[AamsCalendar] No calendar instance registered for:", inputId);
                return;
            }
            let popover = this.getElement(inst.popoverId, inst.pane);
            if (!popover) {
                this.buildDOM(inputId, inst.initialYmd || "");
                popover = this.getElement(inst.popoverId, inst.pane);
            }
            if (!popover) return;
            if (popover.style.display === "none" || popover.style.display === "") {
                this.render(inputId);
                popover.style.display = "block";
            } else {
                popover.style.display = "none";
            }
        },

        close: function(inputId) {
            const inst = instances[inputId];
            if (!inst) return;
            const popover = this.getElement(inst.popoverId, inst.pane);
            if (popover) popover.style.display = "none";
        },

        prevYear: function(inputId) {
            const inst = instances[inputId];
            if (!inst) return;
            inst.calYear--;
            this.render(inputId);
        },

        nextYear: function(inputId) {
            const inst = instances[inputId];
            if (!inst) return;
            inst.calYear++;
            this.render(inputId);
        },

        prevMonth: function(inputId) {
            const inst = instances[inputId];
            if (!inst) return;
            inst.calMonth--;
            if (inst.calMonth < 0) {
                inst.calMonth = 11;
                inst.calYear--;
            }
            this.render(inputId);
        },

        nextMonth: function(inputId) {
            const inst = instances[inputId];
            if (!inst) return;
            inst.calMonth++;
            if (inst.calMonth > 11) {
                inst.calMonth = 0;
                inst.calYear++;
            }
            this.render(inputId);
        },

        selectMonth: function(inputId, mIndex) {
            const inst = instances[inputId];
            if (!inst) return;
            inst.calMonth = mIndex;
            this.render(inputId);
        },

        setToday: function(inputId) {
            const inst = instances[inputId];
            if (!inst) return;
            const now = new Date();
            const y = now.getFullYear();
            const m = String(now.getMonth() + 1).padStart(2, '0');
            const d = String(now.getDate()).padStart(2, '0');
            const todayStr = `${y}-${m}-${d}`;
            
            const inputEl = this.getElement(inputId, inst.pane);
            if (inputEl) {
                inputEl.value = todayStr;
                try {
                    inputEl.dispatchEvent(new Event('input', { bubbles: true }));
                    inputEl.dispatchEvent(new Event('change', { bubbles: true }));
                } catch(e) {}
            }

            inst.calYear = y;
            inst.calMonth = now.getMonth();
            this.close(inputId);

            if (typeof inst.onSelect === 'function') {
                inst.onSelect(todayStr);
            }
        },

        render: function(inputId) {
            const inst = instances[inputId];
            if (!inst) return;

            const titleEl = this.getElement(inst.titleId, inst.pane);
            const monthsGridEl = this.getElement(inst.monthsGridId, inst.pane);
            const daysGridEl = this.getElement(inst.daysGridId, inst.pane);
            if (!titleEl || !monthsGridEl || !daysGridEl) return;

            // 1. Header Title
            titleEl.textContent = `${inst.calYear}년 ${inst.calMonth + 1}월`;

            // 2. Month Selector Band
            monthsGridEl.innerHTML = "";
            for (let m = 0; m < 12; m++) {
                const mNum = String(m + 1).padStart(2, '0') + "월";
                const mSpan = document.createElement("span");
                mSpan.textContent = mNum;
                mSpan.style.cursor = "pointer";
                mSpan.style.padding = "1px 0";

                if (m === inst.calMonth) {
                    mSpan.style.color = "#ffff00";
                    mSpan.style.fontWeight = "bold";
                    mSpan.style.textDecoration = "underline";
                } else {
                    mSpan.style.color = "#e2e8f0";
                }

                mSpan.onclick = (function(monthIdx) {
                    return function(e) {
                        e.stopPropagation();
                        AamsCalendar.selectMonth(inputId, monthIdx);
                    };
                })(m);
                monthsGridEl.appendChild(mSpan);
            }

            // 3. Days Grid (42 Cells)
            daysGridEl.innerHTML = "";

            const inputEl = this.getElement(inputId, inst.pane);
            const selectedYmd = inputEl ? inputEl.value : "";

            const firstDayOfWeek = new Date(inst.calYear, inst.calMonth, 1).getDay();
            const prevMonthLastDate = new Date(inst.calYear, inst.calMonth, 0).getDate();
            const currentMonthLastDate = new Date(inst.calYear, inst.calMonth + 1, 0).getDate();
            const totalCells = 42;

            // Prev month overflow
            for (let i = firstDayOfWeek - 1; i >= 0; i--) {
                const day = prevMonthLastDate - i;
                const prevM = (inst.calMonth - 1 < 0) ? 11 : inst.calMonth - 1;
                const prevY = (inst.calMonth - 1 < 0) ? inst.calYear - 1 : inst.calYear;
                const ymd = `${prevY}-${String(prevM + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;

                const btn = this.createDayButton(inputId, day, ymd, true, false, false, false);
                daysGridEl.appendChild(btn);
            }

            // Current month days
            for (let day = 1; day <= currentMonthLastDate; day++) {
                const ymd = `${inst.calYear}-${String(inst.calMonth + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
                const hasHistory = !inst.isSimple && inst.trDatesSet.has(ymd);
                const isSelected = (ymd === selectedYmd);
                const dayOfWeek = new Date(inst.calYear, inst.calMonth, day).getDay();

                const btn = this.createDayButton(inputId, day, ymd, false, hasHistory, isSelected, dayOfWeek);
                daysGridEl.appendChild(btn);
            }

            // Next month overflow
            const renderedCount = daysGridEl.children.length;
            const remainingCells = totalCells - renderedCount;
            for (let day = 1; day <= remainingCells; day++) {
                const nextM = (inst.calMonth + 1 > 11) ? 0 : inst.calMonth + 1;
                const nextY = (inst.calMonth + 1 > 11) ? inst.calYear + 1 : inst.calYear;
                const ymd = `${nextY}-${String(nextM + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;

                const btn = this.createDayButton(inputId, day, ymd, true, false, false, false);
                daysGridEl.appendChild(btn);
            }
        },

        createDayButton: function(inputId, dayNumber, ymd, isOverflow, hasHistory, isSelected, dayOfWeek) {
            const btn = document.createElement("button");
            btn.type = "button";
            btn.textContent = dayNumber;
            btn.style.cssText = "width: 100%; padding: 3px 0; border: none; background: none; cursor: pointer; font-size: 12px; line-height: 1.2; border-radius: 2px;";

            if (isOverflow) {
                btn.style.color = "#94a3b8";
            } else {
                if (hasHistory) {
                    btn.style.color = "#00cc00"; // Bright vivid green
                    btn.style.fontWeight = "900";
                    btn.style.fontSize = "13px";
                    const inst = instances[inputId];
                    btn.title = (inst && inst.historyTitle) ? inst.historyTitle : "데이터 존재";
                } else if (dayOfWeek === 0) {
                    btn.style.color = "#ef4444"; // Sunday red
                } else if (dayOfWeek === 6) {
                    btn.style.color = "#2563eb"; // Saturday blue
                } else {
                    btn.style.color = "#1e293b";
                }

                if (isSelected) {
                    btn.style.fontWeight = "900";
                    btn.style.textDecoration = "underline";
                    btn.style.color = "#000000";
                    btn.style.backgroundColor = "#e2e8f0";
                }
            }

            btn.onmouseenter = function() {
                if (!isSelected) {
                    btn.style.backgroundColor = "#f1f5f9";
                }
            };
            btn.onmouseleave = function() {
                if (!isSelected) {
                    btn.style.backgroundColor = "transparent";
                }
            };

            const self = this;
            btn.onclick = function(e) {
                e.stopPropagation();
                const inst = instances[inputId];
                const inputEl = self.getElement(inputId, inst ? inst.pane : null);
                if (inputEl) {
                    inputEl.value = ymd;
                    try {
                        inputEl.dispatchEvent(new Event('input', { bubbles: true }));
                        inputEl.dispatchEvent(new Event('change', { bubbles: true }));
                    } catch(err) {}
                }
                self.close(inputId);

                if (inst && typeof inst.onSelect === 'function') {
                    inst.onSelect(ymd);
                }
            };

            return btn;
        },

        bindOutsideClick: function(inputId) {
            const inst = instances[inputId];
            if (!inst || inst.clickBound) return;

            const self = this;
            document.addEventListener("click", function(e) {
                const currentInst = instances[inputId];
                if (!currentInst) return;
                const popover = self.getElement(currentInst.popoverId, currentInst.pane);
                const inputEl = self.getElement(inputId, currentInst.pane);
                const wrapper = popover ? popover.closest(".aams-calendar-wrapper") : (inputEl ? inputEl.closest(".aams-calendar-wrapper") : null);
                if (popover && popover.style.display === "block") {
                    if (wrapper && !wrapper.contains(e.target)) {
                        self.close(inputId);
                    }
                }
            });
            inst.clickBound = true;
        },

        // =========================================================================
        // AAMS Range Calendar (From-To w_calendar4day2 implementation)
        // =========================================================================
        rangeInstances: {},

        /**
         * Initialize dual From-To Range Calendar
         * @param {string} fromInputId - ID of start date input (e.g. 'filterFYmd')
         * @param {string} toInputId   - ID of end date input (e.g. 'filterTYmd')
         * @param {object} options     - { initialFYmd, initialTYmd, pane, onSelect, separator }
         */
        initRange: function(fromInputId, toInputId, options) {
            options = options || {};
            const rangeId = fromInputId + "_" + toInputId;
            const pane = options.pane || null;

            const fromEl = this.getElement(fromInputId, pane);
            const toEl = this.getElement(toInputId, pane);
            if (!fromEl || !toEl) {
                console.warn("[AamsCalendar] initRange: Inputs not found", fromInputId, toInputId);
                return;
            }

            // Determine initial dates
            const today = new Date();
            const todayStr = this.formatDate(today.getFullYear(), today.getMonth() + 1, today.getDate(), '.');

            let curFYmd = options.initialFYmd || fromEl.value || todayStr;
            let curTYmd = options.initialTYmd || toEl.value || todayStr;

            // Normalize format with dot '.' if hyphens were used
            curFYmd = curFYmd.replace(/-/g, '.');
            curTYmd = curTYmd.replace(/-/g, '.');

            fromEl.value = curFYmd;
            toEl.value = curTYmd;

            const fParsed = this.parseDateStr(curFYmd);
            const tParsed = this.parseDateStr(curTYmd);

            this.rangeInstances[rangeId] = {
                rangeId: rangeId,
                fromInputId: fromInputId,
                toInputId: toInputId,
                pane: pane,
                curFYmd: curFYmd,
                curTYmd: curTYmd,
                backupFYmd: curFYmd,
                backupTYmd: curTYmd,
                calYearF: fParsed.year,
                calMonthF: fParsed.month,
                calYearT: tParsed.year,
                calMonthT: tParsed.month,
                onSelect: options.onSelect || null,
                popoverId: "range_popover_" + rangeId
            };

            this.buildRangeDOM(rangeId);
            this.renderRange(rangeId);
            this.bindRangeOutsideClick(rangeId);
        },

        parseDateStr: function(dateStr) {
            const today = new Date();
            if (!dateStr) {
                return { year: today.getFullYear(), month: today.getMonth(), day: today.getDate() };
            }
            const clean = dateStr.replace(/\D/g, '');
            if (clean.length === 8) {
                return {
                    year: parseInt(clean.substring(0, 4), 10),
                    month: parseInt(clean.substring(4, 6), 10) - 1,
                    day: parseInt(clean.substring(6, 8), 10)
                };
            }
            return { year: today.getFullYear(), month: today.getMonth(), day: today.getDate() };
        },

        formatDate: function(year, month, day, sep) {
            sep = sep || '.';
            const m = month < 10 ? '0' + month : '' + month;
            const d = day < 10 ? '0' + day : '' + day;
            return year + sep + m + sep + d;
        },

        buildRangeDOM: function(rangeId) {
            const inst = this.rangeInstances[rangeId];
            if (!inst) return;

            const fromEl = this.getElement(inst.fromInputId, inst.pane);
            const toEl = this.getElement(inst.toInputId, inst.pane);
            if (!fromEl || !toEl) return;

            // Ensure wrapper
            let wrapper = fromEl.closest('.range-calendar-wrapper');
            if (!wrapper) {
                wrapper = document.createElement('div');
                wrapper.className = 'range-calendar-wrapper';

                // Check if separator already exists between them
                let separator = fromEl.nextElementSibling;
                const hasExistingSep = separator && (separator.classList.contains('filter-separator') || separator.textContent.trim() === '~');

                fromEl.parentNode.insertBefore(wrapper, fromEl);
                wrapper.appendChild(fromEl);

                if (hasExistingSep) {
                    separator.className = 'range-calendar-separator';
                    wrapper.appendChild(separator);
                } else {
                    const sep = document.createElement('span');
                    sep.className = 'range-calendar-separator';
                    sep.textContent = '~';
                    wrapper.appendChild(sep);
                }

                wrapper.appendChild(toEl);

                // Add Calendar Popup Button
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'btn-range-calendar';
                btn.title = '기간 선택 달력';
                btn.innerHTML = '<i class="fa-regular fa-calendar-days"></i>';
                btn.onclick = function(e) {
                    e.stopPropagation();
                    AamsCalendar.toggleRange(rangeId);
                };
                wrapper.appendChild(btn);
            }

            // Input element styling & click events
            try { fromEl.type = 'text'; } catch(e) {}
            try { toEl.type = 'text'; } catch(e) {}

            fromEl.className = 'filter-input range-calendar-input';
            toEl.className = 'filter-input range-calendar-input';
            fromEl.readOnly = true;
            toEl.readOnly = true;

            fromEl.onclick = function(e) {
                e.stopPropagation();
                AamsCalendar.toggleRange(rangeId);
            };
            toEl.onclick = function(e) {
                e.stopPropagation();
                AamsCalendar.toggleRange(rangeId);
            };

            // Remove existing popover if present
            const oldPopover = document.getElementById(inst.popoverId);
            if (oldPopover) oldPopover.remove();

            // Create Popover Window
            const popover = document.createElement('div');
            popover.id = inst.popoverId;
            popover.className = 'range-calendar-popover';

            popover.innerHTML = `
                <div class="range-calendar-content">
                    <!-- 1. Left Calendar (From) -->
                    <div class="range-calendar-pane" id="pane_from_${rangeId}">
                        <div class="range-cal-header">
                            <div class="range-cal-nav">
                                <button type="button" onclick="AamsCalendar.rangeNav('${rangeId}', 'F', 'prevYear')" title="이전 년도">«</button>
                                <button type="button" onclick="AamsCalendar.rangeNav('${rangeId}', 'F', 'prevMonth')" title="이전 월">‹</button>
                                <span class="range-cal-title" id="title_from_${rangeId}"></span>
                                <button type="button" onclick="AamsCalendar.rangeNav('${rangeId}', 'F', 'nextMonth')" title="다음 월">›</button>
                                <button type="button" onclick="AamsCalendar.rangeNav('${rangeId}', 'F', 'nextYear')" title="다음 년도">»</button>
                            </div>
                            <button type="button" class="range-cal-btn-today" onclick="AamsCalendar.rangeToday('${rangeId}', 'F')">오늘</button>
                        </div>
                        <div class="range-cal-months-bar">
                            <div class="range-cal-months-grid" id="months_from_${rangeId}"></div>
                        </div>
                        <div class="range-cal-weekdays">
                            <span style="color: #ef4444;">일</span>
                            <span style="color: #334155;">월</span>
                            <span style="color: #334155;">화</span>
                            <span style="color: #334155;">수</span>
                            <span style="color: #334155;">목</span>
                            <span style="color: #334155;">금</span>
                            <span style="color: #2563eb;">토</span>
                        </div>
                        <div class="range-cal-days-grid" id="days_from_${rangeId}"></div>
                    </div>

                    <!-- 2. Middle Control Center (3 Buttons matching PowerBuilder w_calendar4day2) -->
                    <div class="range-calendar-center">
                        <!-- Top: 중지하고 나가기 (btn_calender_stop.jpg / ■) -->
                        <button type="button" class="btn-range-center btn-range-stop" onclick="AamsCalendar.cancelRange('${rangeId}')" title="중지하고 나가기">
                            <i class="fa-solid fa-square"></i>
                        </button>

                        <!-- Middle: 좌측 달력의 날짜 기준으로 당일 조회 (btn_calender_from.jpg / ↦) -->
                        <button type="button" class="btn-range-center btn-range-sync-from" onclick="AamsCalendar.syncFrom('${rangeId}')" title="좌측 달력의 날짜 기준으로 당일 조회">
                            <i class="fa-solid fa-arrow-right"></i>
                        </button>

                        <!-- Bottom: 우측 달력의 날짜 기준으로 당일 조회 (btn_calender_to.jpg / ↤) -->
                        <button type="button" class="btn-range-center btn-range-sync-to" onclick="AamsCalendar.syncTo('${rangeId}')" title="우측 달력의 날짜 기준으로 당일 조회">
                            <i class="fa-solid fa-arrow-left"></i>
                        </button>
                    </div>

                    <!-- 3. Right Calendar (To) -->
                    <div class="range-calendar-pane" id="pane_to_${rangeId}">
                        <div class="range-cal-header">
                            <div class="range-cal-nav">
                                <button type="button" onclick="AamsCalendar.rangeNav('${rangeId}', 'T', 'prevYear')" title="이전 년도">«</button>
                                <button type="button" onclick="AamsCalendar.rangeNav('${rangeId}', 'T', 'prevMonth')" title="이전 월">‹</button>
                                <span class="range-cal-title" id="title_to_${rangeId}"></span>
                                <button type="button" onclick="AamsCalendar.rangeNav('${rangeId}', 'T', 'nextMonth')" title="다음 월">›</button>
                                <button type="button" onclick="AamsCalendar.rangeNav('${rangeId}', 'T', 'nextYear')" title="다음 년도">»</button>
                            </div>
                            <button type="button" class="range-cal-btn-today" onclick="AamsCalendar.rangeToday('${rangeId}', 'T')">오늘</button>
                        </div>
                        <div class="range-cal-months-bar">
                            <div class="range-cal-months-grid" id="months_to_${rangeId}"></div>
                        </div>
                        <div class="range-cal-weekdays">
                            <span style="color: #ef4444;">일</span>
                            <span style="color: #334155;">월</span>
                            <span style="color: #334155;">화</span>
                            <span style="color: #334155;">수</span>
                            <span style="color: #334155;">목</span>
                            <span style="color: #334155;">금</span>
                            <span style="color: #2563eb;">토</span>
                        </div>
                        <div class="range-cal-days-grid" id="days_to_${rangeId}"></div>
                    </div>
                </div>
            `;

            wrapper.appendChild(popover);
        },

        renderRange: function(rangeId) {
            const inst = this.rangeInstances[rangeId];
            if (!inst) return;

            // Render Left Calendar (From)
            this.renderSinglePane(rangeId, 'F', inst.calYearF, inst.calMonthF, inst.curFYmd);

            // Render Right Calendar (To)
            this.renderSinglePane(rangeId, 'T', inst.calYearT, inst.calMonthT, inst.curTYmd);
        },

        renderSinglePane: function(rangeId, side, year, month, selectedYmd) {
            const inst = this.rangeInstances[rangeId];
            const suffix = side === 'F' ? '_from_' + rangeId : '_to_' + rangeId;

            // Title
            const titleEl = (inst && inst.pane && inst.pane.querySelector('#title' + suffix)) || document.getElementById('title' + suffix);
            if (titleEl) {
                titleEl.textContent = year + "년 " + (month + 1) + "월";
            }

            // Months Bar (01월 ~ 12월)
            const monthsEl = (inst && inst.pane && inst.pane.querySelector('#months' + suffix)) || document.getElementById('months' + suffix);
            if (monthsEl) {
                monthsEl.innerHTML = '';
                for (let m = 0; m < 12; m++) {
                    const mSpan = document.createElement('span');
                    mSpan.className = 'range-cal-month-item' + (m === month ? ' active' : '');
                    mSpan.textContent = (m < 9 ? '0' : '') + (m + 1) + '월';
                    mSpan.onclick = function(e) {
                        e.stopPropagation();
                        AamsCalendar.rangeSelectMonth(rangeId, side, m);
                    };
                    monthsEl.appendChild(mSpan);
                }
            }

            // Days Grid (42 cells: 6 weeks x 7 days)
            const daysEl = (inst && inst.pane && inst.pane.querySelector('#days' + suffix)) || document.getElementById('days' + suffix);
            if (daysEl) {
                daysEl.innerHTML = '';

                const firstDay = new Date(year, month, 1);
                let startDayOfWeek = firstDay.getDay(); // 0(일) ~ 6(토)
                const daysInMonth = new Date(year, month + 1, 0).getDate();
                const daysInPrevMonth = new Date(year, month, 0).getDate();

                // Prev month days
                for (let i = startDayOfWeek - 1; i >= 0; i--) {
                    const prevDay = daysInPrevMonth - i;
                    const cellDate = new Date(year, month - 1, prevDay);
                    const ymdStr = this.formatDate(cellDate.getFullYear(), cellDate.getMonth() + 1, cellDate.getDate(), '.');
                    daysEl.appendChild(this.createRangeDayCell(rangeId, side, prevDay, ymdStr, true, ymdStr === selectedYmd));
                }

                // Current month days
                for (let d = 1; d <= daysInMonth; d++) {
                    const ymdStr = this.formatDate(year, month + 1, d, '.');
                    const dow = new Date(year, month, d).getDay();
                    daysEl.appendChild(this.createRangeDayCell(rangeId, side, d, ymdStr, false, ymdStr === selectedYmd, dow));
                }

                // Next month days to fill 42 cells (or 35)
                const totalRendered = startDayOfWeek + daysInMonth;
                const nextDaysNeeded = totalRendered > 35 ? (42 - totalRendered) : (35 - totalRendered);
                for (let n = 1; n <= nextDaysNeeded; n++) {
                    const cellDate = new Date(year, month + 1, n);
                    const ymdStr = this.formatDate(cellDate.getFullYear(), cellDate.getMonth() + 1, cellDate.getDate(), '.');
                    daysEl.appendChild(this.createRangeDayCell(rangeId, side, n, ymdStr, true, ymdStr === selectedYmd));
                }
            }
        },

        createRangeDayCell: function(rangeId, side, dayNum, ymdStr, isOtherMonth, isSelected, dayOfWeek) {
            const cell = document.createElement('div');
            cell.className = 'range-cal-day-cell' + (isOtherMonth ? ' other-month' : '') + (isSelected ? ' selected' : '');
            cell.textContent = dayNum;

            if (!isOtherMonth && !isSelected) {
                if (dayOfWeek === 0) cell.style.color = '#ef4444'; // 일요일 빨강
                else if (dayOfWeek === 6) cell.style.color = '#2563eb'; // 토요일 파랑
                else cell.style.color = '#1e293b';
            }

            // Click: change date on this side
            cell.onclick = function(e) {
                e.stopPropagation();
                AamsCalendar.rangeSelectDate(rangeId, side, ymdStr);
            };

            // Double Click: confirm and choose both dates, trigger search & close
            cell.ondblclick = function(e) {
                e.stopPropagation();
                AamsCalendar.rangeSelectDate(rangeId, side, ymdStr);
                AamsCalendar.confirmRange(rangeId);
            };

            return cell;
        },

        rangeSelectDate: function(rangeId, side, ymdStr) {
            const inst = this.rangeInstances[rangeId];
            if (!inst) return;

            const fromEl = this.getElement(inst.fromInputId, inst.pane);
            const toEl = this.getElement(inst.toInputId, inst.pane);

            if (side === 'F') {
                inst.curFYmd = ymdStr;
                if (fromEl) fromEl.value = ymdStr;
                // If From is after To, adjust To as well
                if (inst.curFYmd > inst.curTYmd) {
                    inst.curTYmd = ymdStr;
                    if (toEl) toEl.value = ymdStr;
                }
            } else {
                inst.curTYmd = ymdStr;
                if (toEl) toEl.value = ymdStr;
                // If To is before From, adjust From as well
                if (inst.curTYmd < inst.curFYmd) {
                    inst.curFYmd = ymdStr;
                    if (fromEl) fromEl.value = ymdStr;
                }
            }

            this.renderRange(rangeId);
        },

        confirmRange: function(rangeId) {
            const inst = this.rangeInstances[rangeId];
            if (!inst) return;
            inst.backupFYmd = inst.curFYmd;
            inst.backupTYmd = inst.curTYmd;
            this.closeRange(rangeId);
            if (typeof inst.onSelect === 'function') {
                inst.onSelect(inst.curFYmd, inst.curTYmd);
            }
        },

        // Navigation for single side
        rangeNav: function(rangeId, side, action) {
            const inst = this.rangeInstances[rangeId];
            if (!inst) return;

            let year = side === 'F' ? inst.calYearF : inst.calYearT;
            let month = side === 'F' ? inst.calMonthF : inst.calMonthT;

            switch (action) {
                case 'prevYear': year--; break;
                case 'nextYear': year++; break;
                case 'prevMonth':
                    month--;
                    if (month < 0) { month = 11; year--; }
                    break;
                case 'nextMonth':
                    month++;
                    if (month > 11) { month = 0; year++; }
                    break;
            }

            if (side === 'F') {
                inst.calYearF = year;
                inst.calMonthF = month;
            } else {
                inst.calYearT = year;
                inst.calMonthT = month;
            }

            this.renderRange(rangeId);
        },

        rangeSelectMonth: function(rangeId, side, m) {
            const inst = this.rangeInstances[rangeId];
            if (!inst) return;
            if (side === 'F') inst.calMonthF = m;
            else inst.calMonthT = m;
            this.renderRange(rangeId);
        },

        rangeToday: function(rangeId, side) {
            const inst = this.rangeInstances[rangeId];
            if (!inst) return;
            const today = new Date();
            const todayStr = this.formatDate(today.getFullYear(), today.getMonth() + 1, today.getDate(), '.');

            if (side === 'F') {
                inst.calYearF = today.getFullYear();
                inst.calMonthF = today.getMonth();
                this.rangeSelectDate(rangeId, 'F', todayStr);
            } else {
                inst.calYearT = today.getFullYear();
                inst.calMonthT = today.getMonth();
                this.rangeSelectDate(rangeId, 'T', todayStr);
            }
        },

        // Middle button 1: Close / Stop without revert
        closeRange: function(rangeId) {
            const inst = this.rangeInstances[rangeId];
            if (!inst) return;
            const popover = (inst.pane && inst.pane.querySelector('#' + inst.popoverId)) || document.getElementById(inst.popoverId);
            if (popover) popover.style.display = 'none';
        },

        // Middle button 1: 중지하고 나가기 / 취소 (■ 버튼) - 기존 값으로 되돌리고 닫기
        cancelRange: function(rangeId) {
            const inst = this.rangeInstances[rangeId];
            if (!inst) return;

            const fromEl = this.getElement(inst.fromInputId, inst.pane);
            const toEl = this.getElement(inst.toInputId, inst.pane);

            // 기존 백업 값으로 복원
            const revertF = inst.backupFYmd || inst.curFYmd;
            const revertT = inst.backupTYmd || inst.curTYmd;

            inst.curFYmd = revertF;
            inst.curTYmd = revertT;

            if (fromEl) fromEl.value = revertF;
            if (toEl) toEl.value = revertT;

            const parsedF = this.parseDateStr(revertF);
            inst.calYearF = parsedF.year;
            inst.calMonthF = parsedF.month;

            const parsedT = this.parseDateStr(revertT);
            inst.calYearT = parsedT.year;
            inst.calMonthT = parsedT.month;

            this.renderRange(rangeId);

            const popover = (inst.pane && inst.pane.querySelector('#' + inst.popoverId)) || document.getElementById(inst.popoverId);
            if (popover) popover.style.display = 'none';
        },

        toggleRange: function(rangeId, e) {
            if (e && typeof e.stopPropagation === 'function') {
                e.stopPropagation();
            }
            let inst = this.rangeInstances[rangeId];
            if (!inst) {
                const parts = rangeId.split('_');
                if (parts.length === 2) {
                    this.initRange(parts[0], parts[1]);
                    inst = this.rangeInstances[rangeId];
                }
            }
            if (!inst) return;
            let popover = (inst.pane && inst.pane.querySelector('#' + inst.popoverId)) || document.getElementById(inst.popoverId);
            if (!popover) {
                this.buildRangeDOM(rangeId);
                this.renderRange(rangeId);
                popover = (inst.pane && inst.pane.querySelector('#' + inst.popoverId)) || document.getElementById(inst.popoverId);
            }
            if (!popover) return;

            if (popover.style.display === 'none' || popover.style.display === '') {
                // Sync current input values into cal and backup
                const fromEl = this.getElement(inst.fromInputId, inst.pane);
                const toEl = this.getElement(inst.toInputId, inst.pane);
                if (fromEl && fromEl.value) {
                    inst.curFYmd = fromEl.value.replace(/-/g, '.');
                    const parsed = this.parseDateStr(inst.curFYmd);
                    inst.calYearF = parsed.year;
                    inst.calMonthF = parsed.month;
                }
                if (toEl && toEl.value) {
                    inst.curTYmd = toEl.value.replace(/-/g, '.');
                    const parsed = this.parseDateStr(inst.curTYmd);
                    inst.calYearT = parsed.year;
                    inst.calMonthT = parsed.month;
                }
                // 팝오버 열리는 시점의 원래 값 백업
                inst.backupFYmd = inst.curFYmd;
                inst.backupTYmd = inst.curTYmd;

                this.renderRange(rangeId);
                popover.style.display = 'block';
            } else {
                // 열려있는 상태에서 다시 호출 시 원래 값으로 되돌리고 닫음
                this.cancelRange(rangeId);
            }
        },

        // Middle button 2: 좌측 달력 날짜 기준으로 당일 조회 (↦)
        syncFrom: function(rangeId) {
            const inst = this.rangeInstances[rangeId];
            if (!inst) return;
            const date = inst.curFYmd;
            const fromEl = this.getElement(inst.fromInputId, inst.pane);
            const toEl = this.getElement(inst.toInputId, inst.pane);

            if (fromEl) fromEl.value = date;
            if (toEl) toEl.value = date;
            inst.curTYmd = date;

            // 확정되었으므로 백업값 갱신
            inst.backupFYmd = date;
            inst.backupTYmd = date;

            this.closeRange(rangeId);
            if (typeof inst.onSelect === 'function') {
                inst.onSelect(date, date);
            }
        },

        // Middle button 3: 우측 달력 날짜 기준으로 당일 조회 (↤)
        syncTo: function(rangeId) {
            const inst = this.rangeInstances[rangeId];
            if (!inst) return;
            const date = inst.curTYmd;
            const fromEl = this.getElement(inst.fromInputId, inst.pane);
            const toEl = this.getElement(inst.toInputId, inst.pane);

            if (fromEl) fromEl.value = date;
            if (toEl) toEl.value = date;
            inst.curFYmd = date;

            // 확정되었으므로 백업값 갱신
            inst.backupFYmd = date;
            inst.backupTYmd = date;

            this.closeRange(rangeId);
            if (typeof inst.onSelect === 'function') {
                inst.onSelect(date, date);
            }
        },

        bindRangeOutsideClick: function(rangeId) {
            const inst = this.rangeInstances[rangeId];
            if (!inst || inst.clickBound) return;

            const self = this;
            document.addEventListener('click', function(e) {
                const currentInst = self.rangeInstances[rangeId];
                if (!currentInst) return;
                const popover = (currentInst.pane && currentInst.pane.querySelector('#' + currentInst.popoverId)) || document.getElementById(currentInst.popoverId);
                const fromEl = self.getElement(currentInst.fromInputId, currentInst.pane);
                const wrapper = popover ? popover.closest('.range-calendar-wrapper') : (fromEl ? fromEl.closest('.range-calendar-wrapper') : null);

                if (popover && popover.style.display === 'block') {
                    if (wrapper && !wrapper.contains(e.target)) {
                        self.cancelRange(rangeId);
                    }
                }
            });

            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    self.cancelRange(rangeId);
                }
            });

            inst.clickBound = true;
        },

        /**
         * Auto initialize all range calendar pairs in DOM (matching fYmd and tYmd)
         */
        autoInitRanges: function(scopeEl) {
            const scope = scopeEl || document;
            const fromInputs = scope.querySelectorAll(".range-calendar-wrapper input[id*='FYmd'], .range-calendar-wrapper input[name='fYmd'], input[name='fYmd'], input[id*='FYmd'], input[id*='fromYmd']");
            fromInputs.forEach(fromInput => {
                const wrapper = fromInput.closest('.range-calendar-wrapper') || fromInput.closest('.filter-item') || fromInput.parentElement;
                if (!wrapper) return;
                const toInput = wrapper.querySelector("input[name='tYmd'], input[id*='TYmd'], input[id*='toYmd'], .range-calendar-input:last-of-type");
                if (toInput && fromInput.id && toInput.id) {
                    const rangeId = fromInput.id + "_" + toInput.id;
                    if (!AamsCalendar.rangeInstances[rangeId]) {
                        AamsCalendar.initRange(fromInput.id, toInput.id, {
                            pane: (scope.closest && scope.closest('.tab-pane')) ? scope.closest('.tab-pane') : (fromInput.closest ? fromInput.closest('.tab-pane') : null),
                            onSelect: function(fYmd, tYmd) {
                                const pane = fromInput.closest('.tab-pane') || document.querySelector('.tab-pane.active') || document;
                                if (pane && typeof pane.onSearch === 'function') {
                                    pane.onSearch();
                                }
                            }
                        });
                    }
                }
            });
        },

        /**
         * Standalone / Grid-cell DatePicker Popup (p_dd_ buttons)
         * @param {Object} options
         *   - anchorEl: DOM element (cell or button) to position the popup next to
         *   - initialYmd: initial date string (e.g. '2026.09.09' or '20260909' or '2026-09-09')
         *   - onSelect: function(formattedYmd, rawYmd, dotYmd)
         *   - format: 'dot' ('YYYY.MM.DD') | 'dash' ('YYYY-MM-DD') | 'raw' ('YYYYMMDD')
         */
        openDatePicker: function(options) {
            options = options || {};
            const anchorEl = options.anchorEl;
            if (!anchorEl) return;

            const existing = document.getElementById("aams_grid_datepicker_popover");
            if (existing) existing.remove();

            let calYear = new Date().getFullYear();
            let calMonth = new Date().getMonth();
            let selectedYmd = options.initialYmd || "";

            const cleanYmd = String(selectedYmd).replace(/\D/g, "");
            if (cleanYmd.length >= 8) {
                calYear = parseInt(cleanYmd.substring(0, 4), 10);
                calMonth = parseInt(cleanYmd.substring(4, 6), 10) - 1;
            }

            const popover = document.createElement("div");
            popover.id = "aams_grid_datepicker_popover";
            popover.className = "calendar-popover aams-grid-datepicker";
            popover.style.cssText = "position: fixed; z-index: 10000; background: #ffffff; border: 1px solid #708090; box-shadow: 0 4px 15px rgba(0,0,0,0.25); width: 235px; padding: 4px; font-family: '맑은 고딕', sans-serif; border-radius: 4px;";

            const rect = anchorEl.getBoundingClientRect();
            let top = rect.bottom + 4;
            let left = rect.left;
            if (top + 260 > window.innerHeight) {
                top = Math.max(10, rect.top - 265);
            }
            if (left + 240 > window.innerWidth) {
                left = Math.max(10, window.innerWidth - 245);
            }
            popover.style.top = top + "px";
            popover.style.left = left + "px";

            function renderPicker() {
                popover.innerHTML = `
                    <div style="display: flex; align-items: center; justify-content: space-between; padding: 4px 2px; border-bottom: 1px solid #e2e8f0; font-size: 13px;">
                        <div style="display: flex; align-items: center; gap: 3px;">
                            <button type="button" class="btn-picker-nav prev-year" title="이전 년도" style="background: none; border: none; cursor: pointer; color: #2563eb; font-weight: bold; font-size: 13px; padding: 0 2px;">«</button>
                            <button type="button" class="btn-picker-nav prev-month" title="이전 월" style="background: none; border: none; cursor: pointer; color: #2563eb; font-weight: bold; font-size: 13px; padding: 0 2px;">‹</button>
                            <span style="font-weight: 700; font-size: 13px; color: #1e293b; margin: 0 4px;">${calYear}년 ${calMonth + 1}월</span>
                            <button type="button" class="btn-picker-nav next-month" title="다음 월" style="background: none; border: none; cursor: pointer; color: #2563eb; font-weight: bold; font-size: 13px; padding: 0 2px;">›</button>
                            <button type="button" class="btn-picker-nav next-year" title="다음 년도" style="background: none; border: none; cursor: pointer; color: #2563eb; font-weight: bold; font-size: 13px; padding: 0 2px;">»</button>
                        </div>
                        <button type="button" class="btn-picker-today" style="background: #ffffff; border: 1px solid #16a34a; color: #16a34a; font-weight: bold; padding: 1px 7px; font-size: 11px; cursor: pointer; border-radius: 2px;">오늘</button>
                    </div>
                    <div style="background-color: #3b4859; color: #ffffff; padding: 4px 3px; margin: 3px 0;">
                        <div class="picker-months" style="display: grid; grid-template-columns: repeat(6, 1fr); gap: 2px; text-align: center; font-size: 11px;"></div>
                    </div>
                    <div style="display: grid; grid-template-columns: repeat(7, 1fr); text-align: center; font-weight: 600; font-size: 12px; padding: 3px 0; background: #fafafa;">
                        <span style="color: #ef4444;">일</span>
                        <span style="color: #334155;">월</span>
                        <span style="color: #334155;">화</span>
                        <span style="color: #334155;">수</span>
                        <span style="color: #334155;">목</span>
                        <span style="color: #334155;">금</span>
                        <span style="color: #2563eb;">토</span>
                    </div>
                    <div class="picker-days" style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 1px; text-align: center; font-size: 12px; padding: 2px 0;"></div>
                `;

                popover.querySelector(".prev-year").onclick = (e) => { e.stopPropagation(); calYear--; renderPicker(); };
                popover.querySelector(".next-year").onclick = (e) => { e.stopPropagation(); calYear++; renderPicker(); };
                popover.querySelector(".prev-month").onclick = (e) => {
                    e.stopPropagation();
                    calMonth--;
                    if (calMonth < 0) { calMonth = 11; calYear--; }
                    renderPicker();
                };
                popover.querySelector(".next-month").onclick = (e) => {
                    e.stopPropagation();
                    calMonth++;
                    if (calMonth > 11) { calMonth = 0; calYear++; }
                    renderPicker();
                };
                popover.querySelector(".btn-picker-today").onclick = (e) => {
                    e.stopPropagation();
                    const now = new Date();
                    const y = now.getFullYear();
                    const m = String(now.getMonth() + 1).padStart(2, '0');
                    const d = String(now.getDate()).padStart(2, '0');
                    returnSelected(`${y}${m}${d}`, `${y}.${m}.${d}`, `${y}-${m}-${d}`);
                };

                const monthsContainer = popover.querySelector(".picker-months");
                for (let m = 0; m < 12; m++) {
                    const mSpan = document.createElement("span");
                    mSpan.textContent = String(m + 1).padStart(2, '0') + "월";
                    mSpan.style.cursor = "pointer";
                    mSpan.style.padding = "1px 0";
                    if (m === calMonth) {
                        mSpan.style.color = "#ffff00";
                        mSpan.style.fontWeight = "bold";
                        mSpan.style.textDecoration = "underline";
                    } else {
                        mSpan.style.color = "#e2e8f0";
                    }
                    mSpan.onclick = (e) => { e.stopPropagation(); calMonth = m; renderPicker(); };
                    monthsContainer.appendChild(mSpan);
                }

                const daysContainer = popover.querySelector(".picker-days");
                const firstDayOfWeek = new Date(calYear, calMonth, 1).getDay();
                const prevMonthLastDate = new Date(calYear, calMonth, 0).getDate();
                const currentMonthLastDate = new Date(calYear, calMonth + 1, 0).getDate();

                for (let i = firstDayOfWeek - 1; i >= 0; i--) {
                    const day = prevMonthLastDate - i;
                    const prevM = (calMonth - 1 < 0) ? 11 : calMonth - 1;
                    const prevY = (calMonth - 1 < 0) ? calYear - 1 : calYear;
                    daysContainer.appendChild(createDayBtn(prevY, prevM, day, false));
                }

                for (let d = 1; d <= currentMonthLastDate; d++) {
                    daysContainer.appendChild(createDayBtn(calYear, calMonth, d, true));
                }

                const renderedCount = daysContainer.children.length;
                for (let i = 1; i <= 42 - renderedCount; i++) {
                    const nextM = (calMonth + 1 > 11) ? 0 : calMonth + 1;
                    const nextY = (calMonth + 1 > 11) ? calYear + 1 : calYear;
                    daysContainer.appendChild(createDayBtn(nextY, nextM, i, false));
                }
            }

            function createDayBtn(y, m, d, isCurrentMonth) {
                const btn = document.createElement("button");
                btn.type = "button";
                btn.textContent = String(d);
                btn.style.cssText = "background: none; border: none; padding: 3px 0; cursor: pointer; border-radius: 2px; font-size: 12px; width: 100%;";

                const dayOfWeek = new Date(y, m, d).getDay();
                if (!isCurrentMonth) {
                    btn.style.color = "#94a3b8";
                } else if (dayOfWeek === 0) {
                    btn.style.color = "#ef4444";
                } else if (dayOfWeek === 6) {
                    btn.style.color = "#2563eb";
                } else {
                    btn.style.color = "#1e293b";
                }

                const rawYmd = `${y}${String(m + 1).padStart(2, '0')}${String(d).padStart(2, '0')}`;
                if (cleanYmd && rawYmd === cleanYmd) {
                    btn.style.backgroundColor = "#bfdbfe";
                    btn.style.fontWeight = "bold";
                }

                btn.onmouseover = () => { if (btn.style.backgroundColor !== "rgb(191, 219, 254)") btn.style.backgroundColor = "#f1f5f9"; };
                btn.onmouseout = () => { if (btn.style.backgroundColor !== "rgb(191, 219, 254)") btn.style.backgroundColor = "transparent"; };

                btn.onclick = (e) => {
                    e.stopPropagation();
                    const dotYmd = `${y}.${String(m + 1).padStart(2, '0')}.${String(d).padStart(2, '0')}`;
                    const dashYmd = `${y}-${String(m + 1).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
                    returnSelected(rawYmd, dotYmd, dashYmd);
                };
                return btn;
            }

            function returnSelected(rawYmd, dotYmd, dashYmd) {
                closePicker();
                if (typeof options.onSelect === 'function') {
                    const fmt = options.format || (options.initialYmd && options.initialYmd.includes('.') ? 'dot' : (options.initialYmd && options.initialYmd.includes('-') ? 'dash' : 'raw'));
                    if (fmt === 'dot') options.onSelect(dotYmd, rawYmd, dashYmd);
                    else if (fmt === 'dash') options.onSelect(dashYmd, rawYmd, dotYmd);
                    else options.onSelect(rawYmd, dotYmd, dashYmd);
                }
            }

            function closePicker() {
                if (popover && popover.parentElement) {
                    popover.remove();
                }
                document.removeEventListener("click", onDocClick, true);
            }

            function onDocClick(e) {
                if (!popover.contains(e.target) && e.target !== anchorEl && !anchorEl.contains(e.target)) {
                    closePicker();
                }
            }

            document.body.appendChild(popover);
            renderPicker();
            setTimeout(() => {
                document.addEventListener("click", onDocClick, true);
            }, 50);
        }
    };

    if (typeof document !== 'undefined') {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', function() {
                AamsCalendar.autoInitRanges();
            });
        } else {
            setTimeout(function() {
                AamsCalendar.autoInitRanges();
            }, 50);
        }
    }
})();


