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
/**
 * Safe Resolution for Current corpGr / filterCorpGr
 * 1. 현재 화면/탭 pane 내 필터에 corpGr 관련 dddw/선택 요소(#filterCorpGr, select[name='corpGr'])가 직접 존재하는 경우:
 *    -> 해당 화면 필터의 선택값을 최우선으로 반환
 * 2. 현재 화면/탭 pane 내 필터에 corpGr 관련 dddw가 없는 경우 (예: w_ja010f 등):
 *    -> 다른 화면에서 바꾼 쿠키(savedCorpGr)나 전역 상태로 오염되지 않도록,
 *       "엑세스 토큰에 저장된 로그인 사용자의 corpGr"을 최우선으로 반환!
 *       (window.tokenCorpGr, meta[name='token-corp-gr'], userCorpGr 불변 쿠키)
 */
function resolveCorpGr(pane) {
    if (!pane && window.currentPane) pane = window.currentPane;

    // 1. 현재 화면/탭 pane의 필터 영역에 corpGr 관련 dddw/선택 요소가 직접 존재하는지 확인
    const paneSelectEl = pane ? (pane.querySelector("#filterCorpGr") || pane.querySelector("select[name='corpGr']")) : null;
    if (paneSelectEl && paneSelectEl.value && String(paneSelectEl.value).trim()) {
        return String(paneSelectEl.value).trim();
    }

    // 2. filter에 corpGr 관련 dddw가 없는 경우 -> 엑세스토큰에 저장된 corpGr을 최우선 반환
    // 2-1) MDI 메인 프레임워크 전역 변수 (UserPrincipal에서 추출 주입)
    if (window.tokenCorpGr && String(window.tokenCorpGr).trim()) {
        return String(window.tokenCorpGr).trim();
    }
    // 2-2) 메타 태그 (w_home5.html)
    const metaTokenEl = document.querySelector('meta[name="token-corp-gr"]');
    if (metaTokenEl && metaTokenEl.content && String(metaTokenEl.content).trim()) {
        return String(metaTokenEl.content).trim();
    }
    // 2-3) 불변 사용자 소속 토큰 쿠키 (userCorpGr)
    const mUser = document.cookie.match(/(?:^|;\s*)userCorpGr=([^;]*)/);
    if (mUser && mUser[1]) {
        const val = decodeURIComponent(mUser[1]).trim();
        if (val) return val;
    }
    // 2-4) 현재 화면/탭 pane에 서버가 주입한 data-token-corp-gr 속성
    if (pane && typeof pane.getAttribute === 'function') {
        const paneTokenCorp = pane.getAttribute('data-token-corp-gr');
        if (paneTokenCorp && paneTokenCorp.trim()) return paneTokenCorp.trim();
    }

    // 3. 글로벌 상단 헤더 셀렉트박스(#corpGrSelect) 확인 (전사 관리자 모달 등)
    const globalCorpEl = document.getElementById("corpGrSelect");
    if (globalCorpEl && globalCorpEl.value && String(globalCorpEl.value).trim()) {
        return String(globalCorpEl.value).trim();
    }

    // 4. 최후의 폴백 (비로그인 환경 등)
    if (window.currentCorpGr && String(window.currentCorpGr).trim()) return String(window.currentCorpGr).trim();
    if (typeof g_corp_gr !== 'undefined' && g_corp_gr && String(g_corp_gr).trim()) return String(g_corp_gr).trim();

    const m = document.cookie.match(/(?:^|;\s*)savedCorpGr=([^;]*)/) 
           || document.cookie.match(/(?:^|;\s*)corpGr=([^;]*)/);
    if (m && m[1]) return decodeURIComponent(m[1]).trim();

    return "";
}
window.resolveCorpGr = resolveCorpGr;
window.getFilterCorpGr = resolveCorpGr;

/**
 * Safe Resolution for Current Filter Date (filterYmd)
 * 화면 상단 필터바의 기준일자(filterYmd 또는 ymd input)를 추출하여 지정한 포맷으로 안전하게 반환합니다.
 * 
 * @param {HTMLElement|string} [pane] - 현재 화면/탭 컨테이너 요소 (생략 시 document 전체에서 탐색, 포맷 문자열일 경우 format으로 간주)
 * @param {string} [format='YYYY-MM-DD'] - 반환 포맷:
 *      'YYYY-MM-DD' (기본값: "2026-10-06")
 *      'YYYYMMDD'   (숫자만 8자리: "20261006")
 *      'YYYY.MM.DD' (점 구분자: "2026.10.06")
 * @returns {string} 포맷팅된 날짜 문자열
 * 
 * 사용 예:
 *   resolveFilterYmd(pane)               // "2026-10-06" (기본 yyyy-MM-dd)
 *   resolveFilterYmd(pane, 'YYYYMMDD')   // "20261006"
 *   resolveFilterYmd(pane, 'YYYY.MM.DD') // "2026.10.06"
 *   getFilterYmd(pane)                   // resolveFilterYmd 별칭
 *   getFilterYmd('YYYYMMDD')             // pane 생략 축약 호출
 *   getFilterYmd()                       // 기본 오늘/선택일자 "2026-10-06"
 */
function resolveFilterYmd(pane, format) {
    let targetFormat = format;
    let targetPane = pane;

    if (typeof pane === 'string' && !format) {
        var upper = pane.toUpperCase();
        if (upper === 'YYYY-MM-DD' || upper === 'YYYYMMDD' || upper === 'YYYY.MM.DD' || upper === 'RAW') {
            targetFormat = upper;
            targetPane = null;
        }
    }
    if (!targetFormat) targetFormat = 'YYYY-MM-DD';
    targetFormat = targetFormat.toUpperCase();

    const root = (targetPane && typeof targetPane.querySelector === 'function') ? targetPane : document;
    const input = root.querySelector('#filterYmd')
               || root.querySelector('input[name="ymd"]')
               || root.querySelector('.aams-calendar-input');

    let rawVal = '';
    if (input && input.value) {
        rawVal = String(input.value).trim();
    } else if (input && input.getAttribute('value')) {
        rawVal = String(input.getAttribute('value')).trim();
    }

    if (!rawVal) {
        if (window.currentWorkDate) {
            rawVal = String(window.currentWorkDate).trim();
        } else {
            const today = new Date();
            const y = today.getFullYear();
            const m = String(today.getMonth() + 1).padStart(2, '0');
            const d = String(today.getDate()).padStart(2, '0');
            rawVal = `${y}-${m}-${d}`;
        }
    }

    const clean = rawVal.replace(/[^0-9]/g, '');
    if (clean.length === 8) {
        const y = clean.substring(0, 4);
        const m = clean.substring(4, 6);
        const d = clean.substring(6, 8);
        if (targetFormat === 'YYYYMMDD') {
            return clean;
        } else if (targetFormat === 'YYYY.MM.DD') {
            return `${y}.${m}.${d}`;
        } else {
            return `${y}-${m}-${d}`;
        }
    }

    if (targetFormat === 'YYYYMMDD') {
        return rawVal.replace(/[^0-9]/g, '');
    }
    return rawVal;
}
window.resolveFilterYmd = resolveFilterYmd;
window.getFilterYmd = resolveFilterYmd;

/**
 * Safe Resolution for Current Filter Start Date (filterFYmd / filterFymd)
 * 화면 상단 기간 필터바의 시작일자를 추출하여 지정한 포맷으로 안전하게 반환합니다.
 * @param {HTMLElement|string} [pane] - 현재 화면/탭 컨테이너 요소
 * @param {string} [format='YYYY-MM-DD'] - 반환 포맷 ('YYYY-MM-DD', 'YYYYMMDD', 'YYYY.MM.DD')
 * @returns {string} 포맷팅된 날짜 문자열
 */
function resolveFilterFymd(pane, format) {
    if (!pane && window.currentPane) pane = window.currentPane;
    let targetFormat = format;
    let targetPane = pane;
    if (typeof pane === 'string' && !format) {
        var upper = pane.toUpperCase();
        if (upper === 'YYYY-MM-DD' || upper === 'YYYYMMDD' || upper === 'YYYY.MM.DD' || upper === 'RAW') {
            targetFormat = upper;
            targetPane = null;
        }
    }
    if (!targetFormat) targetFormat = 'YYYY-MM-DD';
    targetFormat = targetFormat.toUpperCase();

    const root = (targetPane && typeof targetPane.querySelector === 'function') ? targetPane : document;
    const input = root.querySelector('#filterFYmd')
               || root.querySelector('#filterFymd')
               || root.querySelector('input[name="fYmd"]')
               || root.querySelector('input[name="fymd"]')
               || root.querySelector('input.range-calendar-input:first-of-type');

    let rawVal = '';
    if (input && input.value) rawVal = String(input.value).trim();
    else if (input && input.getAttribute('value')) rawVal = String(input.getAttribute('value')).trim();

    if (!rawVal) {
        return resolveFilterYmd(targetPane, targetFormat);
    }

    const clean = rawVal.replace(/[^0-9]/g, '');
    if (clean.length === 8) {
        const y = clean.substring(0, 4);
        const m = clean.substring(4, 6);
        const d = clean.substring(6, 8);
        if (targetFormat === 'YYYYMMDD') return clean;
        if (targetFormat === 'YYYY.MM.DD') return `${y}.${m}.${d}`;
        return `${y}-${m}-${d}`;
    }
    if (targetFormat === 'YYYYMMDD') return clean;
    return rawVal;
}
window.resolveFilterFymd = resolveFilterFymd;
window.getFilterFymd = resolveFilterFymd;
window.getFilterFYmd = resolveFilterFymd;

/**
 * Safe Resolution for Current Filter End Date (filterTYmd / filterTymd)
 * 화면 상단 기간 필터바의 종료일자를 추출하여 지정한 포맷으로 안전하게 반환합니다.
 * @param {HTMLElement|string} [pane] - 현재 화면/탭 컨테이너 요소
 * @param {string} [format='YYYY-MM-DD'] - 반환 포맷 ('YYYY-MM-DD', 'YYYYMMDD', 'YYYY.MM.DD')
 * @returns {string} 포맷팅된 날짜 문자열
 */
function resolveFilterTymd(pane, format) {
    if (!pane && window.currentPane) pane = window.currentPane;
    let targetFormat = format;
    let targetPane = pane;
    if (typeof pane === 'string' && !format) {
        var upper = pane.toUpperCase();
        if (upper === 'YYYY-MM-DD' || upper === 'YYYYMMDD' || upper === 'YYYY.MM.DD' || upper === 'RAW') {
            targetFormat = upper;
            targetPane = null;
        }
    }
    if (!targetFormat) targetFormat = 'YYYY-MM-DD';
    targetFormat = targetFormat.toUpperCase();

    const root = (targetPane && typeof targetPane.querySelector === 'function') ? targetPane : document;
    const input = root.querySelector('#filterTYmd')
               || root.querySelector('#filterTymd')
               || root.querySelector('input[name="tYmd"]')
               || root.querySelector('input[name="tymd"]')
               || root.querySelector('input.range-calendar-input:last-of-type');

    let rawVal = '';
    if (input && input.value) rawVal = String(input.value).trim();
    else if (input && input.getAttribute('value')) rawVal = String(input.getAttribute('value')).trim();

    if (!rawVal) {
        return resolveFilterYmd(targetPane, targetFormat);
    }

    const clean = rawVal.replace(/[^0-9]/g, '');
    if (clean.length === 8) {
        const y = clean.substring(0, 4);
        const m = clean.substring(4, 6);
        const d = clean.substring(6, 8);
        if (targetFormat === 'YYYYMMDD') return clean;
        if (targetFormat === 'YYYY.MM.DD') return `${y}.${m}.${d}`;
        return `${y}-${m}-${d}`;
    }
    if (targetFormat === 'YYYYMMDD') return clean;
    return rawVal;
}
window.resolveFilterTymd = resolveFilterTymd;
window.getFilterTymd = resolveFilterTymd;
window.getFilterTYmd = resolveFilterTymd;

/**
 * Filter Calendar 자동 초기화 헬퍼 (initCalendar 보일러플레이트 제거용)
 * @param {HTMLElement} [pane] - 화면 탭 컨테이너
 * @param {object|string} [options] - 초기 옵션 또는 initialYmd
 */
function initFilterCalendar(pane, options) {
    if (!pane && window.currentPane) pane = window.currentPane;
    options = options || {};
    if (typeof options === 'string') options = { initialYmd: options };

    const root = (pane && typeof pane.querySelector === 'function') ? pane : document;

    // 1) 기간 달력 체크 (filterFYmd & filterTYmd)
    const fymdInput = root.querySelector(options.fymdId ? '#' + options.fymdId : '#filterFYmd, #filterFymd');
    const tymdInput = root.querySelector(options.tymdId ? '#' + options.tymdId : '#filterTYmd, #filterTymd');
    if (fymdInput && tymdInput && window.AamsCalendar && typeof window.AamsCalendar.initRange === 'function') {
        window.AamsCalendar.initRange(fymdInput.id || 'filterFYmd', tymdInput.id || 'filterTYmd', {
            pane: pane,
            onSelect: options.onSelect
        });
        return;
    }

    // 2) 단일 달력 및 연월(Month) 달력 체크
    const isMonthMode = (options.mode === 'month' || options.type === 'month' || options.inputId === 'filterYm' || (options.inputId && options.inputId.includes('Ym') && !options.inputId.includes('Ymd')));
    const inputId = options.inputId || (isMonthMode ? 'filterYm' : 'filterYmd');
    const input = root.querySelector('#' + inputId)
               || (isMonthMode ? root.querySelector('input[name="ym"]') : root.querySelector('input[name="ymd"]'))
               || root.querySelector('.aams-calendar-input');
    if (!input) return;

    var detectedCorpGr = (typeof resolveCorpGr === 'function') ? resolveCorpGr(pane) : '';
    var syncYmd = (window.WorkDateSyncManager && typeof window.WorkDateSyncManager.getWorkDate === 'function')
        ? window.WorkDateSyncManager.getWorkDate(detectedCorpGr)
        : '';

    let defaultVal = syncYmd;
    if (isMonthMode && syncYmd && syncYmd.length >= 7) {
        defaultVal = syncYmd.substring(0, 7);
    }
    const initialVal = isMonthMode
        ? (options.initialYm || options.initialYmd || input.value || (input.getAttribute ? input.getAttribute('value') : '') || defaultVal || '')
        : (syncYmd || options.initialYmd || input.value || (input.getAttribute ? input.getAttribute('value') : '') || '');

    if (initialVal) {
        input.value = initialVal;
    }

    if (window.AamsCalendar) {
        if (isMonthMode && typeof window.AamsCalendar.initMonth === 'function') {
            window.AamsCalendar.initMonth(input.id || inputId, {
                pane: pane,
                initialYmd: input.value || initialVal,
                onSelect: options.onSelect
            });
        } else if (typeof window.AamsCalendar.initSimple === 'function') {
            window.AamsCalendar.initSimple(input.id || inputId, {
                pane: pane,
                initialYmd: input.value || initialVal,
                onSelect: options.onSelect
            });
        }
    }
}
window.initFilterCalendar = initFilterCalendar;

/**
 * Filter DDDW 2칸 분할 셀렉트박스 자동 초기화 헬퍼 (initDddw 보일러플레이트 제거용)
 * @param {HTMLElement} [pane] - 화면 탭 컨테이너
 * @param {object} config - 설정 객체:
 *      selectId: 셀렉트박스 ID (기본: 'filterDddw')
 *      dddwId: f_dddwctl dddw ID (e.g. 'dddw', 'tr_co_cd', 'sec_cd')
 *      corpGr: 회사코드 (생략 시 resolveCorpGr(pane) 자동 적용)
 *      seq: f_dddwctl seq 번호 (기본: 1)
 *      addWhere: f_dddwctl 추가 조건식
 *      defaultOptions: API 실패 시 대체 기본 옵션 목록
 *      defaultVal: 초기 선택값 (생략 시 첫 번째 항목 또는 기존 값)
 *      codeTitle: 2칸 헤더 코드명 (기본: '코드')
 *      nameTitle: 2칸 헤더 명칭 (기본: '코드명')
 *      onSelect: 선택 시 콜백 function(code, name)
 * @returns {Promise<Array>}
 */
function initFilterDddw(pane, config) {
    if (!pane && window.currentPane) pane = window.currentPane;
    config = config || {};
    const selectId = config.selectId || 'filterDddw';
    const root = (pane && typeof pane.querySelector === 'function') ? pane : document;
    const selectEl = root.querySelector('#' + selectId) || root.querySelector('select[name="dddw"]');
    if (!selectEl) return Promise.resolve([]);

    const corpGr = config.corpGr || resolveCorpGr(pane);
    const dddwId = config.dddwId;
    const seq = config.seq || 1;
    const addWhere = config.addWhere || '';
    const defaultOptions = config.defaultOptions || [];

    function populate(options) {
        const list = (options && options.length > 0) ? options : defaultOptions;
        if (!list || list.length === 0) return list;

        selectEl.innerHTML = '';
        list.forEach(function (opt) {
            const code = (opt.code != null ? opt.code : (opt.cd != null ? opt.cd : '')).toString().trim();
            const name = (opt.name != null ? opt.name : (opt.nm != null ? opt.nm : (opt.dscr != null ? opt.dscr : code))).toString().trim();
            const optEl = document.createElement('option');
            optEl.value = code;
            optEl.textContent = name;
            selectEl.appendChild(optEl);
        });

        let targetVal = config.defaultVal || selectEl.value;
        const match = list.find(function(o) {
            const c = (o.code != null ? o.code : o.cd || '').toString().trim();
            return c === targetVal;
        });
        if (!match && list.length > 0) {
            targetVal = (list[0].code != null ? list[0].code : list[0].cd || '').toString().trim();
        }
        selectEl.value = targetVal;

        if (window.f_dddwctl && typeof window.f_dddwctl.get2ColItemFormatter === 'function') {
            window.f_dddwctl.get2ColItemFormatter(selectEl, list, {
                codeTitle: config.codeTitle || "코드",
                nameTitle: config.nameTitle || "코드명",
                defaultVal: targetVal,
                onSelect: function (code, name) {
                    selectEl.value = code;
                    if (typeof config.onSelect === 'function') {
                        config.onSelect(code, name);
                    }
                }
            });
        }
        return list;
    }

    const addData = config.addData || '';

    if (dddwId && typeof window.f_dddwctl === 'function') {
        return window.f_dddwctl(dddwId, corpGr, addData, seq, addWhere).then(function (options) {
            return populate(options);
        }).catch(function (e) {
            console.warn('[common.initFilterDddw] f_dddwctl load error, using default options:', e);
            return populate(defaultOptions);
        });
    } else {
        return Promise.resolve(populate(defaultOptions));
    }
}
window.initFilterDddw = initFilterDddw;

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
window.formatDateVal = formatDate;
window.formatDateHyphen = formatDate;
window.formatDateTimeVal = function(val) { return formatDate(val, true); };

/**
 * Common Currency / Money Formatter
 */
function formatMoney(val) {
    if (val == null || val === "" || isNaN(val)) return "";
    return Number(val).toLocaleString("ko-KR");
}
window.formatMoney = formatMoney;
window.numFmt = function(val) { return formatMoney(val) || "0"; };

/**
 * Common Business Registration Number Formatter (10-digit: 000-00-00000)
 */
function formatBizNo(val) {
    if (!val) return "";
    var clean = String(val).replace(/\D/g, "");
    if (clean.length === 10) {
        return clean.substring(0, 3) + "-" + clean.substring(3, 5) + "-" + clean.substring(5, 10);
    }
    return val;
}
window.formatBizNo = formatBizNo;
window.formatIdno = formatBizNo;

/**
 * Common Date Add Months (PowerBuilder f_add_months compatibility)
 * @param {string} ymdStr - YYYYMMDD, YYYY-MM-DD, or YYYY.MM.DD
 * @param {number} months - Months to add/subtract
 * @param {string} [separator='.'] - Output separator ('.' or '-')
 * @returns {string}
 */
function addMonthsToYmd(ymdStr, months, separator = '.') {
    if (!ymdStr) return "";
    var clean = String(ymdStr).replace(/\D/g, "");
    if (clean.length < 8) return ymdStr;
    var year = parseInt(clean.substring(0, 4), 10);
    var month = parseInt(clean.substring(4, 6), 10) - 1;
    var day = parseInt(clean.substring(6, 8), 10);

    var dt = new Date(year, month, day);
    dt.setMonth(dt.getMonth() + Number(months || 0));

    var y = dt.getFullYear();
    var m = String(dt.getMonth() + 1).padStart(2, '0');
    var d = String(dt.getDate()).padStart(2, '0');
    return separator ? `${y}${separator}${m}${separator}${d}` : `${y}${m}${d}`;
}
window.addMonthsToYmd = addMonthsToYmd;
window.f_add_months = addMonthsToYmd;

/**
 * Common Date Dot Formatter (YYYYMMDD / YYYY-MM-DD -> YYYY.MM.DD)
 */
function formatDateDot(val) {
    if (!val || val === '-') return '-';
    let s = String(val).trim();
    if (!s) return '-';
    const clean = s.replace(/[^0-9]/g, '');
    if (clean.length === 8) {
        return `${clean.substring(0, 4)}.${clean.substring(4, 6)}.${clean.substring(6, 8)}`;
    }
    return formatDate(val).replace(/-/g, '.');
}
window.formatDateDot = formatDateDot;

/**
 * ============================================================================
 * AAMS Common Date Validator & Tabulator Date Editor Engine
 * ============================================================================
 * 날짜 수기 입력 시 형식 및 실제 달력 일자(윤년, 월별 말일) 유효성을 정밀 검증하고,
 * 유효하지 않은 날짜 입력을 원천 차단하며 표준 포맷으로 정규화합니다.
 */

/**
 * Common Date Validator & Normalizer
 * @param {string|number|Date} val - 입력 날짜값 (예: "2026-10-12", "20261012", "2026.10.12")
 * @param {string} [separator='-'] - 반환 포맷 구분자 ('-' 또는 '.')
 * @returns {string|null} 유효하면 'YYYY-MM-DD' (또는 지정 구분자), 빈 값이면 '', 유효하지 않으면 null
 */
function parseValidDate(val, separator = '-') {
    if (val === null || val === undefined) return '';
    let s = String(val).trim();
    if (!s || s === '-') return '';

    let year = 0, month = 0, day = 0;

    // 1) 구분자가 포함된 경우 (예: 2026-10-12, 2026.10.12, 2026/10/12, 2026-1-5)
    if (s.includes('-') || s.includes('.') || s.includes('/')) {
        let parts = s.split(/[-./]/);
        if (parts.length === 3) {
            year = parseInt(parts[0], 10);
            month = parseInt(parts[1], 10);
            day = parseInt(parts[2], 10);
        } else {
            return null;
        }
    } else {
        // 2) 숫자만 있는 경우 (예: 20261012)
        let clean = s.replace(/[^0-9]/g, '');
        if (clean.length === 8) {
            year = parseInt(clean.substring(0, 4), 10);
            month = parseInt(clean.substring(4, 6), 10);
            day = parseInt(clean.substring(6, 8), 10);
        } else {
            return null;
        }
    }

    if (isNaN(year) || isNaN(month) || isNaN(day)) return null;

    // 3) 연도 범위 체크 (1900 ~ 2100)
    if (year < 1900 || year > 2100) return null;

    // 4) 월 범위 체크 (1 ~ 12)
    if (month < 1 || month > 12) return null;

    // 5) 일자 범위 체크 (윤년 및 각 월별 실제 일수)
    let maxDays = new Date(year, month, 0).getDate();
    if (day < 1 || day > maxDays) return null;

    let yStr = String(year);
    let mStr = String(month).padStart(2, '0');
    let dStr = String(day).padStart(2, '0');

    return separator ? `${yStr}${separator}${mStr}${separator}${dStr}` : `${yStr}${mStr}${dStr}`;
}
window.parseValidDate = parseValidDate;

/**
 * Common Date Validity Checker
 * @param {string|number|Date} val
 * @returns {boolean} 유효한 날짜이면 true, 아니면 false
 */
function isValidDate(val) {
    if (!val || val === '-') return false;
    let parsed = parseValidDate(val);
    return parsed !== null && parsed !== '';
}
window.isValidDate = isValidDate;

/**
 * Tabulator Common Date Cell Editor (aamsDateEditor)
 * 그리드 셀에 수기로 날짜 입력 시 실시간 유효성 검증을 수행하고,
 * 유효하지 않은 날짜(예: 2026-99-99) 입력 시 경고 알림과 함께 원래 값으로 복원합니다.
 * 유효한 날짜 입력 시 표준 'YYYY-MM-DD'로 자동 정규화합니다.
 */
function aamsDateEditor(cell, onRendered, success, cancel, editorParams) {
    if (typeof aamsCellEdit === 'function') {
        try { aamsCellEdit(null, cell); } catch(e) {}
    }

    const input = document.createElement("input");
    input.type = "text";
    input.className = "tabulator-date-editor";
    input.style.width = "100%";
    input.style.height = "100%";
    input.style.textAlign = "center";
    input.style.padding = "2px 4px";
    input.style.boxSizing = "border-box";
    input.maxLength = 10;
    input.placeholder = (editorParams && editorParams.placeholder) || "YYYY-MM-DD";

    const curVal = cell.getValue();
    const formattedCur = parseValidDate(curVal) || (curVal ? String(curVal) : "");
    input.value = formattedCur;

    onRendered(function() {
        input.focus();
        input.select();
    });

    let isCommitted = false;
    function commitValue() {
        if (isCommitted) return;
        isCommitted = true;

        const val = input.value.trim();
        if (!val || val === "-") {
            if (editorParams && editorParams.required) {
                if (typeof showToast === "function") showToast("날짜를 입력해주세요.", "warning");
                else alert("날짜를 입력해주세요.");
                cancel();
                return;
            }
            success("");
            return;
        }

        const sep = (editorParams && editorParams.separator) || "-";
        const validDate = parseValidDate(val, sep);
        if (!validDate) {
            const msg = (editorParams && editorParams.invalidMessage) || "올바른 날짜(YYYY-MM-DD)를 입력해주세요.";
            if (typeof showToast === "function") showToast(msg, "warning");
            else alert(msg);
            cancel();
            return;
        }

        success(validDate);
    }

    input.addEventListener("keydown", function(e) {
        if (e.key === "Enter") {
            commitValue();
        } else if (e.key === "Escape") {
            isCommitted = true;
            cancel();
        }
    });

    input.addEventListener("blur", function() {
        commitValue();
    });

    return input;
}
window.aamsDateEditor = aamsDateEditor;

/**
 * Tabulator Cell Edit Date Validator Helper (aamsValidateDateCell)
 * cellEdited 이벤트 핸들러에서 셀 값을 검증할 때 사용
 * @param {CellComponent} cell - Tabulator 셀 객체
 * @param {Function} [onValid] - 유효할 경우 실행할 콜백 (cell, validDate)
 * @returns {boolean} 유효 여부
 */
function aamsValidateDateCell(cell, onValid) {
    if (!cell) return false;
    const val = cell.getValue();
    if (!val || val === "-") {
        if (typeof onValid === 'function') onValid(cell, "");
        return true;
    }
    const valid = parseValidDate(val);
    if (!valid) {
        if (typeof showToast === "function") {
            showToast("올바른 날짜(YYYY-MM-DD)를 입력해주세요.", "warning");
        } else {
            alert("올바른 날짜(YYYY-MM-DD)를 입력해주세요.");
        }
        const oldVal = cell.getOldValue() || "";
        cell.setValue(oldVal, true);
        return false;
    }
    if (val !== valid) {
        cell.setValue(valid, true);
    }
    if (typeof onValid === 'function') {
        onValid(cell, valid);
    }
    return true;
}
window.aamsValidateDateCell = aamsValidateDateCell;

/**
 * Grid-wide Date Columns Validator (저장 전 일괄 날짜 유효성 검증기)
 * @param {Tabulator} grid - 대상 그리드 인스턴스
 * @param {string[]} dateFields - 검증할 날짜 컬럼 field 명 목록 (예: ['collStart', 'collEnd'])
 * @returns {boolean} 모든 행의 날짜가 유효하면 true, 아니면 false
 */
function aamsValidateGridDates(grid, dateFields) {
    if (!grid || !Array.isArray(dateFields) || dateFields.length === 0) return true;
    const rows = grid.getRows();
    for (let i = 0; i < rows.length; i++) {
        const d = rows[i].getData();
        if (d.isSummaryRow) continue;
        for (let j = 0; j < dateFields.length; j++) {
            const field = dateFields[j];
            const val = d[field];
            if (val && val !== "-" && !isValidDate(val)) {
                if (typeof rows[i].select === 'function') rows[i].select();
                const col = grid.getColumn(field);
                const colTitle = col ? col.getDefinition().title.replace(/<[^>]*>/g, '').trim() : field;
                const msg = `${i + 1}번째 행의 ${colTitle}에 올바르지 않은 날짜(${val})가 입력되어 있습니다.`;
                if (typeof showToast === "function") showToast(msg, "warning");
                else alert(msg);
                return false;
            }
        }
    }
    return true;
}
window.aamsValidateGridDates = aamsValidateGridDates;

/**
 * AAMS Tabulator Standard Cell Formatters (그리드 표준 포매터)
 */
function aamsNumberFormatter(cell, formatterParams) {
    const val = cell.getValue();
    if (val === null || val === undefined || val === '') return '';
    const num = Number(val);
    if (isNaN(num)) return val;
    const decimals = (formatterParams && typeof formatterParams.decimals === 'number') ? formatterParams.decimals : undefined;
    return formatNumber(num, decimals, '');
}
window.aamsNumberFormatter = aamsNumberFormatter;

function aamsIntFormatter(cell) {
    const val = cell.getValue();
    if (val === null || val === undefined || val === '') return '';
    const num = Number(val);
    if (isNaN(num)) return val;
    return Math.round(num).toLocaleString('ko-KR');
}
window.aamsIntFormatter = aamsIntFormatter;

function aamsChangeFormatter(cell) {
    const val = cell.getValue();
    if (val === null || val === undefined || val === '') return '';
    const num = Number(val);
    if (isNaN(num)) return val;
    if (num > 0) return `<span class="cell-price-up">▲ ${num.toLocaleString('ko-KR')}</span>`;
    if (num < 0) return `<span class="cell-price-down">▼ ${Math.abs(num).toLocaleString('ko-KR')}</span>`;
    return `<span class="cell-text-muted">- ${num.toLocaleString('ko-KR')}</span>`;
}
window.aamsChangeFormatter = aamsChangeFormatter;

function aamsDateFormatter(cell, formatterParams) {
    const val = cell.getValue();
    if (!val) return '';
    const isDot = formatterParams && (formatterParams.dot || formatterParams.format === 'YYYY.MM.DD');
    return isDot ? formatDateDot(val) : formatDate(val);
}
window.aamsDateFormatter = aamsDateFormatter;

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
            // 1. 세션 스토리지에 변경된 회사의 회사코드 및 최신 영업일자/전영업일자 즉시 반영
            try {
                if (data.corpGr) sessionStorage.setItem('corpGr', data.corpGr);
                if (data.workDate) {
                    sessionStorage.setItem('workDate', data.workDate);
                    sessionStorage.setItem('workYmd', data.workDate);
                }
                if (data.junyongDate) {
                    sessionStorage.setItem('junyongDate', data.junyongDate);
                    sessionStorage.setItem('junyongYmd', data.junyongDate);
                }
                // 2. localStorage의 stale 날짜 캐시 완전 제거 및 corpGr 갱신
                localStorage.removeItem('workDate');
                localStorage.removeItem('workYmd');
                localStorage.removeItem('junyongDate');
                localStorage.removeItem('junyongYmd');
                if (data.corpGr) localStorage.setItem('corpGr', data.corpGr);
            } catch(e) {
                console.warn('[selectCompany] storage sync warning:', e);
            }

            // 3. 전역 변수 및 WorkDateSyncManager 동기화
            if (data.corpGr) window.currentCorpGr = data.corpGr;
            if (data.workDate) window.currentWorkDate = data.workDate;
            if (data.junyongDate) window.currentJunyongDate = data.junyongDate;
            if (window.WorkDateSyncManager && typeof window.WorkDateSyncManager.saveWorkDateMap === 'function' && data.corpGr && data.workDate) {
                var map = {};
                map[data.corpGr] = data.workDate;
                window.WorkDateSyncManager.saveWorkDateMap(map);
            }

            // 4. 페이지 새로고침으로 변경된 회사 및 영업일자 즉시 반영
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
let tokenCountdownInterval = null;
let currentRemainingSeconds = 0;
let isExtendModalOpen = false;
let hasChecked5MinWarning = false;

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
    hasChecked5MinWarning = false;
    checkTokenStatus();

    // 1초마다 헤더 타이머 실시간 카운트다운 (15초 무한 폴링 제거, 브라우저 로컬 타이머 동작)
    if (headerTimerInterval) clearInterval(headerTimerInterval);
    headerTimerInterval = setInterval(() => {
        if (currentRemainingSeconds > 0) {
            currentRemainingSeconds--;
            updateHeaderTimerDisplay();
            if (isExtendModalOpen) {
                updateCountdownDisplay();
            }

            // 만료 5분(300초) 이하 도달 시 딱 1회만 서버 실제 토큰 상태 최종 검증 및 연장 모달 오픈
            if (currentRemainingSeconds <= 300 && !hasChecked5MinWarning) {
                hasChecked5MinWarning = true;
                checkTokenStatus();
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

// Window resize listener to automatically redraw Tabulator instances and update sidebar menu mode (Debounced)
var _globalResizeDebounceTimer = null;
window._aamsIsResizing = false;
window.addEventListener('resize', function() {
    window._aamsIsResizing = true;
    clearTimeout(_globalResizeDebounceTimer);
    _globalResizeDebounceTimer = setTimeout(function() {
        if (typeof checkHeaderCollision === 'function') {
            checkHeaderCollision();
        }

        if (typeof Tabulator !== 'undefined') {
            Tabulator.findTable(".tabulator").forEach(table => {
                try { table.redraw(); } catch(e) {}
            });
        }
        window._aamsIsResizing = false;
    }, 120);
});

// AES-128-CBC Cookie Decryptor for ENC_ prefixed cookies
const CookieCrypto = (function() {
    const KEY_STR = "AamsCookieKey16!";
    const IV_STR  = "AamsCookieIv16!!";
    const S = [
        0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76,
        0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0,
        0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15,
        0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75,
        0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84,
        0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf,
        0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8,
        0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2,
        0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73,
        0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb,
        0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79,
        0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08,
        0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a,
        0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e,
        0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf,
        0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16
    ];
    const Si = [];
    for (let i = 0; i < 256; i++) Si[S[i]] = i;
    const Rcon = [0x00,0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80,0x1b,0x36];

    function strToBytes(str) {
        const b = [];
        for (let i = 0; i < str.length; i++) b.push(str.charCodeAt(i) & 0xff);
        return b;
    }
    function keyExpansion(key) {
        const w = [];
        for (let i = 0; i < 4; i++) w[i] = (key[4*i] << 24) | (key[4*i+1] << 16) | (key[4*i+2] << 8) | key[4*i+3];
        for (let i = 4; i < 44; i++) {
            let temp = w[i - 1];
            if (i % 4 === 0) {
                temp = ((temp << 8) | (temp >>> 24)) & 0xffffffff;
                temp = (S[(temp >>> 24) & 0xff] << 24) | (S[(temp >>> 16) & 0xff] << 16) | (S[(temp >>> 8) & 0xff] << 8) | S[temp & 0xff];
                temp ^= (Rcon[i / 4] << 24);
            }
            w[i] = (w[i - 4] ^ temp) >>> 0;
        }
        return w;
    }
    function gmul(a, b) {
        let p = 0;
        for (let counter = 0; counter < 8; counter++) {
            if ((b & 1) !== 0) p ^= a;
            const hi = (a & 0x80) !== 0;
            a = (a << 1) & 0xff;
            if (hi) a ^= 0x1b;
            b >>= 1;
        }
        return p;
    }
    function invCipher(input, w) {
        let state = [...input];
        for (let c = 0; c < 4; c++) {
            const word = w[40 + c];
            state[c*4] ^= (word >>> 24) & 0xff; state[c*4+1] ^= (word >>> 16) & 0xff; state[c*4+2] ^= (word >>> 8) & 0xff; state[c*4+3] ^= word & 0xff;
        }
        for (let round = 9; round >= 1; round--) {
            const temp = [...state];
            state[1] = temp[13]; state[5] = temp[1]; state[9] = temp[5]; state[13] = temp[9];
            state[2] = temp[10]; state[6] = temp[14]; state[10] = temp[2]; state[14] = temp[6];
            state[3] = temp[7]; state[7] = temp[11]; state[11] = temp[15]; state[15] = temp[3];
            for (let i = 0; i < 16; i++) state[i] = Si[state[i]];
            for (let c = 0; c < 4; c++) {
                const word = w[round * 4 + c];
                state[c*4] ^= (word >>> 24) & 0xff; state[c*4+1] ^= (word >>> 16) & 0xff; state[c*4+2] ^= (word >>> 8) & 0xff; state[c*4+3] ^= word & 0xff;
            }
            for (let c = 0; c < 4; c++) {
                const a0 = state[c*4], a1 = state[c*4+1], a2 = state[c*4+2], a3 = state[c*4+3];
                state[c*4] = gmul(a0, 0x0e) ^ gmul(a1, 0x0b) ^ gmul(a2, 0x0d) ^ gmul(a3, 0x09);
                state[c*4+1] = gmul(a0, 0x09) ^ gmul(a1, 0x0e) ^ gmul(a2, 0x0b) ^ gmul(a3, 0x0d);
                state[c*4+2] = gmul(a0, 0x0d) ^ gmul(a1, 0x09) ^ gmul(a2, 0x0e) ^ gmul(a3, 0x0b);
                state[c*4+3] = gmul(a0, 0x0b) ^ gmul(a1, 0x0d) ^ gmul(a2, 0x09) ^ gmul(a3, 0x0e);
            }
        }
        const temp = [...state];
        state[1] = temp[13]; state[5] = temp[1]; state[9] = temp[5]; state[13] = temp[9];
        state[2] = temp[10]; state[6] = temp[14]; state[10] = temp[2]; state[14] = temp[6];
        state[3] = temp[7]; state[7] = temp[11]; state[11] = temp[15]; state[15] = temp[3];
        for (let i = 0; i < 16; i++) state[i] = Si[state[i]];
        for (let c = 0; c < 4; c++) {
            const word = w[c];
            state[c*4] ^= (word >>> 24) & 0xff; state[c*4+1] ^= (word >>> 16) & 0xff; state[c*4+2] ^= (word >>> 8) & 0xff; state[c*4+3] ^= word & 0xff;
        }
        return state;
    }
    const keyBytes = strToBytes(KEY_STR);
    const ivBytes = strToBytes(IV_STR);
    const expandedKey = keyExpansion(keyBytes);

    function base64UrlDecode(str) {
        let b64 = str.replace(/-/g, '+').replace(/_/g, '/');
        while (b64.length % 4) b64 += '=';
        const binStr = (typeof atob === 'function') ? atob(b64) : '';
        const bytes = [];
        for (let i = 0; i < binStr.length; i++) bytes.push(binStr.charCodeAt(i) & 0xff);
        return bytes;
    }

    return {
        decrypt: function(encryptedText) {
            if (!encryptedText || typeof encryptedText !== 'string') return encryptedText;
            if (!encryptedText.startsWith('ENC_')) return encryptedText;
            try {
                const cipherBytes = base64UrlDecode(encryptedText.substring(4));
                if (!cipherBytes || cipherBytes.length === 0 || cipherBytes.length % 16 !== 0) return encryptedText;
                let prevBlock = [...ivBytes];
                const plainBytes = [];
                for (let i = 0; i < cipherBytes.length; i += 16) {
                    const block = cipherBytes.slice(i, i + 16);
                    const decryptedBlock = invCipher(block, expandedKey);
                    for (let b = 0; b < 16; b++) plainBytes.push(decryptedBlock[b] ^ prevBlock[b]);
                    prevBlock = block;
                }
                const padLen = plainBytes[plainBytes.length - 1];
                if (padLen < 1 || padLen > 16) return encryptedText;
                const unpadded = plainBytes.slice(0, plainBytes.length - padLen);
                if (typeof TextDecoder !== 'undefined') {
                    return new TextDecoder().decode(new Uint8Array(unpadded));
                }
                let res = '';
                for (let i = 0; i < unpadded.length; i++) res += String.fromCharCode(unpadded[i]);
                return res;
            } catch (e) {
                return encryptedText;
            }
        }
    };
})();
window.CookieCrypto = CookieCrypto;

// Automatically expire legacy obsolete cookies on script load
(function() {
    try {
        document.cookie = "admin=; path=/; max-age=0";
        document.cookie = "corp_gr=; path=/; max-age=0";
        document.cookie = "user_id=; path=/; max-age=0";
    } catch (e) {}
})();

/**
 * Global Cookie Getter Helper
 * Automatically decrypts ENC_ encrypted cookies (e.g. userId, savedEmail)
 */
function getCookie(name) {
    if (!document.cookie) return null;
    const cookies = document.cookie.split(';');
    for (let i = 0; i < cookies.length; i++) {
        const c = cookies[i].trim();
        if (c.startsWith(name + '=')) {
            const raw = decodeURIComponent(c.substring(name.length + 1));
            return (name === 'userId' || name === 'savedEmail' || raw.startsWith('ENC_'))
                ? CookieCrypto.decrypt(raw)
                : raw;
        }
    }
    return null;
}
window.getCookie = getCookie;
window.getCookieVal = getCookie;

/**
 * Global Session/Cookie WorkDate Helper
 * 1순위: sessionStorage (현재 세션의 최신 영업일자)
 * 2순위: window.currentWorkDate (런타임 메모리)
 * 3순위: Cookie (서버 발급 쿠키)
 */
function getCookieWorkDate() {
    try {
        var s = sessionStorage.getItem('workDate') || sessionStorage.getItem('workYmd');
        if (s) return s;
    } catch(e) {}
    return window.currentWorkDate || getCookie('workDate') || getCookie('workYmd') || getCookie('hyunYmd') || '';
}
function getCookieJunyongDate() {
    try {
        var s = sessionStorage.getItem('junyongDate') || sessionStorage.getItem('junyongYmd');
        if (s) return s;
    } catch(e) {}
    return window.currentJunyongDate || getCookie('junyongDate') || getCookie('junyongYmd') || '';
}
window.getCookieWorkDate = getCookieWorkDate;
window.getCookieJunyongDate = getCookieJunyongDate;
window.getSessionWorkDate = getCookieWorkDate;
window.getSessionJunyongDate = getCookieJunyongDate;
window.getCookieCorpGr = function() { return resolveCorpGr(); };

/**
 * Global Common WorkDate Helper (공통 기준 작업일자 및 전영업일 조회)
 * - /api/common/workdate API 호출을 통해 최신 작업일자 및 전영업일자 동기화
 * - sessionStorage에 최신화하고 localStorage의 stale 날짜 캐시 제거
 */
function fetchCommonWorkDate(corpGr, callback) {
    var url = '/api/common/workdate' + (corpGr ? ('?corpGr=' + encodeURIComponent(corpGr)) : '');
    return fetch(url)
        .then(function(res) { return res.json(); })
        .then(function(data) {
            var date = (data && data.workDate) ? data.workDate : null;
            if (data && data.workDate) {
                window.currentWorkDate = data.workDate;
                try {
                    sessionStorage.setItem('workDate', data.workDate);
                    sessionStorage.setItem('workYmd', data.workDate);
                    localStorage.removeItem('workDate');
                    localStorage.removeItem('workYmd');
                } catch(e) {}
            }
            if (data && data.junyongDate) {
                window.currentJunyongDate = data.junyongDate;
                try {
                    sessionStorage.setItem('junyongDate', data.junyongDate);
                    sessionStorage.setItem('junyongYmd', data.junyongDate);
                    localStorage.removeItem('junyongDate');
                    localStorage.removeItem('junyongYmd');
                } catch(e) {}
            }
            if (typeof callback === 'function') callback(date, data);
            return date;
        })
        .catch(function(err) {
            console.warn('[common] fetchCommonWorkDate error:', err);
            if (typeof callback === 'function') callback(null, null);
            return null;
        });
}
window.fetchCommonWorkDate = fetchCommonWorkDate;

/**
 * AAMS WorkDate Synchronization Manager
 * 새로 열리는 탭이나 회사그룹 변경 시 해당 화면의 날짜 인풋(#filterYmd)에 최신 작업일자를 안전하게 동기화
 */
window.WorkDateSyncManager = {
    syncPane: function(pane, corpGr) {
        if (!pane) return;
        var ymdInput = pane.querySelector('#filterYmd') || pane.querySelector('input[name="ymd"]');
        var fymdInput = pane.querySelector('#filterFYmd, #filterFymd, input[name="fYmd"], input[name="fymd"]');
        var tymdInput = pane.querySelector('#filterTYmd, #filterTymd, input[name="tYmd"], input[name="tymd"]');
        if (!ymdInput && !fymdInput && !tymdInput) return;

        var cachedDate = getCookieWorkDate();
        if (cachedDate) {
            if (ymdInput && (!ymdInput.value || ymdInput.value.trim() === '')) ymdInput.value = cachedDate;
            var cachedDot = cachedDate.replace(/-/g, '.');
            if (fymdInput && (!fymdInput.value || fymdInput.value.trim() === '')) fymdInput.value = cachedDot;
            if (tymdInput && (!tymdInput.value || tymdInput.value.trim() === '')) tymdInput.value = cachedDot;
        }

        var targetCorp = corpGr || (typeof resolveCorpGr === 'function' ? resolveCorpGr(pane) : '');
        if (targetCorp && typeof fetchCommonWorkDate === 'function') {
            fetchCommonWorkDate(targetCorp, function(workDate) {
                if (workDate) {
                    if (ymdInput) ymdInput.value = workDate;
                    var dateDot = workDate.replace(/-/g, '.');
                    if (fymdInput) fymdInput.value = dateDot;
                    if (tymdInput) tymdInput.value = dateDot;
                }
            });
        }
    }
};

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
/**
 * AAMS Master-Detail Focus Preservation & Multi-Grid Coordination Manager
 *
 * [핵심 해결 과제: 마스터-디테일 연동 시 서브 그리드의 마스터 셀/컬럼 포커스 탈취 원천 차단]
 * 1. 마스터 그리드에서 사용자가 특정 컬럼 셀을 클릭하면 해당 셀/컬럼을 전역 활성 타겟으로 기억하고 시각적 포커스 링(.aams-focused-cell)을 부여.
 * 2. 디테일/서브 그리드가 비동기 조회되어 데이터가 로드되고 행 선택이 일어나더라도,
 *    마스터 그리드의 활성 셀이나 에디터(<input>)의 포커스를 서브 그리드가 빼앗지 못하도록(shouldBlockFocusSteal) 원천 방어.
 * 3. 비동기 렌더링에 의해 마스터 그리드 셀의 포커스가 일시적으로 blur되더라도 즉각 복원(restoreFocus).
 */
const AamsFocusManager = {
    activeGrid: null,
    activeCellEl: null,
    activeField: null,
    activeRow: null,
    activeInputEl: null,
    lastInteractionTime: 0,

    markActive: function(grid, cellEl, field, row, inputEl) {
        if (!grid) return;
        this.activeGrid = grid;
        this.activeCellEl = cellEl || null;
        this.activeField = field || (cellEl && cellEl.getAttribute ? cellEl.getAttribute("tabulator-field") : null);
        this.activeRow = row || null;
        this.activeInputEl = inputEl || (cellEl && cellEl.querySelector ? cellEl.querySelector("input, textarea, select") : null);
        this.lastInteractionTime = Date.now();
    },

    shouldBlockFocusSteal: function(requestingGrid) {
        // 1. 사용자가 최근(8초 이내) 다른 그리드(예: 마스터 그리드)를 클릭/편집 중이었다면,
        // 서브 그리드가 포커스를 가져가지 못하도록 완전 차단
        if (this.activeGrid && this.activeGrid !== requestingGrid) {
            if (this.activeGrid.element && document.body.contains(this.activeGrid.element)) {
                if (Date.now() - this.lastInteractionTime < 8000) {
                    return true;
                }
            }
        }

        // 2. 현재 활성 엘리먼트가 INPUT, TEXTAREA, SELECT 이거나 .tabulator-cell 이면 탈취 차단
        const active = document.activeElement;
        if (active && active !== document.body && active !== document.documentElement) {
            if (active.tagName === 'INPUT' || active.tagName === 'TEXTAREA' || active.tagName === 'SELECT') {
                return true;
            }
            const activeTable = active.closest('.tabulator');
            if (activeTable && activeTable !== requestingGrid.element) {
                return true;
            }
            if (active.classList && (active.classList.contains('tabulator-cell') || active.classList.contains('tabulator-editing'))) {
                return true;
            }
        }
        return false;
    },

    restoreFocus: function(grid) {
        const targetGrid = grid || this.activeGrid;
        if (!targetGrid || !targetGrid.element || !document.body.contains(targetGrid.element)) return;

        if (Date.now() - this.lastInteractionTime > 8000) return;

        try {
            if (this.activeInputEl && document.body.contains(this.activeInputEl)) {
                if (document.activeElement !== this.activeInputEl) {
                    this.activeInputEl.focus({ preventScroll: true });
                }
            }
        } catch(e) {}
    }
};
window.AamsFocusManager = AamsFocusManager;

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

    // Use RowComponent instance & Data Key comparison to reliably identify row changes across all screens
    let lastSelectedRow = null;
    let lastSelectedRowKey = null;

    function extractRowKey(r) {
        if (!r) return null;
        const d = (typeof r.getData === 'function') ? r.getData() : null;
        if (!d) return null;
        if (options.keyField && d[options.keyField] !== undefined) {
            return String(d[options.keyField]);
        }
        if (d._rowId !== undefined) return String(d._rowId);
        if (d.id !== undefined) return String(d.id);
        const fundCd = d.fundCd || d.fund_cd || d.cd || d.code || '';
        const corpGr = d.corpGr || d.corp_gr || '';
        const ymd = d.ymd || d.workDate || '';
        if (fundCd || corpGr || ymd) {
            return corpGr + '_' + ymd + '_' + fundCd;
        }
        try {
            return JSON.stringify(d);
        } catch (e) {
            return null;
        }
    }

    // 헬퍼: 행 포커스 및 스크롤 이동
    function focusRow(targetRow) {
        if (!targetRow) return;
        if (typeof targetRow.scrollTo === 'function') {
            try { targetRow.scrollTo("nearest"); } catch(e) {}
        }
        const rowEl = (typeof targetRow.getElement === 'function') ? targetRow.getElement() : null;
        if (!rowEl) return;

        if (!rowEl.hasAttribute('tabindex')) {
            rowEl.setAttribute('tabindex', '-1');
        }

        // [포커스 탈취 방지 가드: Master-Detail 환경 핵심 안정화]
        // 현재 브라우저의 활성 포커스가 다른 테이블(예: 마스터 그리드)이나
        // 입력 폼에 머물러 있다면, 비동기 서브 그리드 조회가 포커스를 빼앗지 않도록 차단
        if (AamsFocusManager.shouldBlockFocusSteal(table)) {
            return;
        }

        try { rowEl.focus({ preventScroll: true }); } catch(e) {}
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
        if (row && typeof row.getData !== 'function') {
            if (typeof row.getComponent === 'function') {
                try {
                    rowComp = row.getComponent();
                } catch (e) {
                    rowComp = row;
                }
            }
        }

        const currentRowKey = extractRowKey(rowComp);
        const isSameDataKey = (currentRowKey !== null && currentRowKey === lastSelectedRowKey);
        const isUserClick = !!originalEvent;
        const isResizing = (window._aamsIsResizing === true);

        // 창 크기 조절(Resize) 중이거나 이미 동일한 키의 데이터 행인 경우, 사용자 명시적 클릭이나 force가 없으면 콜백 재실행 방지 (단순 조회 및 마스터-상세 불필요 재조회 원천 차단)
        let isRowChanged = false;
        if (force || isUserClick) {
            isRowChanged = true;
        } else if (isResizing) {
            isRowChanged = false; // 리사이즈 중에는 redraw로 인한 가상 행 변경 콜백 억제
        } else {
            isRowChanged = (!isSameDataKey && rowComp !== lastSelectedRow);
        }

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
            lastSelectedRowKey = currentRowKey;
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
                // 사용자가 마스터/상위 그리드를 클릭했음을 FocusManager에 기록 (서브 그리드의 비동기 포커스 탈취 차단)
                AamsFocusManager.markActive(table, null, null, targetRow);
                doSelect(targetRow, false, e);
            }
        }, true);

        // 헬퍼: 드롭다운(dddw 및 하드코딩 list)의 기존 화면 표시 라벨/값 추출
        function getCellDisplayLabel(cell) {
            if (!cell) return "";
            const colDef = cell.getColumn().getDefinition();
            const val = cell.getValue();
            const rowData = (typeof cell.getRow === 'function' && cell.getRow() && typeof cell.getRow().getData === 'function') ? cell.getRow().getData() : {};
            const field = cell.getField();

            // 1. 포매터 함수가 있는 경우 포매터 실행 결과에서 텍스트 추출 시도
            if (typeof colDef.formatter === 'function') {
                try {
                    const formatted = colDef.formatter(cell);
                    if (formatted != null && typeof formatted === 'string') {
                        const temp = document.createElement("div");
                        temp.innerHTML = formatted;
                        const txt = temp.textContent || temp.innerText || "";
                        if (txt.trim()) return txt.trim();
                    }
                } catch (e) {}
            }

            // 2. editorParams.values / valuesLookup 확인 (하드코딩 및 동적 리스트)
            let editorParams = colDef.editorParams;
            if (typeof editorParams === 'function') {
                try { editorParams = editorParams(cell); } catch(e) {}
            }
            if (editorParams) {
                let vals = editorParams.values;
                if (!vals && typeof editorParams.valuesLookup === 'function') {
                    try { vals = editorParams.valuesLookup(cell); } catch(e) {}
                }
                if (Array.isArray(vals)) {
                    const matched = vals.find(it => {
                        if (it == null) return false;
                        if (typeof it === 'object') {
                            const itemVal = (it.value !== undefined) ? it.value : (it.code !== undefined ? it.code : (it.cd !== undefined ? it.cd : ''));
                            return String(itemVal).trim() === String(val).trim();
                        }
                        return String(it).trim() === String(val).trim();
                    });
                    if (matched) {
                        if (typeof matched === 'object') {
                            return matched.label || matched.name || matched.dscr || matched.value || String(val);
                        }
                        return String(matched);
                    }
                }
            }

            // 3. f_dddwctl 연동 확인
            if (window.f_dddwctl && typeof window.f_dddwctl.getLabel === 'function') {
                try {
                    const pane = cell.getTable().element ? (cell.getTable().element.closest('.tab-pane') || cell.getTable().element.closest('.view-container')) : null;
                    const dddwMap = (pane && pane._dddwOptionsMap) || window.dddwOptionsMap;
                    if (dddwMap) {
                        const dddwLabel = window.f_dddwctl.getLabel(dddwMap, field, val);
                        if (dddwLabel && dddwLabel !== String(val)) return dddwLabel;
                    }
                } catch(e) {}
            }

            // 4. 행 데이터에서 별칭/명칭 필드 확인 (예: seriesGbNm, mgNm, typeGbNm, xx_ 등)
            if (rowData) {
                const candidates = [
                    rowData[field + 'Nm'],
                    rowData[field + '_nm'],
                    rowData[field + 'Name'],
                    rowData['xx_' + field],
                    rowData['xx' + field.charAt(0).toUpperCase() + field.slice(1)]
                ];
                for (let c of candidates) {
                    if (c != null && String(c).trim() !== '') return String(c).trim();
                }
            }

            return (val !== undefined && val !== null) ? String(val) : "";
        }

        // 2. cellEditing Hook: Active Editor Tracking & DDDW/List 기존 값 표시 보존
        table.on("cellEditing", function(cell) {
            if (!cell) return;
            const r = (typeof cell.getRow === 'function') ? cell.getRow() : null;
            if (r) doSelect(r);

            const colDef = cell.getColumn().getDefinition();
            const isListEditor = (colDef.editor === "list" || (typeof colDef.editor === 'string' && colDef.editor.includes('list')) || (colDef.editorParams && (colDef.editorParams.values || colDef.editorParams.valuesLookup)));

            function applyDropdownPreservation() {
                const cellEl = (typeof cell.getElement === 'function') ? cell.getElement() : null;
                if (!cellEl) return;

                const input = cellEl.querySelector("input, textarea, select");
                if (input) {
                    AamsFocusManager.markActive(table, null, cell.getField(), r, input);
                }

                if (isListEditor) {
                    const displayLabel = getCellDisplayLabel(cell);
                    const rawVal = cell.getValue();

                    if (input && displayLabel) {
                        // input이 비어있거나 변경 전인 경우 기존 표시 라벨 주입
                        if (!input.value || input.value === String(rawVal)) {
                            input.value = displayLabel;
                        }
                        input.placeholder = displayLabel;
                        input.setAttribute("data-original-val", (rawVal !== undefined && rawVal !== null) ? String(rawVal) : "");
                        input.setAttribute("data-original-label", displayLabel);
                    }

                    // 셀 우측에 작은 드롭다운 화살표(▼) 표시
                    if (!cellEl.querySelector(".aams-dddw-arrow")) {
                        const arrow = document.createElement("span");
                        arrow.className = "aams-dddw-arrow";
                        arrow.innerHTML = "&#9660;";
                        cellEl.appendChild(arrow);
                    }

                    // 드롭다운 팝업 리스트(.tabulator-edit-list) 열릴 때 기존 값 항목 active 하이라이트 & 스크롤 안착
                    const editLists = document.querySelectorAll(".tabulator-edit-list");
                    editLists.forEach(function(listEl) {
                        if (listEl && listEl.style.display !== 'none') {
                            const items = listEl.querySelectorAll(".tabulator-edit-list-item");
                            let matchedItem = null;
                            items.forEach(function(item) {
                                const itemText = (item.textContent || '').trim();
                                const itemVal = item.dataset.value;
                                if (itemVal != null && rawVal != null && String(itemVal).trim() === String(rawVal).trim()) {
                                    matchedItem = item;
                                } else if (displayLabel && (itemText === displayLabel || itemText.includes(displayLabel))) {
                                    if (!matchedItem) matchedItem = item;
                                }
                            });

                            if (matchedItem) {
                                items.forEach(it => it.classList.remove("active"));
                                matchedItem.classList.add("active");
                                try { matchedItem.scrollIntoView({ block: "nearest" }); } catch(e) {}
                            }
                        }
                    });
                }
            }

            // Tabulator의 에디터 DOM 생성 시점에 맞춰 즉시 + 지연(15ms, 45ms) 다중 실행으로 누락 방지
            applyDropdownPreservation();
            setTimeout(applyDropdownPreservation, 15);
            setTimeout(applyDropdownPreservation, 45);
        });

        table.on("cellEdited", function(cell) {
            if (cell && typeof cell.getElement === 'function') {
                const cellEl = cell.getElement();
                if (cellEl) {
                    const arrow = cellEl.querySelector(".aams-dddw-arrow");
                    if (arrow) arrow.remove();
                    AamsFocusManager.markActive(table, null, cell.getField(), cell.getRow());
                }
            }
        });

        table.on("cellEditCancelled", function(cell) {
            if (cell && typeof cell.getElement === 'function') {
                const cellEl = cell.getElement();
                if (cellEl) {
                    const arrow = cellEl.querySelector(".aams-dddw-arrow");
                    if (arrow) arrow.remove();
                    AamsFocusManager.markActive(table, null, cell.getField(), cell.getRow());
                }
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
            lastSelectedRowKey = null;
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

                            // [Master-Detail Focus Preservation]
                            // 서브 그리드 데이터 로드 후 상위 마스터 그리드의 클릭 셀 포커스 복원
                            if (AamsFocusManager.activeGrid && AamsFocusManager.activeGrid !== table) {
                                AamsFocusManager.restoreFocus();
                            }
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

        // 6. 단일 행 선택 모드(selectable: 1 / selectableRows: 1) 전역 다중 선택 방지 안전망
        // 실시간 검색 필터링(setFilter), 필터 해제(clearFilter), 외부 row.select() 호출 등으로 인해
        // 2개 이상의 행이 동시에 selected 상태로 남는 현상을 원천 차단
        let isEnforcingSingleSelect = false;
        function enforceSingleSelection(preferredRow) {
            if (isEnforcingSingleSelect) return;
            const isSingle = (table.options.selectableRows === 1 || table.options.selectable === 1);
            if (!isSingle) return;

            try {
                isEnforcingSingleSelect = true;
                const selected = (typeof table.getSelectedRows === 'function') ? table.getSelectedRows() : [];
                if (selected && selected.length > 1) {
                    const targetKeep = (preferredRow && selected.includes(preferredRow))
                        ? preferredRow
                        : selected[selected.length - 1]; // 가장 최근 선택 행 유지
                    selected.forEach(r => {
                        if (r !== targetKeep && typeof r.deselect === 'function') {
                            r.deselect();
                        }
                    });
                }
            } catch (e) {
                console.warn("[AAMS RowSelection] Error enforcing single selection:", e);
            } finally {
                isEnforcingSingleSelect = false;
            }
        }

        table.on("rowSelected", function(row) {
            enforceSingleSelection(row);
        });

        table.on("dataFiltered", function(filters, rows) {
            enforceSingleSelection();
        });

        table.on("rowSelectionChanged", function(data, rows) {
            const isSingle = (table.options.selectableRows === 1 || table.options.selectable === 1);
            if (isSingle && rows && rows.length > 1) {
                enforceSingleSelection(rows[rows.length - 1]);
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
        const table = cell.getTable();
        const row = cell.getRow();
        const cellEl = (typeof cell.getElement === 'function') ? cell.getElement() : null;

        if (row && typeof row.select === 'function' && !row.isSelected()) {
            if (table && typeof table.deselectRow === 'function') {
                table.deselectRow();
            }
            row.select();

            // 행 선택 변경에 따른 DOM 갱신 및 마우스 이벤트 버블링 완료 후 에디터 안전 진입
            setTimeout(function() {
                try {
                    if (typeof cell.edit === 'function') {
                        cell.edit();
                        if (cellEl) {
                            const input = cellEl.querySelector("input, textarea, select");
                            if (input) {
                                AamsFocusManager.markActive(table, null, cell.getField(), row, input);
                                input.focus();
                            }
                        }
                    }
                } catch(err) {}
            }, 30);
            return;
        }
    } catch(err) {}

    if (typeof cell.edit === 'function') {
        cell.edit();
        try {
            const cellEl = (typeof cell.getElement === 'function') ? cell.getElement() : null;
            if (cellEl) {
                const input = cellEl.querySelector("input, textarea, select");
                if (input) {
                    const table = cell.getTable();
                    const row = cell.getRow();
                    AamsFocusManager.markActive(table, null, cell.getField(), row, input);
                    input.focus();
                }
            }
        } catch(e) {}
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

    // Tabulator editor: "list" (하드코딩 및 동적 DDDW) 타입 불일치 방지 및 기존 값 보존 정규화
    function processColumnsListEditor(columns) {
        if (!Array.isArray(columns)) return;
        columns.forEach(col => {
            if (!col) return;
            if (col.editor === "list" || (typeof col.editor === 'string' && col.editor.includes('list'))) {
                const rawParams = col.editorParams;
                col.editorParams = function(cell) {
                    let params = (typeof rawParams === 'function') ? rawParams(cell) : Object.assign({}, rawParams);
                    if (!params) params = {};

                    const cellVal = cell ? cell.getValue() : null;

                    // 1. values 배열인 경우 (하드코딩된 드롭다운: String vs Number 타입 불일치 완전 해결)
                    if (Array.isArray(params.values)) {
                        params.values = params.values.map(v => {
                            if (v == null) return v;
                            if (typeof v === 'object') {
                                const itemVal = (v.value !== undefined) ? v.value : (v.code !== undefined ? v.code : v.cd);
                                const itemLabel = (v.label !== undefined) ? v.label : (v.name !== undefined ? v.name : (v.dscr !== undefined ? v.dscr : String(itemVal)));
                                const isMatch = (cellVal !== undefined && cellVal !== null && String(itemVal).trim() === String(cellVal).trim());
                                return {
                                    label: itemLabel,
                                    value: isMatch ? cellVal : itemVal,
                                    code: isMatch ? cellVal : itemVal,
                                    name: itemLabel
                                };
                            }
                            const isMatch = (cellVal !== undefined && cellVal !== null && String(v).trim() === String(cellVal).trim());
                            return {
                                label: String(v),
                                value: isMatch ? cellVal : v
                            };
                        });
                    }

                    // 2. valuesLookup이 함수인 경우 (동적 DDDW 옵션)
                    if (typeof params.valuesLookup === 'function') {
                        const origLookup = params.valuesLookup;
                        params.valuesLookup = function(c, term) {
                            const result = origLookup(c, term);
                            if (Array.isArray(result)) {
                                return result.map(v => {
                                    if (v == null) return v;
                                    if (typeof v === 'object') {
                                        const itemVal = (v.value !== undefined) ? v.value : (v.code !== undefined ? v.code : v.cd);
                                        const itemLabel = (v.label !== undefined) ? v.label : (v.name !== undefined ? v.name : (v.dscr !== undefined ? v.dscr : String(itemVal)));
                                        const isMatch = (cellVal !== undefined && cellVal !== null && String(itemVal).trim() === String(cellVal).trim());
                                        return {
                                            label: itemLabel,
                                            value: isMatch ? cellVal : itemVal,
                                            code: isMatch ? cellVal : itemVal,
                                            name: itemLabel
                                        };
                                    }
                                    const isMatch = (cellVal !== undefined && cellVal !== null && String(v).trim() === String(cellVal).trim());
                                    return {
                                        label: String(v),
                                        value: isMatch ? cellVal : v
                                    };
                                });
                            }
                            return result;
                        };
                    }

                    // 자동완성 억제 & 빈칸 방지 기본 옵션 적용
                    if (params.autocomplete === undefined) params.autocomplete = false;
                    if (params.clearable === undefined) params.clearable = false;

                    return params;
                };
            }

            if (col.columns && Array.isArray(col.columns)) {
                processColumnsListEditor(col.columns);
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
                processColumnsListEditor(options.columns);
            }

            // Ensure default columnDefaults.vertAlign = "middle" so Tabulator natively injects justifyContent based on hozAlign
            if (!options.columnDefaults) {
                options.columnDefaults = {};
            }
            if (!options.columnDefaults.vertAlign) {
                options.columnDefaults.vertAlign = "middle";
            }

            // Default to single row selection (selectableRows: 1) if not explicitly configured
            if (options.selectableRows === undefined && options.selectable === undefined) {
                options.selectableRows = 1;
                options.selectableRowsRollingSelection = true;
            } else if ((options.selectableRows === 1 || options.selectable === 1) && options.selectableRowsRollingSelection === undefined) {
                options.selectableRowsRollingSelection = true;
            }

            // Instantiate original Tabulator
            const table = new OriginalTabulator(container, options);

            // Hook dynamic column APIs to process headerCssClass & listEditor
            const origSetColumns = table.setColumns;
            table.setColumns = function(cols) {
                if (cols) {
                    processColumnsHeaderCss(cols);
                    processColumnsListEditor(cols);
                }
                return origSetColumns.apply(table, arguments);
            };
            const origAddColumn = table.addColumn;
            table.addColumn = function(col, before, toColumn) {
                if (col) {
                    processColumnsHeaderCss([col]);
                    processColumnsListEditor([col]);
                }
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
 * AAMS Report Viewer 공통 모듈
 * (상세 구현 및 바인딩 엔진은 static/js/aams_report.js 로 완전 모듈화 분리됨)
 */

/**
 * AAMS 전역 반응형 레이아웃 & 리사이즈 유틸리티 (Responsive Layout & Resize Standard)
 * Master-Detail 및 Report 구조 전 화면 공통
 */
window.AamsResponsive = {
    // 디바운스 헬퍼
    debounce: function(func, wait) {
        var timeout;
        wait = wait || 150;
        return function() {
            var context = this, args = arguments;
            clearTimeout(timeout);
            timeout = setTimeout(function() {
                func.apply(context, args);
            }, wait);
        };
    },

    // 현재 모바일 뷰(876px 이하 또는 우측/하단 상세 패널 숨김) 여부 판별
    isMobile: function(container) {
        if (window.AamsReport && typeof window.AamsReport.isMobileView === 'function') {
            return window.AamsReport.isMobileView(container);
        }
        var c = container || (window.currentPane || document);
        var right = c.querySelector('.right-pane') || c.querySelector('.split-right') || c.querySelector('.report-card');
        if (right && window.getComputedStyle(right).display === 'none') return true;
        return window.matchMedia('(max-width: 876px)').matches || window.innerWidth <= 876 || (c.clientWidth > 0 && c.clientWidth <= 876);
    },

    // 뷰포트 모드(모바일 <-> PC)가 실제로 전환되었을 때만 1회 실행되는 안전 리스너 등록 (탭 닫힘 시 자동 파기)
    onModeChange: function(container, callback, wait) {
        var root = container || (window.currentPane || document);
        var lastMode = this.isMobile(root);
        function modeChangeHandler() {
            if (!root || (root !== document && !document.contains(root))) {
                window.removeEventListener('resize', debounced);
                return;
            }
            if (root.classList && root.classList.contains('tab-pane') && !root.classList.contains('active')) {
                return;
            }
            var currentMode = AamsResponsive.isMobile(root);
            if (lastMode !== currentMode) {
                var prev = lastMode;
                lastMode = currentMode;
                if (typeof callback === 'function') {
                    callback(currentMode, prev);
                }
            }
        }
        var debounced = this.debounce(modeChangeHandler, wait || 150);
        window.addEventListener('resize', debounced);
        return function() {
            window.removeEventListener('resize', debounced);
        };
    },

    // 디바운스된 안전한 리사이즈 이벤트 바인딩 (탭 닫힘 시 자동 파기 및 비활성 탭 가드)
    onResize: function(callback, wait, container) {
        var root = container || (window.currentPane || document);
        function innerHandler() {
            if (!root || (root !== document && !document.contains(root))) {
                window.removeEventListener('resize', debounced);
                return;
            }
            if (root.classList && root.classList.contains('tab-pane') && !root.classList.contains('active')) {
                return;
            }
            if (typeof callback === 'function') {
                callback();
            }
        }
        var debounced = this.debounce(innerHandler, wait || 150);
        window.addEventListener('resize', debounced);
        return function() {
            window.removeEventListener('resize', debounced);
        };
    },

    // 화면 내 그리드 자동 redraw 및 탭 닫힘 시 자동 파기 헬퍼 (모든 MDI 화면 공통)
    bindGridResize: function(pane, grids, onResizeCallback) {
        var root = pane || (window.currentPane || document);
        var timer = null;
        var gridList = Array.isArray(grids) ? grids : [grids];
        function resizeHandler() {
            if (!root || (root !== document && !document.contains(root))) {
                window.removeEventListener('resize', resizeHandler);
                return;
            }
            if (root.classList && root.classList.contains('tab-pane') && !root.classList.contains('active')) {
                return;
            }
            clearTimeout(timer);
            timer = setTimeout(function() {
                gridList.forEach(function(g) {
                    var actualGrid = (typeof g === 'function') ? g() : g;
                    if (actualGrid && typeof actualGrid.redraw === 'function') {
                        actualGrid.redraw();
                    }
                });
                if (typeof onResizeCallback === 'function') {
                    onResizeCallback();
                }
            }, 120);
        }
        window.addEventListener('resize', resizeHandler);
        return resizeHandler;
    }
};
window.isMobileView = function(root) {
    if (window.AamsReport && typeof window.AamsReport.isMobileView === 'function') {
        return window.AamsReport.isMobileView(root);
    }
    return window.AamsResponsive ? window.AamsResponsive.isMobile(root) : (window.innerWidth <= 876);
};

/**
 * AAMS Tabulator Grid CUD Change Buffer Manager (전역 공통 표준)
 * 규칙:
 * 1. insert, update 내용을 우선 큐(Map)를 만들어서 관리한다.
 * 2. 신규행(isNew)에 대한 delete일 경우 insert 큐에서 지우고 delete 큐에는 넣지 않는다.
 * 3. update를 한 행을 delete하는 경우 update 큐에서 지우고 delete 큐에만 넣는다.
 * 4. 새로고침을 하거나 재조회를 할 경우 이 큐를 reset해서 초기 상태로 되돌린다.
 */
window.AamsCudManager = {
    create: function(grid, options) {
        options = options || {};
        const keyField = options.keyField || '_rowId';
        let rowIdCounter = 1;

        const insertMap = new Map();
        const updateMap = new Map();
        const deleteMap = new Map();

        function assignRowId(item, isNew) {
            if (!item) return item;
            if (!item[keyField]) {
                item[keyField] = 'row_' + Date.now() + '_' + (rowIdCounter++);
            }
            if (isNew !== undefined) {
                item.isNew = !!isNew;
            }
            if (!item.isNew && item.isUpdated === undefined) {
                item.isUpdated = false;
            }
            return item;
        }

        function formatData(dataList) {
            reset();
            return (Array.isArray(dataList) ? dataList : []).map(function(item) {
                return assignRowId(Object.assign({}, item), false);
            });
        }

        function createNewRow(initialValues) {
            const rowData = assignRowId(Object.assign({}, initialValues || {}), true);
            insertMap.set(rowData[keyField], rowData);
            return rowData;
        }

        function trackChange(rowOrData) {
            const data = (rowOrData && typeof rowOrData.getData === 'function') ? rowOrData.getData() : rowOrData;
            if (!data || !data[keyField]) return;

            if (data.isNew) {
                insertMap.set(data[keyField], data);
            } else {
                data.isUpdated = true;
                if (rowOrData && typeof rowOrData.update === 'function') {
                    rowOrData.update({ isUpdated: true });
                }
                updateMap.set(data[keyField], data);
            }
        }

        function deleteRow(rowOrData) {
            const row = (rowOrData && typeof rowOrData.getData === 'function') ? rowOrData : null;
            const data = row ? row.getData() : (rowOrData || {});
            const key = data[keyField];

            // 2. 신규행 삭제: insert 큐에서 제거
            if (data.isNew) {
                if (key) insertMap.delete(key);
            } else {
                // 3. update된 행 삭제: update 큐에서 제거하고 delete 큐에만 등록
                if (key) updateMap.delete(key);
                if (key) deleteMap.set(key, data);
            }

            if (row && typeof row.delete === 'function') {
                return row.delete();
            }
            return Promise.resolve();
        }

        function reset() {
            insertMap.clear();
            updateMap.clear();
            deleteMap.clear();
        }

        function addRow(initialValues, position) {
            const rowData = createNewRow(initialValues);
            if (grid && typeof grid.addRow === 'function') {
                return grid.addRow(rowData, position !== undefined ? position : true);
            }
            return Promise.resolve(null);
        }

        function getChanges(opts) {
            opts = opts || {};
            const clean = opts.clean !== false; // 기본값: true (화이트리스트 정제 적용)
            const extraFields = opts.extraAllowedFields || options.allowedFields;

            const rawInserts = Array.from(insertMap.values());
            const rawUpdates = Array.from(updateMap.values());
            const rawDeletes = Array.from(deleteMap.values());

            const sanitize = function(list) {
                if (!clean) return list;
                return list.map(function(item) {
                    return window.sanitizeGridRowData ? window.sanitizeGridRowData(grid, item, extraFields) : item;
                });
            };

            const inserts = sanitize(rawInserts);
            const updates = sanitize(rawUpdates);
            const deletes = sanitize(rawDeletes);

            return {
                inserts: inserts,
                updates: updates,
                deletes: deletes,
                insertList: inserts,
                updateList: updates,
                deleteList: deletes,
                itemList: inserts.concat(updates),
                deletedList: deletes,
                hasChanges: (rawInserts.length > 0 || rawUpdates.length > 0 || rawDeletes.length > 0),
                count: rawInserts.length + rawUpdates.length + rawDeletes.length,
                raw: {
                    inserts: rawInserts,
                    updates: rawUpdates,
                    deletes: rawDeletes
                }
            };
        }

        const manager = {
            keyField: keyField,
            assignRowId: assignRowId,
            formatData: formatData,
            createNewRow: createNewRow,
            addRow: addRow,
            trackChange: trackChange,
            deleteRow: deleteRow,
            reset: reset,
            getChanges: getChanges
        };

        if (grid) {
            grid._cudManager = manager;
            if (typeof grid.on === 'function') {
                grid.on("cellEdited", function(cell) {
                    trackChange(cell.getRow());
                });
            }
        }

        manager.insertMap = insertMap;
        manager.updateMap = updateMap;
        manager.deleteMap = deleteMap;

        return manager;
    }
};

/**
 * Tabulator 그리드의 컬럼 정의 및 필수 상태값을 기반으로 화이트리스트 필터링을 수행하여
 * DTO/테이블에 없는 내부 메타데이터(_rowId 등) 및 임의의 가상 속성을 안전하게 제거합니다.
 * @param {Object} grid - Tabulator Grid 인스턴스 (선택)
 * @param {Object} rowData - 단일 행 데이터 객체
 * @param {Array<string>} extraAllowedFields - 추가 허용 필드 목록 (선택)
 * @returns {Object} 화이트리스트 필터링된 깨끗한 데이터 객체
 */
window.sanitizeGridRowData = function(grid, rowData, extraAllowedFields) {
    if (!rowData || typeof rowData !== 'object') return rowData;

    // 1. 화이트리스트 Set 구성
    const allowed = new Set();

    // 그리드의 실제 컬럼 정의에서 field 명칭 수집
    if (grid && typeof grid.getColumns === 'function') {
        try {
            const cols = grid.getColumns();
            if (Array.isArray(cols)) {
                cols.forEach(function(col) {
                    const def = col.getDefinition ? col.getDefinition() : null;
                    const field = (def && def.field) ? def.field : (typeof col.getField === 'function' ? col.getField() : null);
                    if (field && typeof field === 'string' && !field.startsWith('_')) {
                        allowed.add(field);
                    }
                });
            }
        } catch (e) {
            console.warn('[sanitizeGridRowData] failed to inspect columns:', e);
        }
    }

    // 기본 시스템/상태 및 공통 키 필드 허용
    const standardFields = ['corpGr', 'isNew', 'isUpdated', 'rowStatus', 'rowNum', 'fseq', 'saveVisible'];
    standardFields.forEach(function(f) { allowed.add(f); });

    // 사용자가 명시적으로 전달한 추가 허용 필드 등록
    if (Array.isArray(extraAllowedFields)) {
        extraAllowedFields.forEach(function(f) {
            if (f && typeof f === 'string') allowed.add(f);
        });
    }

    // 만약 그리드 컬럼 정보를 얻지 못한 경우: 언더스코어(_)로 시작하는 내부 메타데이터만 제거하여 반환
    if (allowed.size <= standardFields.length) {
        const fallbackClean = {};
        for (const key of Object.keys(rowData)) {
            if (!key.startsWith('_')) {
                fallbackClean[key] = rowData[key];
            }
        }
        return fallbackClean;
    }

    // 화이트리스트에 부합하는 프로퍼티만 새 객체로 복사
    const cleanData = {};
    for (const key of Object.keys(rowData)) {
        if (allowed.has(key)) {
            cleanData[key] = rowData[key];
        }
    }
    return cleanData;
};

/**
 * 그리드 데이터 목록(배열 또는 단일 객체)을 일괄 화이트리스트 정제합니다.
 */
window.sanitizeGridData = function(grid, dataList, extraAllowedFields) {
    if (!dataList) return dataList;
    if (Array.isArray(dataList)) {
        return dataList.map(function(item) {
            return window.sanitizeGridRowData(grid, item, extraAllowedFields);
        });
    }
    return window.sanitizeGridRowData(grid, dataList, extraAllowedFields);
};

/**
 * 전역 API 호출(fetch) 인터셉터
 * 현재 활성화된 화면의 프로그램 번호(X-Pgm-No) 및 화면 ID(X-Pgm-Id)를
 * 모든 API 요청 헤더에 자동으로 부착하여 서버 에러 발생 시 정확한 화면을 추적할 수 있도록 지원합니다.
 */
(function() {
    if (window._aamsFetchIntercepted) return;
    window._aamsFetchIntercepted = true;

    var originalFetch = window.fetch;
    window.fetch = function(input, init) {
        init = init || {};
        var headers = new Headers(init.headers || {});

        try {
            var activeTabKey = window.tabManager ? window.tabManager.activeTabKey : null;
            var activeTab = (window.tabManager && Array.isArray(window.tabManager.openTabs))
                ? window.tabManager.openTabs.find(function(t) { return t.tabKey === activeTabKey || t.pgmNo === activeTabKey; })
                : null;
            var activePane = document.querySelector('.tab-pane.active') || window.currentPane;

            var pgmNo = (activeTab && activeTab.pgmNo) || (activePane && activePane.getAttribute('data-pgm-no')) || window.g_currentPgmNo || '';
            var pgmId = (activeTab && activeTab.pgmId) || (activePane && activePane.getAttribute('data-pgm-id')) || '';

            if (pgmNo && !headers.has('X-Pgm-No')) {
                headers.set('X-Pgm-No', pgmNo);
            }
            if (pgmId && !headers.has('X-Pgm-Id')) {
                headers.set('X-Pgm-Id', pgmId);
            }
        } catch (e) {
            // 헤더 자동 부착 중 예외 발생 시 요청 흐름 방해하지 않음
        }

        init.headers = headers;
        return originalFetch.call(this, input, init);
    };
})();

/**
 * ============================================================================
 * AAMS Crownix MRD Report Viewer & Export Module (Dual Fallback Safety Net)
 * ----------------------------------------------------------------------------
 * aams_report.js와 완전 동기화된 안전망 엔진.
 * 서버 배포 시 브라우저 캐시 지연 또는 스크립트 로드 순서 문제 시에도
 * 어디서나 reportViewer 및 AamsReport가 100% 정상 참조되도록 보장합니다.
 * ============================================================================
 */
(function(window) {
    'use strict';
    if (window.AamsReport && typeof window.AamsReport.bindViewer === 'function') {
        return;
    }

    var AamsReport = {
        DEFAULT_ZOOM: 120,

        buildPreviewUrl: function(mrdName, params, options) {
            options = options || {};
            var qs = ['mrdName=' + encodeURIComponent(mrdName)];
            if (options.corpGr) qs.push('corpGr=' + encodeURIComponent(options.corpGr));
            if (options.downloadName) qs.push('downloadName=' + encodeURIComponent(options.downloadName));
            if (options.timestamp !== false) qs.push('t=' + new Date().getTime());

            // 모바일 환경(너비 <= 876px 또는 모바일 디바이스)일 때 M2soft HTML5 뷰어 모드(format=html) 자동 적용
            var isMobile = (options.isMobile !== undefined) ? options.isMobile : this.isMobileView(options.rootPane);
            var reqFormat = options.format || (isMobile ? 'html' : 'pdf');
            if (reqFormat) qs.push('format=' + encodeURIComponent(reqFormat));

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

        formatPreviewUrl: function(url, zoom) {
            if (!url || url === 'about:blank') return url || '';
            var cleanUrl = url.split('#')[0];
            // HTML 포맷 미리보기의 경우 PDF 전용 해시 파라미터 제외
            if (/format=html/i.test(cleanUrl) || /format=htm/i.test(cleanUrl)) {
                return cleanUrl;
            }
            if (zoom === 'fit' || zoom === 'page-fit' || zoom === 'Fit') {
                return cleanUrl + '#toolbar=1&navpanes=0&view=Fit';
            }
            if (zoom === 'width' || zoom === 'page-width' || zoom === 'FitH') {
                return cleanUrl + '#toolbar=1&navpanes=0&view=FitH';
            }
            var targetZoom = (zoom !== undefined && zoom !== null) ? zoom : this.DEFAULT_ZOOM;
            return cleanUrl + '#toolbar=1&navpanes=0&zoom=' + encodeURIComponent(targetZoom);
        },

        isMobileView: function(rootPane) {
            var root = rootPane || (window.currentPane || document);
            var right = (root && root.querySelector) ? (root.querySelector('.split-right') || root.querySelector('.report-card') || root.querySelector('.pane-right')) : null;
            if (right && window.getComputedStyle(right).display === 'none') {
                return true;
            }
            var width = (root && root.clientWidth > 0) ? root.clientWidth : window.innerWidth;
            return width <= 876;
        },

        setFrameSrc: function(frameEl, url, zoom) {
            if (!frameEl) return;
            if (!url || url === 'about:blank') {
                frameEl.src = 'about:blank';
                return;
            }
            frameEl.src = this.formatPreviewUrl(url, zoom);
        },

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
            var lastLoadedKey = null;

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
                if (typeof window.resolveCorpGr === 'function') return window.resolveCorpGr(root);
                return '';
            }

            function resolveDataKey(data) {
                if (!data) return '';
                var corp = resolveCorp();
                var ymd = (typeof config.getYmd === 'function') ? config.getYmd() : (typeof window.resolveFilterYmd === 'function' ? window.resolveFilterYmd(root) : '');
                var id = data.fundCd || data.fund_cd || data.id || data.mainKey || data.code || '';
                if (id) {
                    return corp + '_' + ymd + '_' + id;
                }
                try {
                    return corp + '_' + ymd + '_' + JSON.stringify(resolveParams(data));
                } catch (e) {
                    return String(data);
                }
            }

            function showLoading(show) {
                if (loadingEl) loadingEl.style.display = show ? 'block' : 'none';
                if (modalLoadingEl) modalLoadingEl.style.display = show ? 'block' : 'none';
            }

            function updateStatus(text) {
                if (statusEl) statusEl.textContent = text || '';
                if (typeof config.onStatusChange === 'function') config.onStatusChange(selectedData, text);
            }

            function load(data, statusText, isForce) {
                if (!data) return;
                selectedData = data;
                
                var dataKey = resolveDataKey(data);
                var isAlreadyLoaded = (lastLoadedKey === dataKey) && iframe && iframe.src && iframe.src !== 'about:blank' && !iframe.src.endsWith('about:blank');

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

                if (isAlreadyLoaded && !isForce) {
                    return;
                }
                lastLoadedKey = dataKey;

                if (typeof config.onBeforePreview === 'function') {
                    config.onBeforePreview(data);
                }

                var mrd = resolveMrd(data);
                var params = resolveParams(data);
                var isMobile = AamsReport.isMobileView(root);
                var previewUrl = (typeof config.buildPreviewUrl === 'function')
                    ? config.buildPreviewUrl(data, params)
                    : (mrd ? AamsReport.buildPreviewUrl(mrd, params, {
                        corpGr: resolveCorp(),
                        zoom: config.zoom,
                        isMobile: isMobile,
                        rootPane: root
                    }) : null);
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
                lastLoadedKey = null;
                updateStatus(config.defaultStatus || '선택된 항목 없음');
                if (iframe) AamsReport.setFrameSrc(iframe, 'about:blank');
                if (modalIframe) AamsReport.setFrameSrc(modalIframe, 'about:blank');
                showLoading(false);
            }

            function exportReport(format) {
                if (!selectedData) {
                    if (typeof window.showToast === 'function') window.showToast('내보낼 항목을 먼저 선택해주세요.', 'warning');
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
                    if (typeof window.showToast === 'function') window.showToast('조회할 항목을 먼저 선택해주세요.', 'warning');
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
                if (modalIframe && selectedData) {
                    var mrd = resolveMrd(selectedData);
                    var params = resolveParams(selectedData);
                    var modalZoom = (config.mobileZoom !== undefined) ? config.mobileZoom : (config.zoom !== undefined ? config.zoom : AamsReport.DEFAULT_ZOOM);
                    var url = (typeof config.buildPreviewUrl === 'function')
                        ? config.buildPreviewUrl(selectedData, params)
                        : AamsReport.buildPreviewUrl(mrd, params, {
                            corpGr: resolveCorp(),
                            zoom: modalZoom,
                            isMobile: true,
                            format: 'html',
                            rootPane: root
                        });
                    showLoading(true);
                    modalIframe.onload = function() { showLoading(false); };
                    AamsReport.setFrameSrc(modalIframe, url, modalZoom);
                }
            }

            function closeModal() {
                if (modalEl) modalEl.style.display = 'none';
                if (modalIframe) AamsReport.setFrameSrc(modalIframe, 'about:blank');
            }

            var exportBtns = root.querySelectorAll('.btn-export-format, .export-btn, [data-format]');
            exportBtns.forEach(function(btn) {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    var fmt = btn.getAttribute('data-format');
                    if (fmt) exportReport(fmt);
                });
            });

            if (btnOpenNewWindow) {
                btnOpenNewWindow.addEventListener('click', function(e) {
                    e.preventDefault();
                    openNewWindow();
                });
            }

            if (btnCloseModal) {
                btnCloseModal.addEventListener('click', closeModal);
            }
            if (modalEl && typeof window.setupModalBackdrop === 'function') {
                window.setupModalBackdrop(modalEl, closeModal);
            }

            var lastIsMobile = AamsReport.isMobileView(root);
            var autoResizeTimer = null;

            function smartResizeHandler() {
                if (root && root !== document && !document.contains(root)) {
                    window.removeEventListener('resize', debouncedResize);
                    return;
                }
                if (root && root.classList && root.classList.contains('tab-pane') && !root.classList.contains('active')) {
                    return;
                }

                var targetGrid = (typeof config.grid === 'function') ? config.grid() : (config.grid || (typeof config.getGrid === 'function' ? config.getGrid() : null));
                if (targetGrid && typeof targetGrid.redraw === 'function') {
                    targetGrid.redraw();
                }

                var currentIsMobile = AamsReport.isMobileView(root);
                if (lastIsMobile !== currentIsMobile) {
                    lastIsMobile = currentIsMobile;
                    if (!currentIsMobile) {
                        closeModal();
                        if (selectedData && iframe) {
                            load(selectedData, null, true);
                        }
                    }
                }
            }

            function debouncedResize() {
                clearTimeout(autoResizeTimer);
                autoResizeTimer = setTimeout(smartResizeHandler, 120);
            }

            window.addEventListener('resize', debouncedResize);

            var viewerInstance = {
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
                syncResize: smartResizeHandler,
                getSelectedData: function() { return selectedData; },
                setSelectedData: function(d) { selectedData = d; },
                destroy: function() {
                    window.removeEventListener('resize', debouncedResize);
                    clear();
                }
            };

            if (root && typeof root === 'object') {
                root._aamsReportViewer = viewerInstance;
            }

            return viewerInstance;
        }
    };

    window.AamsReport = AamsReport;

})(window);

/**
 * ============================================================================
 * AAMS WorkDate Synchronization & Stale Notice Manager
 * ----------------------------------------------------------------------------
 * W_JA010A 화면에서 회사 작업일자(Hyun_ymd / JunYong_ymd) 저장 시,
 * 열려 있는 다른 업무 탭들의 날짜 동기화 질의 및 알림 표시/해제를 총괄 관리합니다.
 * ============================================================================
 */
(function(window) {
    'use strict';

    var WorkDateSyncManager = {
        /**
         * W_JA010A를 제외한 현재 열려 있는 탭 목록 반환
         */
        getOtherOpenTabs: function() {
            if (!window.tabManager || !Array.isArray(window.tabManager.openTabs)) return [];
            return window.tabManager.openTabs.filter(function(t) {
                var id = (t.pgmId || t.tabKey || t.pgmGo || "").toUpperCase();
                return id !== "W_JA010A" && id !== "JA010A";
            });
        },

        /**
         * W_JA010A 저장 시 열려 있는 다른 탭 확인 및 질의 모달 표출
         * @param {Object} opts
         *   - workDateMap: { corpGr: targetYmd }
         *   - onSave: function(resultOpts) { ... }
         *   - onCancel: function() { ... }
         */
        promptAndSave: function(opts) {
            opts = opts || {};
            var onSave = opts.onSave || function() {};
            var onCancel = opts.onCancel || function() {};
            var workDateMap = opts.workDateMap || {};

            var otherTabs = this.getOtherOpenTabs();
            // 1. 열려 있는 다른 탭이 없으면 즉시 저장
            if (otherTabs.length === 0) {
                onSave({ syncTabs: false, otherTabs: [], workDateMap: workDateMap });
                return;
            }

            // 2. 다른 탭이 있으면 사용자 질의 모달 팝업
            this.openConfirmModal({
                otherCount: otherTabs.length,
                onSyncAndSave: function() {
                    onSave({ syncTabs: true, otherTabs: otherTabs, workDateMap: workDateMap });
                },
                onSaveOnly: function() {
                    onSave({ syncTabs: false, otherTabs: otherTabs, workDateMap: workDateMap });
                },
                onCancel: onCancel
            });
        },

        /**
         * 작업일자 동기화 확인 모달 렌더링
         */
        openConfirmModal: function(config) {
            var self = this;
            self.closeModal();

            var backdrop = document.createElement('div');
            backdrop.className = 'aams-sync-modal-backdrop';
            backdrop.id = 'aamsSyncConfirmModal';

            var otherCount = config.otherCount || 0;

            backdrop.innerHTML = 
                '<div class="aams-sync-modal-box">' +
                    '<div class="aams-sync-modal-header">' +
                        '<h4><i class="fa-solid fa-calendar-days" style="color: #2563eb;"></i> 작업일자 동기화 확인</h4>' +
                        '<button type="button" class="btn-close-sync" id="btnSyncModalClose">&times;</button>' +
                    '</div>' +
                    '<div class="aams-sync-modal-body">' +
                        '<p style="margin-bottom: 12px; font-size: 14px; font-weight: 600; color: #0f172a; line-height: 1.5;">' +
                            '<strong style="color: #2563eb; font-size: 15px; text-decoration: underline;">전체</strong> 탭들에 각 고객사가 사용하는 작업일자를 동기화하시겠습니까?' +
                        '</p>' +
                        '<div style="font-size: 12px; color: #475569; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; padding: 10px 12px; line-height: 1.6;">' +
                            '<div style="margin-bottom: 4px; font-weight: 600; color: #334155;">' +
                                '<i class="fa-solid fa-circle-info" style="color: #3b82f6; margin-right: 4px;"></i>' +
                                '현재 <span style="color: #2563eb; font-weight: 700;">' + otherCount + '개</span>의 다른 업무 화면 탭이 열려 있습니다.' +
                            '</div>' +
                            '• <strong>[동기화 및 저장]</strong>: 열려 있는 모든 화면의 기준일자가 새 작업일자로 즉시 변경되며 저장되지 않은 화면의 내용은 저장되지 않습니다.<br/>' +
                            '• <strong>[동기화 없이 저장]</strong>: 작업일자는 저장되지만 기존 화면의 기준일자는 유지되며, 탭 및 날짜 필터에 알림 표시(🟠)가 부착됩니다.' +
                        '</div>' +
                    '</div>' +
                    '<div class="aams-sync-modal-footer">' +
                        '<button type="button" class="btn btn-secondary btn-sm" id="btnSyncCancel" style="padding: 6px 12px; font-size: 12px;">취소</button>' +
                        '<button type="button" class="btn btn-warning btn-sm" id="btnSyncSaveOnly" style="padding: 6px 12px; font-size: 12px; background: #f59e0b; border-color: #f59e0b; color: #fff;">동기화 없이 저장</button>' +
                        '<button type="button" class="btn btn-primary btn-sm" id="btnSyncAndSave" style="padding: 6px 14px; font-size: 12px; font-weight: 600; background: #2563eb; border-color: #2563eb; color: #fff;">동기화 및 저장</button>' +
                    '</div>' +
                '</div>';

            document.body.appendChild(backdrop);

            function dismiss(callback) {
                self.closeModal();
                if (typeof callback === 'function') callback();
            }

            var btnClose = backdrop.querySelector('#btnSyncModalClose');
            var btnCancel = backdrop.querySelector('#btnSyncCancel');
            var btnSaveOnly = backdrop.querySelector('#btnSyncSaveOnly');
            var btnAndSave = backdrop.querySelector('#btnSyncAndSave');

            if (btnClose) btnClose.onclick = function() { dismiss(config.onCancel); };
            if (btnCancel) btnCancel.onclick = function() { dismiss(config.onCancel); };
            if (btnSaveOnly) btnSaveOnly.onclick = function() { dismiss(config.onSaveOnly); };
            if (btnAndSave) btnAndSave.onclick = function() { dismiss(config.onSyncAndSave); };
        },

        closeModal: function() {
            var el = document.getElementById('aamsSyncConfirmModal');
            if (el) el.remove();
        },

        /**
         * 작업일자 맵을 메모리 및 sessionStorage에 보관
         */
        saveWorkDateMap: function(workDateMap) {
            if (!workDateMap || typeof workDateMap !== 'object') return;
            window.g_workDateMap = Object.assign({}, window.g_workDateMap || {}, workDateMap);
            try {
                var existing = {};
                try { existing = JSON.parse(sessionStorage.getItem('aams_work_dates') || '{}'); } catch(e) {}
                var merged = Object.assign({}, existing, workDateMap);
                sessionStorage.setItem('aams_work_dates', JSON.stringify(merged));
                // localStorage stale 캐시 제거
                localStorage.removeItem('aams_work_dates');
            } catch (err) {
                console.warn("[WorkDateSyncManager] Failed to persist workDateMap to sessionStorage:", err);
            }
        },

        /**
         * 회사그룹별 최신 작업일자 조회 (메모리 -> sessionStorage -> 현재세션 workDate)
         */
        getWorkDate: function(corpGr) {
            corpGr = (corpGr || "").trim();
            if (window.g_workDateMap && corpGr && window.g_workDateMap[corpGr]) {
                return window.g_workDateMap[corpGr];
            }
            try {
                var stored = JSON.parse(sessionStorage.getItem('aams_work_dates') || '{}');
                if (stored && corpGr && stored[corpGr]) {
                    if (!window.g_workDateMap) window.g_workDateMap = {};
                    window.g_workDateMap[corpGr] = stored[corpGr];
                    return stored[corpGr];
                }
                var sessionWorkDate = sessionStorage.getItem('workDate');
                var sessionCorpGr = sessionStorage.getItem('corpGr');
                if (sessionWorkDate && (!corpGr || corpGr === sessionCorpGr)) {
                    return sessionWorkDate;
                }
            } catch (e) {}
            return window.currentWorkDate || '';
        },

        /**
         * 특정 탭 컨테이너의 기준일자 인풋을 최신 작업일자로 동기화
         */
        syncPane: function(pane, corpGr) {
            if (!pane) return;
            var targetCorp = corpGr || this.detectCorpGr(pane);
            var targetYmd = this.getWorkDate(targetCorp);
            if (!targetYmd) return;

            var dateInputs = this.findDateInputs(pane);
            dateInputs.forEach(function(input) {
                if (input) {
                    input.value = targetYmd;
                    if (input._flatpickr && typeof input._flatpickr.setDate === 'function') {
                        input._flatpickr.setDate(targetYmd, false);
                    }
                }
            });
        },

        /**
         * 열려 있는 다른 모든 탭의 날짜를 동기화
         */
        syncAllTabs: function(workDateMap, otherTabs) {
            var self = this;
            if (!otherTabs || !Array.isArray(otherTabs)) {
                otherTabs = self.getOtherOpenTabs();
            }
            workDateMap = workDateMap || {};
            self.saveWorkDateMap(workDateMap);

            var syncedCount = 0;
            otherTabs.forEach(function(tab) {
                var tabKey = tab.tabKey || tab.pgmNo;
                var pane = document.getElementById('tab-pane-' + tabKey);
                if (!pane) return;

                var corpGr = self.detectCorpGr(pane);
                var targetYmd = workDateMap[corpGr] || workDateMap['2402'];
                if (!targetYmd) {
                    var keys = Object.keys(workDateMap);
                    if (keys.length > 0) targetYmd = workDateMap[keys[0]];
                }
                if (!targetYmd) return;

                var dateInputs = self.findDateInputs(pane);
                dateInputs.forEach(function(input) {
                    input.value = targetYmd;
                    if (input._flatpickr && typeof input._flatpickr.setDate === 'function') {
                        input._flatpickr.setDate(targetYmd, false);
                    }
                });

                self.clearTabNotice(tabKey);
                syncedCount++;
            });

            if (typeof showToast === 'function') {
                showToast("열려 있는 전체 탭(" + syncedCount + "개)의 기준일자가 새 작업일자로 동기화되었습니다.", "success");
            }
        },

        /**
         * 열려 있는 다른 탭에 미동기화 알림 배지 및 인풋 칩 부착
         */
        markTabsNotice: function(workDateMap, otherTabs) {
            var self = this;
            if (!otherTabs || !Array.isArray(otherTabs)) {
                otherTabs = self.getOtherOpenTabs();
            }
            workDateMap = workDateMap || {};

            var markedCount = 0;
            otherTabs.forEach(function(tab) {
                var tabKey = tab.tabKey || tab.pgmNo;
                var pane = document.getElementById('tab-pane-' + tabKey);
                var headerItem = document.getElementById('tab-header-' + tabKey);

                var corpGr = pane ? self.detectCorpGr(pane) : '2402';
                var targetYmd = workDateMap[corpGr] || workDateMap['2402'] || '';
                if (!targetYmd) {
                    var keys = Object.keys(workDateMap);
                    if (keys.length > 0) targetYmd = workDateMap[keys[0]];
                }

                // 1) 탭 헤더 배지 부착
                if (headerItem && !headerItem.querySelector('.tab-notice-badge')) {
                    var badge = document.createElement('span');
                    badge.className = 'tab-notice-badge';
                    badge.title = '기준일자가 변경되었습니다. (' + targetYmd + ') 클릭하여 알림을 끕니다.';
                    badge.innerHTML = '<i class="fa-solid fa-triangle-exclamation"></i>';
                    badge.onclick = function(e) {
                        e.stopPropagation();
                        self.clearTabNotice(tabKey);
                    };
                    var closeBtn = headerItem.querySelector('.tab-close-btn');
                    if (closeBtn) {
                        headerItem.insertBefore(badge, closeBtn);
                    } else {
                        headerItem.appendChild(badge);
                    }
                }

                // 2) 화면 내부 기준일자 인풋에 알림 표시
                if (pane) {
                    var dateInputs = self.findDateInputs(pane);
                    dateInputs.forEach(function(input) {
                        input.classList.add('input-date-stale-notice');

                        var parent = input.parentElement;
                        if (parent && !parent.querySelector('.badge-date-stale-chip')) {
                            var chip = document.createElement('span');
                            chip.className = 'badge-date-stale-chip';
                            chip.title = '최신 작업일자(' + targetYmd + ')와 다릅니다. 클릭하여 알림 닫기';
                            chip.innerHTML = '<i class="fa-solid fa-circle-exclamation"></i> 일자 변경됨 <i class="fa-solid fa-xmark chip-close"></i>';
                            chip.onclick = function(e) {
                                e.stopPropagation();
                                self.clearTabNotice(tabKey);
                            };
                            if (input.nextSibling) {
                                parent.insertBefore(chip, input.nextSibling);
                            } else {
                                parent.appendChild(chip);
                            }
                        }

                        if (!input._hasStaleNoticeListener) {
                            input._hasStaleNoticeListener = true;
                            input.addEventListener('focus', function() { self.clearTabNotice(tabKey); }, { once: true });
                            input.addEventListener('input', function() { self.clearTabNotice(tabKey); }, { once: true });
                            input.addEventListener('change', function() { self.clearTabNotice(tabKey); }, { once: true });
                        }
                    });
                }
                markedCount++;
            });

            if (typeof showToast === 'function') {
                showToast("저장 완료. 다른 화면들의 탭 및 기준일자에 알림 표시(🟠)가 설정되었습니다.", "info");
            }
        },

        /**
         * 특정 탭의 알림 표시 제거 (알림을 없애는 수단)
         */
        clearTabNotice: function(tabKey) {
            if (!tabKey) return;

            // 1. 탭 헤더 배지 제거
            var headerItem = document.getElementById('tab-header-' + tabKey);
            if (headerItem) {
                var badge = headerItem.querySelector('.tab-notice-badge');
                if (badge) badge.remove();
            }

            // 2. 화면 내부 인풋 하이라이트 및 칩 제거
            var pane = document.getElementById('tab-pane-' + tabKey);
            if (pane) {
                pane.querySelectorAll('.input-date-stale-notice').forEach(function(el) {
                    el.classList.remove('input-date-stale-notice');
                });
                pane.querySelectorAll('.badge-date-stale-chip').forEach(function(el) {
                    el.remove();
                });
            }
        },

        /**
         * pane 엘리먼트를 통해 알림 제거 (조회, 새로고침 시 연동용)
         */
        clearTabNoticeForPane: function(pane) {
            if (!pane) return;
            var tabKey = pane.getAttribute('data-tab-key') || pane.getAttribute('data-pgm-no');
            if (tabKey) {
                this.clearTabNotice(tabKey);
            } else {
                pane.querySelectorAll('.input-date-stale-notice').forEach(function(el) {
                    el.classList.remove('input-date-stale-notice');
                });
                pane.querySelectorAll('.badge-date-stale-chip').forEach(function(el) {
                    el.remove();
                });
            }
        },

        detectCorpGr: function(pane) {
            if (!pane) return '2402';
            if (typeof resolveCorpGr === 'function') {
                var c = resolveCorpGr(pane);
                if (c) return c;
            }
            var el = pane.querySelector('#filterCorpGr, select[name="corpGr"], input[name="corpGr"]');
            if (el && el.value) return el.value.trim();
            var attr = pane.getAttribute('data-corp-gr');
            if (attr) return attr.trim();
            return '2402';
        },

        findDateInputs: function(pane) {
            if (!pane) return [];
            return Array.from(pane.querySelectorAll(
                '#filterYmd, #ymd, #trYmd, #workDate, #tymd, #filterFYmd, #filterTYmd, #filterFymd, #filterTymd, ' +
                'input[name="filterYmd"], input[name="ymd"], input[name="trYmd"], input[name="workDate"], input[name="tymd"], input[name="fYmd"], input[name="tYmd"], input[name="fymd"]'
            ));
        }
    };

    window.WorkDateSyncManager = WorkDateSyncManager;

})(window);
