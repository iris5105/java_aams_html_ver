/**
 * AAMS Common Utility & Module Script
 */

/**
 * Safe fetch JSON with 401 & session expiry error handling
 */
function safeFetchJson(url, options) {
    return fetch(url, options)
        .then(res => {
            if (res.status === 401) {
                window.location.href = '/login?expired=true';
                return null;
            }
            return res.json();
        })
        .then(data => {
            if (data && data.status === 'EXPIRED') {
                window.location.href = '/login?expired=true';
                return null;
            }
            return data;
        })
        .catch(err => {
            console.error('Fetch error for ' + url + ':', err);
            return null;
        });
}
window.safeFetchJson = safeFetchJson;

/**
 * Common HTML Escape Helper
 */
function escapeHtml(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}
window.escapeHtml = escapeHtml;

/**
 * Security Access Verification for corpGr Cookie
 * If corpGr/savedCorpGr cookie is missing during authenticated access, prompt error and force logout on OK click.
 */
function verifyCorpGrCookie() {
    const path = window.location.pathname;
    if (path.includes('/login') || path.includes('/w_login_aams')) {
        return true;
    }

    const corpGrCookie = (typeof getCookie === 'function') ? (getCookie('savedCorpGr') || getCookie('corpGr')) : null;
    if (!corpGrCookie || !corpGrCookie.trim()) {
        alert('비정상적인 접근입니다.');
        handleLogout();
        return false;
    }
    return true;
}

/**
 * Safe Resolution for Current corpGr
 * Resolves corpGr in priority:
 * 1. window.currentCorpGr
 * 2. savedCorpGr / corpGr cookie
 * 3. #filterCorpGr or #corpGrSelect element within pane / document
 */
function resolveCorpGr(pane) {
    if (window.currentCorpGr) return window.currentCorpGr;
    const m = document.cookie.match(/(^|;)\s*savedCorpGr=([^;]+)/) || document.cookie.match(/(^|;)\s*corpGr=([^;]+)/);
    if (m) return decodeURIComponent(m[2]);
    const selectEl = pane ? (pane.querySelector("#filterCorpGr") || pane.querySelector("#corpGrSelect")) : (document.getElementById("filterCorpGr") || document.getElementById("corpGrSelect"));
    if (selectEl && selectEl.value) return selectEl.value;
    return "";
}
window.resolveCorpGr = resolveCorpGr;

// Session security verification and token monitor on DOMContentLoaded
document.addEventListener("DOMContentLoaded", function() {
    if (!window.location.pathname.includes('/login') && !window.location.pathname.includes('/w_login_aams')) {
        if (!verifyCorpGrCookie()) return;
        startTokenMonitor();
    }
});

/**
 * Common Date Formatter (YYYYMMDD -> YYYY-MM-DD or ISO datetime)
 */
function formatDate(val, isDateTime = false) {
    if (!val || val === '-') return '-';
    let s = String(val).trim();
    if (!s) return '-';

    // 8-digit YYYYMMDD
    if (s.length === 8 && /^\d{8}$/.test(s)) {
        return `${s.substring(0, 4)}-${s.substring(4, 6)}-${s.substring(6, 8)}`;
    }

    // ISO / Timestamp / Standard formats
    if (s.includes('-') || s.includes('/')) {
        const parts = s.split(/[ T]/);
        const datePart = parts[0].replace(/\//g, '-');
        const timePart = parts[1] ? parts[1].substring(0, 5) : '';
        if (isDateTime && timePart) {
            return `${datePart} ${timePart}`;
        }
        return datePart;
    }

    return s;
}
window.formatDate = formatDate;

/**
 * Common Number Formatter (1234567.89 -> 1,234,567.89)
 */
function formatNumber(val, decimals, fallback = '-') {
    if (val === null || val === undefined || val === '') return fallback;
    const num = Number(val);
    if (isNaN(num)) return fallback;
    if (typeof decimals === 'number') {
        return num.toLocaleString('ko-KR', { minimumFractionDigits: decimals, maximumFractionDigits: decimals });
    }
    return num.toLocaleString('ko-KR');
}
window.formatNumber = formatNumber;

/**
 * Common Percent Formatter (0.1234 -> 12.34%)
 */
function formatPercent(val, decimals = 2, fallback = '-') {
    if (val === null || val === undefined || val === '') return fallback;
    const num = Number(val);
    if (isNaN(num)) return fallback;
    return num.toLocaleString('ko-KR', { minimumFractionDigits: decimals, maximumFractionDigits: decimals }) + '%';
}
window.formatPercent = formatPercent;

/**
 * Global Toast Notification Engine (AAMS Standard)
 * @param {string} message - Display message
 * @param {string} [type='info'] - 'info' | 'success' | 'warning' | 'error'
 * @param {number} [duration=3000] - Duration in milliseconds
 */
function showToast(message, type = 'info', duration = 3000) {
    if (!message) return;

    let container = document.getElementById('aamsToastContainer');
    if (!container) {
        container = document.createElement('div');
        container.id = 'aamsToastContainer';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `aams-toast ${type}`;

    let iconHtml = '<i class="fa-solid fa-circle-info aams-toast-icon"></i>';
    if (type === 'success') {
        iconHtml = '<i class="fa-solid fa-circle-check aams-toast-icon"></i>';
    } else if (type === 'warning') {
        iconHtml = '<i class="fa-solid fa-triangle-exclamation aams-toast-icon"></i>';
    } else if (type === 'error') {
        iconHtml = '<i class="fa-solid fa-circle-xmark aams-toast-icon"></i>';
    }

    toast.innerHTML = `
        ${iconHtml}
        <span class="aams-toast-message">${escapeHtml(message)}</span>
        <button type="button" class="aams-toast-close" title="닫기">&times;</button>
    `;

    container.appendChild(toast);

    // Force layout reflow before adding .show for smooth CSS transition
    void toast.offsetWidth;
    toast.classList.add('show');

    let timer = null;
    function dismiss() {
        if (timer) clearTimeout(timer);
        toast.classList.remove('show');
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 300);
    }

    const closeBtn = toast.querySelector('.aams-toast-close');
    if (closeBtn) {
        closeBtn.addEventListener('click', dismiss);
    }

    if (duration > 0) {
        timer = setTimeout(dismiss, duration);
    }

    return toast;
}
window.showToast = showToast;

/**
 * Global Alert Helper
 */
function showAlert(message, callback) {
    showToast(message, 'warning', 3500);
    if (typeof callback === 'function') {
        setTimeout(callback, 200);
    }
}
window.showAlert = showAlert;

/**
 * Common Modal Backdrop & ESC Dismissal Setup Helper
 */
function setupModalBackdrop(modalEl, closeCallback) {
    if (!modalEl) return;
    modalEl.addEventListener('click', function(e) {
        if (e.target === modalEl) {
            if (typeof closeCallback === 'function') closeCallback();
        }
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && modalEl.style.display !== 'none' && modalEl.classList.contains('show')) {
            if (typeof closeCallback === 'function') closeCallback();
        }
    });
}
window.setupModalBackdrop = setupModalBackdrop;

/**
 * Logout Handler
 */
function handleLogout() {
    fetch('/api/auth/logout', { method: 'POST' })
        .then(() => {
            localStorage.clear();
            sessionStorage.clear();
            window.location.href = '/login';
        });
}

/**
 * Company Switch Modal Module
 */
let allCompanies = [];

function openCompanyModal() {
    console.log('[DEBUG] openCompanyModal() called');
    const modal = document.getElementById('companyModal');
    if (!modal) {
        console.warn('[DEBUG] #companyModal element not found in DOM! Check if company_modal fragment is included.');
        return;
    }
    modal.style.display = 'flex';
    console.log('[DEBUG] #companyModal displayed. Cached allCompanies count:', allCompanies.length);

    if (allCompanies.length === 0) {
        console.log('[DEBUG] allCompanies is empty. Triggering fetchCompanies()...');
        fetchCompanies();
    } else {
        console.log('[DEBUG] Using cached allCompanies. Calling renderCompanies()...');
        renderCompanies(allCompanies);
    }
}

function closeCompanyModal() {
    console.log('[DEBUG] closeCompanyModal() called');
    const modal = document.getElementById('companyModal');
    if (modal) modal.style.display = 'none';
}

function fetchCompanies() {
    console.log('[DEBUG] fetchCompanies() started - Requesting /api/home/companies');
    safeFetchJson('/api/home/companies')
        .then(data => {
            console.log('[DEBUG] /api/home/companies API response received:', data);
            if (!data) {
                console.warn('[DEBUG] /api/home/companies returned null or undefined!');
                return;
            }
            allCompanies = data || [];
            console.log('[DEBUG] allCompanies updated. Total count:', allCompanies.length);
            renderCompanies(allCompanies);
        })
        .catch(err => {
            console.error('[DEBUG] fetchCompanies() error during API call:', err);
        });
}

function renderCompanies(list) {
    console.log('[DEBUG] renderCompanies() called. List count:', list ? list.length : 0, list);
    const grid = document.getElementById('companyGrid');
    if (!grid) {
        console.warn('[DEBUG] #companyGrid element not found in DOM! Check company_modal.html structure.');
        return;
    }
    if (!list || list.length === 0) {
        console.warn('[DEBUG] Company list is empty. Displaying no data message.');
        grid.innerHTML = '<div style="grid-column: span 2; text-align: center; color: #94a3b8; padding: 20px;">등록된 회사가 없습니다.</div>';
        return;
    }

    const activeCorpGr = window.currentCorpGr || '';
    console.log('[DEBUG] Current active corpGr:', activeCorpGr);

    grid.innerHTML = list.map(c => {
        const isActive = c.corpGr === activeCorpGr ? 'active' : '';
        const logoUrl = `/img/right_logo/fw_top_logo_right_${c.corpGr}.jpg`;
        const companyName = c.companyName || c.corpGr;

        return `
            <div class="company-card ${isActive}" onclick="selectCompany('${c.corpGr}')">
                <img src="${logoUrl}" alt="${companyName}" 
                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                <div class="company-card-fallback" style="display: none;">
                    <span class="company-card-name">${companyName}</span>
                    <span class="company-card-code">(${c.corpGr})</span>
                </div>
            </div>
        `;
    }).join('');
    console.log('[DEBUG] renderCompanies() successfully rendered cards.');
}

function filterCompanies() {
    const searchInput = document.getElementById('companySearchInput');
    if (!searchInput) return;
    const query = searchInput.value.trim().toLowerCase();
    if (!query) {
        renderCompanies(allCompanies);
        return;
    }
    const filtered = allCompanies.filter(c => 
        (c.companyName && c.companyName.toLowerCase().includes(query)) ||
        (c.corpGr && c.corpGr.toLowerCase().includes(query))
    );
    renderCompanies(filtered);
}

function selectCompany(corpGr) {
    const activeCorpGr = window.currentCorpGr || '';
    if (corpGr === activeCorpGr) {
        closeCompanyModal();
        return;
    }
    fetch('/api/auth/switch-company', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ corpGr: corpGr })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            window.location.reload();
        } else {
            alert(data.message || '회사 변경에 실패했습니다.');
        }
    })
    .catch(err => {
        console.error('Error switching company:', err);
        alert('회사 변경 요청 중 오류가 발생했습니다.');
    });
}

/**
 * Access Token Expiration Monitor & Extension Module
 */
let tokenCheckInterval = null;
let tokenCountdownInterval = null;
let currentRemainingSeconds = 0;
let isExtendModalOpen = false;

function formatMMSS(sec) {
    if (sec <= 0) return '00:00';
    const m = Math.floor(sec / 60);
    const s = Math.floor(sec % 60);
    return String(m).padStart(2, '0') + ':' + String(s).padStart(2, '0');
}

let headerTimerInterval = null;

function updateHeaderTimerDisplay() {
    const timerElem = document.getElementById('headerSessionTimer');
    if (!timerElem) return;

    if (currentRemainingSeconds <= 0) {
        timerElem.innerText = '00:00';
        timerElem.classList.add('warning');
        return;
    }

    timerElem.innerText = formatMMSS(currentRemainingSeconds);
    if (currentRemainingSeconds <= 300) {
        timerElem.classList.add('warning');
    } else {
        timerElem.classList.remove('warning');
    }
}

function startTokenMonitor() {
    checkTokenStatus();
    // 15초마다 서버 토큰 만료 상태와 동기화
    if (tokenCheckInterval) clearInterval(tokenCheckInterval);
    tokenCheckInterval = setInterval(checkTokenStatus, 15000);

    // 1초마다 헤더 타이머 실시간 카운트다운
    if (headerTimerInterval) clearInterval(headerTimerInterval);
    headerTimerInterval = setInterval(() => {
        if (currentRemainingSeconds > 0) {
            currentRemainingSeconds--;
            updateHeaderTimerDisplay();
            if (isExtendModalOpen) {
                updateCountdownDisplay();
            }
            if (currentRemainingSeconds <= 0) {
                if (isExtendModalOpen) closeTokenExtendModal();
                handleLogout();
            }
        }
    }, 1000);
}

function checkTokenStatus() {
    safeFetchJson('/api/auth/token-status')
        .then(data => {
            if (!data || !data.success || data.expired) {
                if (isExtendModalOpen) {
                    closeTokenExtendModal();
                }
                handleLogout();
                return;
            }

            currentRemainingSeconds = data.remainingSeconds || 0;
            updateHeaderTimerDisplay();

            // Warning threshold: 5 minutes (300 seconds) before expiration
            if (currentRemainingSeconds <= 300 && currentRemainingSeconds > 0) {
                if (!isExtendModalOpen) {
                    openTokenExtendModal();
                }
            } else if (currentRemainingSeconds > 300) {
                if (isExtendModalOpen) {
                    closeTokenExtendModal();
                }
            }
        });
}

function openTokenExtendModal() {
    const modal = document.getElementById('tokenExtendModal');
    if (!modal) return;

    modal.style.display = 'flex';
    isExtendModalOpen = true;

    // Reset password input and error message
    const pwInput = document.getElementById('extendTokenPassword');
    if (pwInput) {
        pwInput.value = '';
        setTimeout(() => pwInput.focus(), 100);
    }
    const errBox = document.getElementById('extendTokenError');
    if (errBox) errBox.style.display = 'none';

    updateCountdownDisplay();
    updateHeaderTimerDisplay();
    if (tokenCountdownInterval) clearInterval(tokenCountdownInterval);
    tokenCountdownInterval = setInterval(() => {
        currentRemainingSeconds--;
        if (currentRemainingSeconds <= 0) {
            clearInterval(tokenCountdownInterval);
            closeTokenExtendModal();
            handleLogout();
            return;
        }
        updateCountdownDisplay();
    }, 1000);
}

function updateCountdownDisplay() {
    const elem = document.getElementById('tokenCountdown');
    if (elem) {
        elem.innerText = formatMMSS(currentRemainingSeconds);
    }
}

function closeTokenExtendModal() {
    const modal = document.getElementById('tokenExtendModal');
    if (modal) modal.style.display = 'none';
    isExtendModalOpen = false;

    const pwInput = document.getElementById('extendTokenPassword');
    if (pwInput) pwInput.value = '';
    const errBox = document.getElementById('extendTokenError');
    if (errBox) errBox.style.display = 'none';

    if (tokenCountdownInterval) {
        clearInterval(tokenCountdownInterval);
        tokenCountdownInterval = null;
    }
}

function showExtendTokenError(msg) {
    const errBox = document.getElementById('extendTokenError');
    const errText = document.getElementById('extendTokenErrorText');
    if (errBox && errText) {
        errText.textContent = msg;
        errBox.style.display = 'block';
    } else {
        alert(msg);
    }
    const pwInput = document.getElementById('extendTokenPassword');
    if (pwInput) {
        pwInput.focus();
        pwInput.select();
    }
}

function extendAccessToken() {
    const pwInput = document.getElementById('extendTokenPassword');
    const password = pwInput ? pwInput.value.trim() : '';

    if (!password) {
        showExtendTokenError('비밀번호를 입력해주세요.');
        return;
    }

    const btn = document.getElementById('btnExtendToken');
    if (btn) {
        btn.disabled = true;
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> 확인 중...';
    }

    fetch('/api/auth/extend-token', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ password: password })
    })
    .then(res => res.json())
    .then(data => {
        if (btn) {
            btn.disabled = false;
            btn.innerHTML = '<i class="fa-solid fa-hourglass-half"></i> 1시간 연장하기';
        }
        if (data && data.success) {
            closeTokenExtendModal();
            currentRemainingSeconds = data.remainingSeconds || 3600;
            startTokenMonitor();
            alert('로그인 시간이 1시간 연장되었습니다.');
        } else {
            showExtendTokenError(data.message || '비밀번호가 올바르지 않습니다.');
        }
    })
    .catch(err => {
        if (btn) {
            btn.disabled = false;
            btn.innerHTML = '<i class="fa-solid fa-hourglass-half"></i> 1시간 연장하기';
        }
        console.error('Token extension error:', err);
        showExtendTokenError('토큰 연장 요청 중 오류가 발생했습니다.');
    });
}

// Window resize listener to automatically redraw Tabulator instances and update sidebar menu mode
window.addEventListener('resize', function() {
    if (typeof checkHeaderCollision === 'function') {
        checkHeaderCollision();
    }

    if (typeof Tabulator !== 'undefined') {
        Tabulator.findTable(".tabulator").forEach(table => {
            try { table.redraw(true); } catch(e) {}
        });
    }
});

/**
 * Global Cookie Getter Helper
 */
function getCookie(name) {
    if (!document.cookie) return null;
    const cookies = document.cookie.split(';');
    for (let i = 0; i < cookies.length; i++) {
        const c = cookies[i].trim();
        if (c.startsWith(name + '=')) {
            return decodeURIComponent(c.substring(name.length + 1));
        }
    }
    return null;
}

/**
 * Global Common WorkDate Helper (공통 기준 작업일자 조회)
 * - 쿠키의 workDate가 존재하고 대상 회사가 기본 회사와 일치하면 즉시 캐시값 활용 가능
 * - 회사그룹이 변경되었거나 최신 일자가 필요하면 /api/common/workdate API 호출
 */
function fetchCommonWorkDate(corpGr, callback) {
    var url = '/api/common/workdate' + (corpGr ? ('?corpGr=' + encodeURIComponent(corpGr)) : '');
    return fetch(url)
        .then(function(res) { return res.json(); })
        .then(function(data) {
            var date = (data && data.workDate) ? data.workDate : null;
            if (typeof callback === 'function') callback(date);
            return date;
        })
        .catch(function(err) {
            console.warn('[common] fetchCommonWorkDate error:', err);
            if (typeof callback === 'function') callback(null);
            return null;
        });
}

/**
 * Global Common Breadcrumb Builder Helper
 */
function buildBreadcrumbText(fullpgm2, title, pgmId) {
    return formatBreadcrumb(fullpgm2, title, pgmId);
}

/**
 * Dynamic DDDW Dropdown Options Loader Helper (Delegated to f_dddwctl.js)
 */
function loadDddwOptions(selectId, dddwId, seq, addWhere, addOrderBy, defaultVal) {
    if (typeof window.f_dddwctl === 'function' && typeof window.f_dddwctl.loadOptions === 'function') {
        return window.f_dddwctl.loadOptions(selectId, dddwId, seq, addWhere, addOrderBy, defaultVal);
    }
}

/**
 * Tabulator Grid Row Selection & Change Synchronization Engine (AAMS Standard)
 * 
 * [Solves 4 Core Interaction Issues]
 * 1. Non-editable cells (No., readonly) not triggering row change
 * 2. Editable cell -> other row's editable cell not changing selected row (due to stopPropagation in editors)
 * 3. Dropdown list (list/dddw) editor opening without row selection
 * 4. Keyboard Tab navigation between rows not synchronizing selected row
 * 
 * @param {Tabulator} table Tabulator grid instance
 * @param {Function} [onRowChange] Callback function (row, data) when selected row changes
 * @param {Object} [options] Options: { keyField: string, autoSelectFirst: boolean }
 */
function setupTabulatorRowSelection(table, onRowChange, options = {}) {
    if (!table) return null;

    // Register onRowChange callback if provided
    if (typeof onRowChange === 'function') {
        table._aamsRowChangeCallback = onRowChange;
    }

    // Prevent duplicate listener attachment
    if (table._aamsRowSelectionInitialized) {
        return table._aamsRowSelectionHelper;
    }
    table._aamsRowSelectionInitialized = true;

    // Use pure RowComponent instance comparison to reliably identify row changes across all screens
    let lastSelectedRow = null;

    // 헬퍼: 행 포커스 및 스크롤 이동
    function focusRow(targetRow) {
        if (!targetRow) return;
        if (typeof targetRow.scrollTo === 'function') {
            try { targetRow.scrollTo("nearest"); } catch(e) {}
        }
        const rowEl = (typeof targetRow.getElement === 'function') ? targetRow.getElement() : null;
        if (rowEl) {
            if (!rowEl.hasAttribute('tabindex')) {
                rowEl.setAttribute('tabindex', '-1');
            }
            try { rowEl.focus({ preventScroll: true }); } catch(e) {}
        }
    }

    // 헬퍼: 현재 화면/탭에 reportViewer가 존재하는지 판별
    function detectHasReportViewer() {
        if (typeof options.hasReportViewer === 'boolean') {
            return options.hasReportViewer;
        }
        const el = table.element;
        if (!el) return false;
        const pane = el.closest('.tab-pane') || el.closest('.view-container') || el.closest('body');
        if (!pane) return false;

        if (pane._aamsReportViewer || pane._reportViewer) return true;

        const reportEl = pane.querySelector(
            '.report-card, .report-viewer, .report-viewer-card, .report-viewer-pane, iframe.report-frame, #report-frame, .export-button-group, .report-modal-backdrop, [id*="MobileModal"], [id*="mobileModal"]'
        );
        return !!reportEl;
    }

    function doSelect(row, force = false, originalEvent = null) {
        if (!row) return;
        let rowComp = row;
        // If row is an internal Row model (not RowComponent), obtain its RowComponent
        // Note: Do NOT access row.getComponent on RowComponent because Tabulator proxy emits a warning:
        // "The row component does not have a getComponent function"
        if (row && typeof row.getData !== 'function') {
            if (typeof row.getComponent === 'function') {
                try {
                    rowComp = row.getComponent();
                } catch (e) {
                    rowComp = row;
                }
            }
        }
        const isRowChanged = (rowComp !== lastSelectedRow) || force;
        const isSelected = (typeof rowComp.isSelected === 'function' && rowComp.isSelected());

        // 1. Ensure single row selection without flickering
        const isSingleSelect = (table.options.selectableRows === 1 || table.options.selectable === 1);
        if (isSingleSelect) {
            const currentSelected = (typeof table.getSelectedRows === 'function') ? table.getSelectedRows() : [];
            currentSelected.forEach(r => {
                if (r !== rowComp && typeof r.deselect === 'function') {
                    r.deselect();
                }
            });
        }
        if (!isSelected) {
            if (isSingleSelect && typeof table.deselectRow === 'function') {
                table.deselectRow();
            }
            if (typeof rowComp.select === 'function') {
                rowComp.select();
            }
        }

        // 2. Trigger callbacks & rowClick synchronization when row actually changed or forced
        if (isRowChanged) {
            lastSelectedRow = rowComp;
            const d = (typeof rowComp.getData === 'function') ? rowComp.getData() : {};

            // ① Custom onRowChange callback
            if (typeof table._aamsRowChangeCallback === 'function') {
                try {
                    table._aamsRowChangeCallback(rowComp, d);
                } catch(err) {
                    console.error("[AAMS RowSelection] Error in onRowChange callback:", err);
                }
            }

            // ② Dispatch external rowClick event to trigger view's grid.on("rowClick", ...) handler
            // (Guarantees execution even when cell editor / dropdown stopPropagation blocked standard click)
            if (table.externalEvents && typeof table.externalEvents.dispatch === 'function') {
                table._aamsLastDispatchedRow = rowComp;
                table._aamsLastDispatchedTime = Date.now();
                try {
                    table.externalEvents.dispatch("rowClick", originalEvent || new MouseEvent('click'), rowComp);
                } catch(err) {
                    console.error("[AAMS RowSelection] Error dispatching rowClick:", err);
                }
            }
        }
    }

    // Ensure arrow keys do not change row selection
    if (table.options) {
        table.options.selectableRowsRollingSelection = false;
    }

    function initListeners() {
        const container = table.element;
        if (!container || !container.addEventListener) return;

        // 1. Gesture-Aware Pointer/Touch/Click Listener & Scroll Suppression
        // 모바일/태블릿 등 터치 환경에서 스크롤을 내릴 때 행이 멋대로 변경되는 문제를 원천 차단합니다.
        let pointerStartX = 0;
        let pointerStartY = 0;
        let pointerMoved = false;
        let pendingPointerRow = null;
        let lastScrollTime = 0;

        function markScroll() {
            lastScrollTime = Date.now();
            pointerMoved = true;
            pendingPointerRow = null;
        }

        // Tabulator 내부 스크롤 컨테이너(.tabulator-tableholder) 감지
        const tableHolder = container.querySelector(".tabulator-tableholder") || container;
        tableHolder.addEventListener("scroll", markScroll, { passive: true });
        window.addEventListener("scroll", markScroll, { passive: true });

        function findRowFromEvent(e) {
            if (!e || !e.target) return null;
            if (e.target.closest(".tabulator-header") || 
                e.target.closest(".tabulator-footer") || 
                e.target.closest(".tabulator-col-resize-handle") ||
                e.target.closest(".tabulator-arrow") ||
                e.target.closest(".tabulator-cell-handle")) {
                return null;
            }
            const rowEl = e.target.closest(".tabulator-row");
            if (!rowEl) return null;

            let targetRow = null;
            if (typeof table.getRow === 'function') {
                try { targetRow = table.getRow(rowEl); } catch(err) {}
            }
            if (!targetRow) {
                const rows = table.getRows();
                if (rows && rows.length > 0) {
                    targetRow = rows.find(r => r.getElement() === rowEl);
                }
            }
            return targetRow;
        }

        const handlePointerDown = function(e) {
            if (Date.now() - lastScrollTime < 300) {
                pendingPointerRow = null;
                return;
            }
            const targetRow = findRowFromEvent(e);
            if (!targetRow) {
                pendingPointerRow = null;
                return;
            }
            pointerStartX = e.clientX != null ? e.clientX : (e.touches && e.touches[0] ? e.touches[0].clientX : 0);
            pointerStartY = e.clientY != null ? e.clientY : (e.touches && e.touches[0] ? e.touches[0].clientY : 0);
            pointerMoved = false;
            pendingPointerRow = targetRow;
        };

        const handlePointerMove = function(e) {
            if (!pendingPointerRow || pointerMoved) return;
            const currentX = e.clientX != null ? e.clientX : (e.touches && e.touches[0] ? e.touches[0].clientX : 0);
            const currentY = e.clientY != null ? e.clientY : (e.touches && e.touches[0] ? e.touches[0].clientY : 0);
            const dist = Math.hypot(currentX - pointerStartX, currentY - pointerStartY);
            // 12px 이상 이동 시 스크롤/드래그 제스처로 판정하여 행 선택 변경 즉시 취소
            if (dist > 12) {
                pointerMoved = true;
                pendingPointerRow = null;
                lastScrollTime = Date.now();
            }
        };

        const handlePointerUp = function(e) {
            if (Date.now() - lastScrollTime < 350 || pointerMoved) {
                pendingPointerRow = null;
                return;
            }
            if (pendingPointerRow) {
                const target = pendingPointerRow;
                pendingPointerRow = null;
                doSelect(target, false, e);
            } else {
                pendingPointerRow = null;
            }
        };

        const handlePointerCancel = function() {
            pointerMoved = true;
            pendingPointerRow = null;
            lastScrollTime = Date.now();
        };

        // PointerEvent 지원 브라우저에서는 pointer 이벤트만 바인딩 (이중 실행 방지)
        const hasPointer = !!window.PointerEvent;
        if (hasPointer) {
            container.addEventListener("pointerdown", handlePointerDown, { capture: true, passive: true });
            container.addEventListener("pointermove", handlePointerMove, { capture: true, passive: true });
            container.addEventListener("pointerup", handlePointerUp, { capture: true, passive: true });
            container.addEventListener("pointercancel", handlePointerCancel, { capture: true, passive: true });
        } else {
            // 구형 기기 터치/마우스 fallback
            container.addEventListener("touchstart", handlePointerDown, { capture: true, passive: true });
            container.addEventListener("touchmove", handlePointerMove, { capture: true, passive: true });
            container.addEventListener("touchend", handlePointerUp, { capture: true, passive: true });
            container.addEventListener("touchcancel", handlePointerCancel, { capture: true, passive: true });
            container.addEventListener("mousedown", handlePointerDown, { capture: true, passive: true });
            container.addEventListener("mouseup", handlePointerUp, { capture: true, passive: true });
        }

        // 캡처링 단계의 click 리스너: 스크롤 제스처 후 발생하는 합성(Synthetic) 유령 클릭 완전 소멸
        container.addEventListener("click", function(e) {
            if (Date.now() - lastScrollTime < 400 || pointerMoved) {
                pointerMoved = false;
                e.stopImmediatePropagation();
                e.stopPropagation();
                e.preventDefault();
                return;
            }
            const targetRow = findRowFromEvent(e);
            if (targetRow) {
                doSelect(targetRow, false, e);
            }
        }, true);

        // 2. cellEditing Hook: For keyboard Tab navigation into another row's editor
        table.on("cellEditing", function(cell) {
            if (cell && typeof cell.getRow === 'function') {
                const r = cell.getRow();
                if (r) doSelect(r);
            }
        });

        // 3. Tabulator standard rowClick fallback (avoids duplicate execution while guaranteeing selection)
        table.on("rowClick", function(e, row) {
            if (Date.now() - lastScrollTime < 400) {
                return;
            }
            // Even if callback was dispatched recently via pointerdown capture,
            // ensure the row remains visually selected in case Tabulator's native click handler deselected it.
            if (row && typeof row.isSelected === 'function' && !row.isSelected()) {
                if (typeof table.deselectRow === 'function') table.deselectRow();
                if (typeof row.select === 'function') row.select();
            }

            if (table._aamsLastDispatchedRow === row && Date.now() - (table._aamsLastDispatchedTime || 0) < 200) {
                return;
            }
            if (row) doSelect(row, false, e);
        });

        // 4. Reset lastSelectedRow and auto select first row on data load
        // [AAMS 표준 rowfocus 2대 정책]
        // 1. reportViewer가 있는 경우:
        //    1-1. 모바일 환경(<= 876px): 어디든 rowfocus를 강제하지 않음 (모달 팝업 자동 오픈 방지)
        //    1-2. PC/태블릿 환경(> 876px): 조회 또는 새로고침 시 모든 그리드는 첫 번째 행 rowfocus
        // 2. reportViewer가 없는 경우:
        //    - PC, 태블릿, 모바일 모든 환경에서 조회 또는 새로고침 시 모든 그리드는 첫 번째 행 rowfocus
        table.on("dataLoaded", function(data) {
            lastSelectedRow = null;
            const isMobile = window.matchMedia('(max-width: 876px)').matches 
                || window.innerWidth <= 876 
                || (table.element && table.element.clientWidth > 0 && table.element.clientWidth <= 876);

            const hasReport = detectHasReportViewer();
            const shouldAutoFocus = hasReport ? !isMobile : true;

            if (options.autoSelectFirst !== false && shouldAutoFocus) {
                if (Array.isArray(data) && data.length > 0) {
                    setTimeout(() => {
                        const rows = table.getRows();
                        if (rows && rows.length > 0) {
                            doSelect(rows[0], true);
                            focusRow(rows[0]);
                        }
                    }, 60);
                }
            } else if (hasReport && isMobile) {
                // reportViewer가 있는 화면의 모바일 환경: 조회 후 첫 번째 행으로 focus/select 자동 이동 방지
                setTimeout(() => {
                    if (typeof table.deselectRow === 'function') {
                        table.deselectRow();
                    }
                }, 50);
            }

            // 5. 마스터 그리드 조회 완료 시 버튼 상태 동기화 (조회 버튼 비활성화, 나머지 권한 보유 버튼 활성화)
            if (options.isMaster !== false) {
                // 초기 그리드 생성(빈 배열) 시의 오작동 방지: 실제 데이터가 1건 이상 로드된 경우에만 동기화
                if (Array.isArray(data) && data.length > 0) {
                    const pane = table.element ? (table.element.closest('.tab-pane') || table.element.closest('.view-container')) : null;
                    if (pane && window.ButtonRole && typeof window.ButtonRole.setSearchState === 'function') {
                        if (pane._isClearingTabulator !== true) {
                            window.ButtonRole.setSearchState(pane, true);
                        }
                    }
                }
            }
        });
    }

    if (table.element) {
        initListeners();
    } else {
        table.on("tableBuilt", initListeners);
    }

    table._aamsRowSelectionHelper = {
        selectRow: doSelect,
        focusRow: focusRow,
        focusFirstRow: function() {
            const rows = table.getRows();
            if (rows && rows.length > 0) {
                doSelect(rows[0]);
                focusRow(rows[0]);
            }
        },
        resetRow: function() { 
            lastSelectedRow = null; 
            if (typeof table.deselectRow === 'function') table.deselectRow();
        },
        getLastSelectedRow: function() { return lastSelectedRow; },
        hasReportViewer: function() { return detectHasReportViewer(); }
    };

    return table._aamsRowSelectionHelper;
}

/**
 * Safe Cell Edit Invoker: Ensures row selection before opening cell editor
 * Can be directly assigned to column's cellClick handler:
 * { ... cellClick: aamsCellEdit }
 */
function aamsCellEdit(e, cell) {
    if (!cell) return;
    try {
        const row = cell.getRow();
        if (row && typeof row.select === 'function' && !row.isSelected()) {
            const table = cell.getTable();
            if (table && typeof table.deselectRow === 'function') {
                table.deselectRow();
            }
            row.select();
        }
    } catch(err) {}
    if (typeof cell.edit === 'function') {
        cell.edit(true);
    }
}

/**
 * AAMS Global Tabulator Row Selection Auto-Patch
 * Automatically wraps window.Tabulator so that ALL grids in ALL screens
 * inherit the capturing row selection engine without requiring manual setup.
 */
(function initAamsGlobalTabulator() {
    if (typeof window === 'undefined') return;

    function processColumnsHeaderCss(columns) {
        if (!Array.isArray(columns)) return;
        columns.forEach(col => {
            if (!col) return;
            if (col.headerCssClass) {
                const current = col.cssClass || '';
                const classes = current.split(' ').filter(Boolean);
                col.headerCssClass.split(' ').filter(Boolean).forEach(cls => {
                    if (!classes.includes(cls)) {
                        classes.push(cls);
                    }
                });
                col.cssClass = classes.join(' ');
                // Tabulator v6 유효성 검사 에러(Invalid column definition option: headerCssClass) 방지
                delete col.headerCssClass;
            }
            if (col.columns && Array.isArray(col.columns)) {
                processColumnsHeaderCss(col.columns);
            }
        });
    }

    function applyPatch() {
        if (!window.Tabulator || window.Tabulator._isAamsPatched) return;

        const OriginalTabulator = window.Tabulator;

        function AamsTabulator(container, options = {}) {
            // Convert headerCssClass to cssClass and delete headerCssClass before passing to Tabulator
            if (options && options.columns) {
                processColumnsHeaderCss(options.columns);
            }

            // Ensure default columnDefaults.vertAlign = "middle" so Tabulator natively injects justifyContent based on hozAlign
            if (!options.columnDefaults) {
                options.columnDefaults = {};
            }
            if (!options.columnDefaults.vertAlign) {
                options.columnDefaults.vertAlign = "middle";
            }

            // When single row selection is configured, enable rolling selection to prevent deselecting on click
            if ((options.selectableRows === 1 || options.selectable === 1) && options.selectableRowsRollingSelection === undefined) {
                options.selectableRowsRollingSelection = true;
            }

            // Instantiate original Tabulator
            const table = new OriginalTabulator(container, options);

            // Hook dynamic column APIs to process headerCssClass
            const origSetColumns = table.setColumns;
            table.setColumns = function(cols) {
                if (cols) processColumnsHeaderCss(cols);
                return origSetColumns.apply(table, arguments);
            };
            const origAddColumn = table.addColumn;
            table.addColumn = function(col, before, toColumn) {
                if (col) processColumnsHeaderCss([col]);
                return origAddColumn.apply(table, arguments);
            };

            // Automatically attach row selection engine if selectable is enabled (default in AAMS)
            const isSelectable = (options.selectableRows !== false && options.selectable !== false);
            if (isSelectable) {
                setupTabulatorRowSelection(table, null, options);
            }

            return table;
        }

        // Set Tabulator global defaultOptions if available
        if (OriginalTabulator.defaultOptions) {
            if (!OriginalTabulator.defaultOptions.columnDefaults) {
                OriginalTabulator.defaultOptions.columnDefaults = {};
            }
            OriginalTabulator.defaultOptions.columnDefaults.vertAlign = "middle";
        }

        // Preserve prototype chain and all static methods/properties (e.g. Tabulator.findTable)
        AamsTabulator.prototype = OriginalTabulator.prototype;
        Object.setPrototypeOf(AamsTabulator, OriginalTabulator);
        Object.assign(AamsTabulator, OriginalTabulator);
        AamsTabulator._isAamsPatched = true;

        window.Tabulator = AamsTabulator;
    }

    if (window.Tabulator) {
        applyPatch();
    } else {
        document.addEventListener("DOMContentLoaded", applyPatch);
    }
})();

/**
 * AAMS Report Viewer 공통 유틸리티
 * 파워빌더 u_rd.sru의 ii_zoomRatio = 120 표준 규격 반영
 */
window.AamsReport = {
    DEFAULT_ZOOM: 120,

    /**
     * 가변 파라미터 기반 범용 RD 리포트 미리보기 URL 생성
     * @param {string} mrdName - 대상 MRD 파일명 (예: "rd_ja010q.mrd")
     * @param {Object} [params] - 가변 Key-Value 파라미터 객체 { fund_cd: '...', ymd: '...' }
     * @param {Object} [options] - 옵션 { corpGr, downloadName, zoom, timestamp: true }
     * @returns {string} 완성된 미리보기 URL (120% 줌 해시 포함)
     */
    buildPreviewUrl: function(mrdName, params, options) {
        options = options || {};
        var qs = ['mrdName=' + encodeURIComponent(mrdName)];
        if (options.corpGr) qs.push('corpGr=' + encodeURIComponent(options.corpGr));
        if (options.downloadName) qs.push('downloadName=' + encodeURIComponent(options.downloadName));
        if (options.timestamp !== false) qs.push('t=' + new Date().getTime());

        if (params && typeof params === 'object') {
            for (var k in params) {
                if (params.hasOwnProperty(k) && params[k] !== undefined && params[k] !== null) {
                    qs.push(encodeURIComponent(k) + '=' + encodeURIComponent(params[k]));
                }
            }
        }

        var rawUrl = '/api/common/rd/preview?' + qs.join('&');
        return this.formatPreviewUrl(rawUrl, options.zoom);
    },

    /**
     * 가변 파라미터 기반 범용 RD 리포트 파일 내보내기/다운로드 URL 생성
     * @param {string} mrdName - 대상 MRD 파일명 (예: "rd_ja010q.mrd")
     * @param {Object} [params] - 가변 Key-Value 파라미터 객체
     * @param {string} [format] - 포맷 (pdf, excel/xlsx, word/doc, ppt/pptx, hwp)
     * @param {Object} [options] - 옵션 { corpGr, downloadName }
     * @returns {string} 완성된 다운로드 URL
     */
    buildExportUrl: function(mrdName, params, format, options) {
        options = options || {};
        var qs = ['mrdName=' + encodeURIComponent(mrdName)];
        qs.push('format=' + encodeURIComponent(format || 'pdf'));
        if (options.corpGr) qs.push('corpGr=' + encodeURIComponent(options.corpGr));
        if (options.downloadName) qs.push('downloadName=' + encodeURIComponent(options.downloadName));
        qs.push('t=' + new Date().getTime());

        if (params && typeof params === 'object') {
            for (var k in params) {
                if (params.hasOwnProperty(k) && params[k] !== undefined && params[k] !== null) {
                    qs.push(encodeURIComponent(k) + '=' + encodeURIComponent(params[k]));
                }
            }
        }

        return '/api/common/rd/export?' + qs.join('&');
    },

    /**
     * 리포트 미리보기 URL에 표준 PDF 파라미터(기본 zoom=120, toolbar, navpanes)를 부착
     * @param {string} url - 원본 리포트 URL
     * @param {number|string} [zoom] - 지정 확대 배율 (기본값: DEFAULT_ZOOM = 120)
     * @returns {string} 해시 파라미터가 포함된 최종 뷰어 URL
     */
    formatPreviewUrl: function(url, zoom) {
        if (!url || url === 'about:blank') return url || '';
        var cleanUrl = url.split('#')[0];
        if (zoom === 'fit' || zoom === 'page-fit' || zoom === 'Fit') {
            return cleanUrl + '#toolbar=1&navpanes=0&view=Fit';
        }
        if (zoom === 'width' || zoom === 'page-width' || zoom === 'FitH') {
            return cleanUrl + '#toolbar=1&navpanes=0&view=FitH';
        }
        var targetZoom = (zoom !== undefined && zoom !== null) ? zoom : this.DEFAULT_ZOOM;
        return cleanUrl + '#toolbar=1&navpanes=0&zoom=' + encodeURIComponent(targetZoom);
    },

    /**
     * 대상 iframe에 리포트 URL 설정 (기본 zoom=120 적용)
     */
    setFrameSrc: function(frameEl, url, zoom) {
        if (!frameEl) return;
        if (!url || url === 'about:blank') {
            frameEl.src = 'about:blank';
            return;
        }
        frameEl.src = this.formatPreviewUrl(url, zoom);
    },

    /**
     * 표준 리포트 뷰어 & 내보내기 & 모바일 모달 일체형 자동 바인딩 엔진
     * @param {HTMLElement} rootPane - 화면의 탭 컨텍스트 엘리먼트 (currentPane / pane)
     * @param {Object} config - 설정 옵션
     */
    bindViewer: function(rootPane, config) {
        config = config || {};
        var root = rootPane || document;
        var iframe = root.querySelector(config.iframeSelector || '#report-frame, .report-frame');
        var loadingEl = root.querySelector(config.loadingSelector || '#preview-loading, .report-loading');
        var statusEl = root.querySelector(config.statusSelector || '#preview-status, .preview-status');
        var modalEl = root.querySelector(config.modalSelector || (config.modalId ? ('#' + config.modalId) : null) || '.report-modal-backdrop')
                   || document.querySelector(config.modalSelector || (config.modalId ? ('#' + config.modalId) : null) || '.report-modal-backdrop');
        var modalIframe = modalEl ? modalEl.querySelector('iframe') : null;
        var modalLoadingEl = modalEl ? modalEl.querySelector('.report-loading, [id*="loading"]') : null;
        var modalTitleEl = modalEl ? modalEl.querySelector('.modal-title, .report-modal-title') : null;
        var btnOpenNewWindow = root.querySelector('#btnOpenNewWindow, .btn-open-new-window');
        var btnCloseModal = modalEl ? modalEl.querySelector('.btn-close-modal, .btn-close-report-modal, [id*="Close"]') : null;
        
        var selectedData = null;

        function resolveMrd(data) {
            if (typeof config.mrdName === 'function') return config.mrdName(data);
            if (config.mrdName) return config.mrdName;
            if (typeof config.reportFile === 'function') return config.reportFile(data);
            return config.reportFile || '';
        }

        function resolveParams(data) {
            if (typeof config.getParams === 'function') return config.getParams(data);
            if (typeof config.buildParams === 'function') return config.buildParams(data);
            return data || {};
        }

        function resolveCorp() {
            if (typeof config.getCorpGr === 'function') return config.getCorpGr();
            if (typeof resolveCorpGr === 'function') return resolveCorpGr(root);
            return '';
        }

        function showLoading(show) {
            if (loadingEl) loadingEl.style.display = show ? 'block' : 'none';
            if (modalLoadingEl) modalLoadingEl.style.display = show ? 'block' : 'none';
        }

        function updateStatus(text) {
            if (statusEl) statusEl.textContent = text || '';
            if (typeof config.onStatusChange === 'function') config.onStatusChange(selectedData, text);
        }

        function load(data, statusText) {
            if (!data) return;
            selectedData = data;
            if (typeof config.onBeforePreview === 'function') {
                config.onBeforePreview(data);
            }
            if (statusText) {
                updateStatus(statusText);
            } else if (typeof config.getStatus === 'function') {
                updateStatus(config.getStatus(data, resolveParams(data)));
            }
            if (typeof config.getTitle === 'function') {
                var titleEl = root.querySelector('#preview-header-title, .preview-header-title');
                if (titleEl) {
                    var titleVal = config.getTitle(data);
                    var iconClass = config.iconClass || 'fa-solid fa-file-invoice';
                    titleEl.innerHTML = '<i class="' + iconClass + '" style="margin-right: 4px;"></i> ' + titleVal;
                }
            }
            var mrd = resolveMrd(data);
            var params = resolveParams(data);
            var previewUrl = (typeof config.buildPreviewUrl === 'function')
                ? config.buildPreviewUrl(data, params)
                : (mrd ? AamsReport.buildPreviewUrl(mrd, params, { corpGr: resolveCorp(), zoom: config.zoom }) : null);
            if (!previewUrl) return;
            
            showLoading(true);
            if (iframe) {
                iframe.onload = function() { showLoading(false); };
                AamsReport.setFrameSrc(iframe, previewUrl, config.zoom);
            }
            if (modalIframe && modalEl && modalEl.style.display !== 'none') {
                modalIframe.onload = function() { showLoading(false); };
                AamsReport.setFrameSrc(modalIframe, previewUrl, config.zoom);
            }
        }

        function clear() {
            selectedData = null;
            updateStatus(config.defaultStatus || '선택된 항목 없음');
            if (iframe) AamsReport.setFrameSrc(iframe, 'about:blank');
            if (modalIframe) AamsReport.setFrameSrc(modalIframe, 'about:blank');
            showLoading(false);
        }

        function exportReport(format) {
            if (!selectedData) {
                if (typeof showToast === 'function') showToast('내보낼 항목을 먼저 선택해주세요.', 'warning');
                else alert('내보낼 항목을 먼저 선택해주세요.');
                return;
            }
            if (typeof config.beforeAction === 'function' && config.beforeAction(selectedData, 'export') === false) return;
            var mrd = resolveMrd(selectedData);
            var params = resolveParams(selectedData);
            var dlName = typeof config.getDownloadName === 'function' ? config.getDownloadName(selectedData, format) : null;
            var url = (typeof config.buildExportUrl === 'function')
                ? config.buildExportUrl(selectedData, format, params)
                : AamsReport.buildExportUrl(mrd, params, format, {
                    corpGr: resolveCorp(),
                    downloadName: dlName
                });
            if (url) window.location.href = url;
        }

        function openNewWindow() {
            if (!selectedData) {
                if (typeof showToast === 'function') showToast('조회할 항목을 먼저 선택해주세요.', 'warning');
                else alert('조회할 항목을 먼저 선택해주세요.');
                return;
            }
            if (typeof config.beforeAction === 'function' && config.beforeAction(selectedData, 'newWindow') === false) return;
            var mrd = resolveMrd(selectedData);
            var params = resolveParams(selectedData);
            var url = (typeof config.buildPreviewUrl === 'function')
                ? config.buildPreviewUrl(selectedData, params)
                : AamsReport.buildPreviewUrl(mrd, params, { corpGr: resolveCorp(), zoom: config.zoom });
            if (url) window.open(url, '_blank');
        }

        function openModal(data, title) {
            if (!modalEl) {
                modalEl = root.querySelector(config.modalSelector || (config.modalId ? ('#' + config.modalId) : null) || '.report-modal-backdrop')
                       || document.querySelector(config.modalSelector || (config.modalId ? ('#' + config.modalId) : null) || '.report-modal-backdrop');
            }
            if (!modalEl) return;
            selectedData = data || selectedData;
            if (!title && typeof config.getTitle === 'function' && selectedData) {
                title = config.getTitle(selectedData);
            }
            if (modalTitleEl && title) modalTitleEl.textContent = title;
            modalEl.style.display = 'flex';
            if (!modalIframe) modalIframe = modalEl.querySelector('iframe');
            if (modalIframe && selectedData) {
                var mrd = resolveMrd(selectedData);
                var params = resolveParams(selectedData);
                var url = (typeof config.buildPreviewUrl === 'function')
                    ? config.buildPreviewUrl(selectedData, params)
                    : AamsReport.buildPreviewUrl(mrd, params, { corpGr: resolveCorp(), zoom: config.zoom });
                showLoading(true);
                modalIframe.onload = function() { showLoading(false); };
                AamsReport.setFrameSrc(modalIframe, url, config.zoom);
            }
        }

        function closeModal() {
            if (modalEl) modalEl.style.display = 'none';
            if (modalIframe) AamsReport.setFrameSrc(modalIframe, 'about:blank');
        }

        // Export buttons binding
        var exportBtns = root.querySelectorAll('.btn-export-format, .export-btn, [data-format]');
        exportBtns.forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                var fmt = btn.getAttribute('data-format');
                if (fmt) exportReport(fmt);
            });
        });

        // New window button
        if (btnOpenNewWindow) {
            btnOpenNewWindow.addEventListener('click', function(e) {
                e.preventDefault();
                openNewWindow();
            });
        }

        // Modal close button & backdrop
        if (btnCloseModal) {
            btnCloseModal.addEventListener('click', closeModal);
        }
        if (modalEl) {
            setupModalBackdrop(modalEl, closeModal);
        }

        return {
            load: load,
            loadPreview: load,
            clear: clear,
            openModal: openModal,
            openMobile: openModal,
            closeModal: closeModal,
            closeMobile: closeModal,
            openNewWindow: openNewWindow,
            exportReport: exportReport,
            exportFormat: exportReport,
            getSelectedData: function() { return selectedData; },
            setSelectedData: function(d) { selectedData = d; }
        };
    }
};

