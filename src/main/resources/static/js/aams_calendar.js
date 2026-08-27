/**
 * AAMS Pure JavaScript Highlight Calendar Component
 * Dynamically constructs input wrapper, calendar icon button, and PowerBuilder-style calendar popover DOM entirely via JS.
 */
window.AamsCalendar = (function() {
    const instances = {};

    return {
        /**
         * Attach/Initialize calendar instance on an input element ID
         */
        init: function(inputId, options) {
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

            instances[inputId] = {
                inputId: inputId,
                popoverId: inputId + "_popover",
                titleId: inputId + "_title",
                monthsGridId: inputId + "_monthsGrid",
                daysGridId: inputId + "_daysGrid",
                calYear: initialYear,
                calMonth: initialMonth,
                trDatesSet: new Set(options.highlightDates || []),
                datesApiUrl: options.datesApiUrl || null,
                onSelect: options.onSelect || null,
                clickBound: false
            };

            this.buildDOM(inputId, initialYmd);
            this.render(inputId);
            this.bindOutsideClick(inputId);

            if (options.datesApiUrl && (!options.highlightDates || options.highlightDates.length === 0)) {
                this.loadHighlightDates(inputId, options.datesApiUrl, options.corpGr);
            }
        },

        buildDOM: function(inputId, initialYmd) {
            const inputEl = document.getElementById(inputId);
            if (!inputEl) return;

            const inst = instances[inputId];
            if (!inst) return;

            // 1. Create or ensure input wrapper
            let wrapper = inputEl.closest('.aams-calendar-wrapper');
            if (!wrapper) {
                wrapper = document.createElement('div');
                wrapper.className = 'aams-calendar-wrapper';
                wrapper.style.cssText = 'position: relative; display: inline-flex; align-items: center;';

                inputEl.parentNode.insertBefore(wrapper, inputEl);
                wrapper.appendChild(inputEl);

                // Style input element
                inputEl.className = 't-input aams-calendar-input';
                inputEl.style.cssText = 'width: 110px; padding: 4px 8px; font-size: 13px; text-align: center; border: 1px solid #cbd5e1; border-radius: 4px 0 0 4px; cursor: pointer; background: #ffffff;';
                inputEl.readOnly = true;
                if (initialYmd) inputEl.value = initialYmd;
                inputEl.onclick = function() { AamsCalendar.toggle(inputId); };

                // Create calendar icon button
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 't-btn btn-calendar';
                btn.style.cssText = 'padding: 5px 10px; border-radius: 0 4px 4px 0; border-left: none; background-color: #3b82f6; color: #ffffff; border: 1px solid #3b82f6; cursor: pointer;';
                btn.innerHTML = '<i class="fa-regular fa-calendar-days"></i>';
                btn.onclick = function() { AamsCalendar.toggle(inputId); };
                wrapper.appendChild(btn);
            }

            // 2. Create or recreate Popover DOM
            let popover = document.getElementById(inst.popoverId);
            if (popover) {
                popover.remove();
            }

            popover = document.createElement('div');
            popover.id = inst.popoverId;
            popover.className = 'calendar-popover';
            popover.style.cssText = 'display: none; position: absolute; top: 100%; left: 0; margin-top: 6px; z-index: 2000; background: #ffffff; border: 1px solid #708090; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2); width: 235px; padding: 4px; font-family: "맑은 고딕", sans-serif;';

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
            if (!inst) return;
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

        toggle: function(inputId) {
            const inst = instances[inputId];
            if (!inst) return;
            const popover = document.getElementById(inst.popoverId);
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
            const popover = document.getElementById(inst.popoverId);
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
            
            const inputEl = document.getElementById(inputId);
            if (inputEl) inputEl.value = todayStr;

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

            const titleEl = document.getElementById(inst.titleId);
            const monthsGridEl = document.getElementById(inst.monthsGridId);
            const daysGridEl = document.getElementById(inst.daysGridId);
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

            const inputEl = document.getElementById(inputId);
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
                const hasHistory = inst.trDatesSet.has(ymd);
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
            btn.style.cssText = "width: 100%; padding: 3px 0; border: none; background: none; cursor: pointer; font-size: 12px; line-height: 1.2;";

            if (isOverflow) {
                btn.style.color = "#94a3b8";
            } else {
                if (hasHistory) {
                    btn.style.color = "#00cc00"; // Bright vivid green
                    btn.style.fontWeight = "900";
                    btn.style.fontSize = "13px";
                    btn.title = "입출금 이력 존재";
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
                }
            }

            const self = this;
            btn.onclick = function(e) {
                e.stopPropagation();
                const inputEl = document.getElementById(inputId);
                if (inputEl) inputEl.value = ymd;
                self.close(inputId);

                const inst = instances[inputId];
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
                const popover = document.getElementById(currentInst.popoverId);
                const wrapper = popover ? popover.closest(".aams-calendar-wrapper") : null;
                if (popover && popover.style.display === "block") {
                    if (wrapper && !wrapper.contains(e.target)) {
                        self.close(inputId);
                    }
                }
            });
            inst.clickBound = true;
        }
    };
})();
