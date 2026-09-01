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

window.g_currentPgmNo = '00804';
let g_lastIsMobile = (window.innerWidth <= 1100);

/**
 * Maps standard AAMS 4-digit program numbering to root top category PGM_NO:
 * 0001 ~ 0099 : 00822 (손익차등)
 * 1000 ~ 1999 : 00804 (자문일일)
 * 2000 ~ 2999 : 00004 (공모청약(관리))
 * 3000 ~ 3499 : 00013 (자산운용)
 * 3500 ~ 3999 : 00153 (US Portfolio Model)
 * 4000 ~ 4999 : 00091 (외화자산운용)
 * 5000 ~ 5029 : 00030 (원장조회)
 * 5030 ~ 5049 : 00359 (보고서)
 * 5050 ~ 5999 : 00030 (원장조회)
 * 8000 ~ 8999 : 00055 (코드관리)
 * 9300 ~ 9990 : 00001 (시스템관리)
 * 9991 ~ 9999 : 00009 (프레임관리)
 */
function getTopPgmNoByGo(goNum) {
    if (goNum === null || goNum === undefined) return null;
    const n = parseInt(goNum, 10);
    if (isNaN(n)) return null;

    if (n >= 1 && n <= 99) return '00822';      // 손익차등
    if (n >= 1000 && n <= 1999) return '00804'; // 자문일일
    if (n >= 2000 && n <= 2999) return '00004'; // 공모청약(관리)
    if (n >= 3000 && n <= 3499) return '00013'; // 자산운용
    if (n >= 3500 && n <= 3999) return '00153'; // US Portfolio Model
    if (n >= 4000 && n <= 4999) return '00091'; // 외화자산운용
    if (n >= 5030 && n <= 5049) return '00359'; // 보고서
    if (n >= 5000 && n <= 5999) return '00030'; // 원장조회
    if (n >= 8000 && n <= 8999) return '00055'; // 코드관리
    if (n >= 9300 && n <= 9990) return '00001'; // 시스템관리
    if (n >= 9991 && n <= 9999) return '00009'; // 프레임관리
    return null;
}

function extractPgmGoFromTab(tabObj) {
    if (!tabObj) return null;
    if (tabObj.pgmGo && /^\d+$/.test(String(tabObj.pgmGo).trim())) {
        return String(tabObj.pgmGo).trim();
    }
    if (tabObj.url) {
        const match = tabObj.url.match(/[?&]pgmGo=(\d+)/i);
        if (match) return match[1];
    }
    if (tabObj.title) {
        const match = tabObj.title.match(/^\s*(\d{1,4})\b/);
        if (match) return match[1];
    }
    if (tabObj.tabKey && /^\d{1,4}$/.test(String(tabObj.tabKey).trim())) {
        return String(tabObj.tabKey).trim();
    }
    if (tabObj.pgmNo && /^\d{1,4}$/.test(String(tabObj.pgmNo).trim())) {
        return String(tabObj.pgmNo).trim();
    }
    return null;
}

function findTopCategoryForTab(tabObj) {
    if (!tabObj) return null;

    // 1. Direct valid topPgmNo in DOM
    if (tabObj.topPgmNo && document.querySelector(`.top-nav-item[data-pgm-no="${tabObj.topPgmNo}"]`)) {
        return tabObj.topPgmNo;
    }

    // 2. Extract 4-digit pgmGo using standard AAMS program number range mapping
    const goNum = extractPgmGoFromTab(tabObj);
    if (goNum) {
        const mappedTop = getTopPgmNoByGo(goNum);
        if (mappedTop && document.querySelector(`.top-nav-item[data-pgm-no="${mappedTop}"]`)) {
            return mappedTop;
        }
    }

    // 3. Match from breadcrumb or title against top nav item names
    const textToCheck = ((tabObj.breadcrumb || '') + ' ' + (tabObj.title || '')).trim();
    if (textToCheck) {
        const topItems = Array.from(document.querySelectorAll('.top-nav-item'));
        for (const item of topItems) {
            const name = item.innerText.trim();
            const no = item.getAttribute('data-pgm-no');
            if (name && no && textToCheck.includes(name)) {
                return no;
            }
        }
    }

    // 4. Fallback: currently active or first top-nav-item in DOM
    const activeTop = document.querySelector('.top-nav-item.active') || document.querySelector('.top-nav-item');
    return activeTop ? activeTop.getAttribute('data-pgm-no') : '00804';
}

window.getTopPgmNoByGo = getTopPgmNoByGo;
window.extractPgmGoFromTab = extractPgmGoFromTab;
window.findTopCategoryForTab = findTopCategoryForTab;

/**
 * Header Top Menu Click Handler & Side Navigation Dynamic Loader
 */
function onHeaderMenuClick(el) {
    if (!el) return;

    const parent = el.parentElement;
    if (parent) {
        const items = parent.querySelectorAll('.top-nav-item');
        items.forEach(item => item.classList.remove('active'));
    }
    el.classList.add('active');

    const pgmNo = el.getAttribute('data-pgm-no');
    if (pgmNo) {
        window.g_currentPgmNo = pgmNo;
        loadSideMenu(pgmNo);
    }
}

let g_topMenuDataCache = null;

function initSidebarTopTree(activePgmNo) {
    const container = document.getElementById('sidebarMenuContainer');
    if (!container) return;

    if (g_topMenuDataCache) {
        renderTopCategoryFolders(g_topMenuDataCache, activePgmNo);
        return;
    }

    safeFetchJson('/api/menu/top')
        .then(data => {
            if (!data || data.length === 0) {
                return;
            }
            g_topMenuDataCache = data;
            renderTopCategoryFolders(g_topMenuDataCache, activePgmNo);
        });
}

function renderTopCategoryFolders(topList, activePgmNo) {
    const container = document.getElementById('sidebarMenuContainer');
    if (!container) return;

    const targetActiveNo = activePgmNo || (topList[0] ? topList[0].pgmNo : '01000');

    let html = '';
    topList.forEach(item => {
        const pgmNo = item.pgmNo;
        const pgmNm = item.pgmNm;
        const isActive = (pgmNo === targetActiveNo);
        const collapsedClass = isActive ? '' : ' collapsed';

        html += `
            <div class="top-menu-group${collapsedClass}" id="top-menu-group-${pgmNo}" data-pgm-no="${pgmNo}">
                <div class="top-menu-group-header" onclick="toggleTopCategoryGroup('${pgmNo}')">
                    <div class="group-title-box">
                        <i class="fa-solid fa-folder-open group-icon"></i>
                        <span class="group-title">${pgmNm}</span>
                    </div>
                    <i class="fa-solid fa-chevron-down toggle-icon"></i>
                </div>
                <div class="top-menu-group-children" id="top-menu-children-${pgmNo}">
                </div>
            </div>
        `;
    });

    container.innerHTML = html;

    // Load sub-tree for active top category folder
    loadTopCategorySubTree(targetActiveNo);
}

function toggleTopCategoryGroup(pgmNo) {
    const groupEl = document.getElementById(`top-menu-group-${pgmNo}`);
    if (!groupEl) return;

    const isCollapsed = groupEl.classList.contains('collapsed');
    if (isCollapsed) {
        groupEl.classList.remove('collapsed');
        loadTopCategorySubTree(pgmNo);
    } else {
        groupEl.classList.add('collapsed');
    }
}

function expandTopCategoryFolder(pgmNo) {
    const groupEl = document.getElementById(`top-menu-group-${pgmNo}`);
    if (!groupEl) {
        loadSideMenu(pgmNo);
        return;
    }

    groupEl.classList.remove('collapsed');
    loadTopCategorySubTree(pgmNo);
}

function loadTopCategorySubTree(pgmNo) {
    const childContainer = document.getElementById(`top-menu-children-${pgmNo}`);
    if (!childContainer) return;

    if (childContainer.children.length === 0) {
        childContainer.innerHTML = '<div style="padding: 8px 16px; color: #94a3b8; font-size: 11px;"><i class="fa-solid fa-spinner fa-spin"></i> 로딩 중...</div>';
        safeFetchJson(`/api/menu/side?pgmNo=${encodeURIComponent(pgmNo)}`)
            .then(data => {
                if (!data || data.length === 0) {
                    childContainer.innerHTML = '<div style="padding: 8px 16px; color: #64748b; font-size: 11px;">하위 메뉴 없음</div>';
                    return;
                }
                childContainer.innerHTML = renderSubTreeHtml(data);
                if (window.tabManager && window.tabManager.activeTabKey) {
                    window.tabManager.highlightSidebarMenu(window.tabManager.activeTabKey);
                }
            });
    } else {
        if (window.tabManager && window.tabManager.activeTabKey) {
            window.tabManager.highlightSidebarMenu(window.tabManager.activeTabKey);
        }
    }
}

function loadSideMenu(pgmNo) {
    if (pgmNo) window.g_currentPgmNo = pgmNo;
    let targetNo = window.g_currentPgmNo || '00804';

    // Verify that targetNo is a valid top category pgmNo
    const validTop = document.querySelector(`.top-nav-item[data-pgm-no="${targetNo}"]`);
    if (!validTop) {
        const activeTop = document.querySelector('.top-nav-item.active') || document.querySelector('.top-nav-item');
        targetNo = activeTop ? activeTop.getAttribute('data-pgm-no') : '00804';
        window.g_currentPgmNo = targetNo;
    }

    // If screen is in compact mode (header top nav is hidden due to collision or narrow screen), use Top Category Tree Folders in sidebar
    if (document.body.classList.contains('header-compact-mode') || window.innerWidth <= 1100) {
        initSidebarTopTree(targetNo);
        return;
    }

    // On Desktop (> 1100px): Render ONLY sub-items for selected pgmNo without wrapping in top category folders!
    const container = document.getElementById('sidebarMenuContainer');
    if (!container) return;

    safeFetchJson(`/api/menu/side?pgmNo=${encodeURIComponent(targetNo)}`)
        .then(data => {
            if (!data || !Array.isArray(data) || data.length === 0) {
                console.warn(`No side menu items returned for pgmNo=${targetNo}`);
                return;
            }
            container.innerHTML = renderSubTreeHtml(data);
            if (window.tabManager && window.tabManager.activeTabKey) {
                window.tabManager.highlightSidebarMenu(window.tabManager.activeTabKey);
            }
        });
}

function toggleMenuGroup(headerEl) {
    if (!headerEl) return;
    const groupEl = headerEl.closest('.menu-group');
    if (!groupEl) return;
    groupEl.classList.toggle('collapsed');
}

function formatBreadcrumb(fullpgm2, title, pgmId) {
    let base = (fullpgm2 && String(fullpgm2).trim() !== '') ? String(fullpgm2).trim() : '';
    const menuName = (title && String(title).trim() !== '') ? String(title).trim() : '';
    const pId = (pgmId && String(pgmId).trim() !== '') ? String(pgmId).trim() : '';

    if (pId && base.includes(`[${pId}]`)) {
        return base;
    }

    if (!base) {
        return menuName ? (pId ? `${menuName} [${pId}]` : menuName) : (pId ? `[${pId}]` : '');
    }

    if (menuName && !base.includes(menuName)) {
        base += ` > ${menuName}`;
    }

    if (pId && !base.includes(`[${pId}]`)) {
        base += ` [${pId}]`;
    }

    return base;
}

function onSidebarMenuClick(el) {
    if (!el) return;
    const pgmNo = el.getAttribute('data-pgm-no');
    const pgmId = el.getAttribute('data-pgm-id') || pgmNo;
    const pgmGo = el.getAttribute('data-pgm-go') || '';
    const title = el.getAttribute('data-title') || el.innerText.trim();
    const rawBreadcrumb = el.getAttribute('data-breadcrumb');
    const breadcrumb = formatBreadcrumb(rawBreadcrumb, title, pgmId);

    // Identify current top category
    const directTop = el.getAttribute('data-top-pgm-no');
    const topGroup = el.closest('.top-menu-group');
    const activeTopNav = document.querySelector('.top-nav-item.active');
    const activeTopNo = activeTopNav ? activeTopNav.getAttribute('data-pgm-no') : null;
    const mappedTopFromGo = getTopPgmNoByGo(pgmGo);
    const topPgmNo = directTop || (topGroup ? topGroup.getAttribute('data-pgm-no') : (mappedTopFromGo || activeTopNo || window.g_currentPgmNo || '00804'));

    if (window.tabManager) {
        window.tabManager.openTab(pgmNo, pgmId, title, null, breadcrumb, pgmGo, topPgmNo);
    }
}

let g_allMenuListCache = null;

function filterSidebarMenu(query) {
    const q = (query || '').trim().toLowerCase();
    const dropdown = document.getElementById('sidebarSearchDropdown');
    if (!dropdown) return;

    if (!q) {
        dropdown.style.display = 'none';
        dropdown.innerHTML = '';
        return;
    }

    if (!g_allMenuListCache) {
        safeFetchJson('/api/menu/all')
            .then(data => {
                if (!data) return;
                g_allMenuListCache = data;
                renderSearchDropdownResults(g_allMenuListCache, q);
            });
    } else {
        renderSearchDropdownResults(g_allMenuListCache, q);
    }
}

function renderSearchDropdownResults(list, q) {
    const dropdown = document.getElementById('sidebarSearchDropdown');
    if (!dropdown) return;

    const filtered = list.filter(item => {
        const go = item.pgmGo ? item.pgmGo.trim().toLowerCase() : '';
        const nm = item.pgmNm ? item.pgmNm.trim().toLowerCase() : '';
        const pId = item.pgmId ? item.pgmId.trim().toLowerCase() : '';

        return go.includes(q) || nm.includes(q) || pId.includes(q);
    });

    if (filtered.length === 0) {
        dropdown.innerHTML = `
            <div style="padding: 12px; color: #94a3b8; font-size: 11px; text-align: center;">
                <i class="fa-solid fa-magnifying-glass" style="margin-bottom: 4px;"></i><br>
                '${escapeHtml(q)}' 검색 결과가 없습니다.
            </div>
        `;
        dropdown.style.display = 'block';
        return;
    }

    let html = '';
    filtered.forEach(item => {
        const go = item.pgmGo ? item.pgmGo.trim() : '';
        const nm = (item.pgmNm && item.pgmNm.trim()) ? item.pgmNm.trim() : ((item.pgmNo && item.pgmNo.trim()) ? item.pgmNo.trim() : '');
        const pgmId = item.pgmId ? item.pgmId.trim() : (item.pgmNo ? item.pgmNo.trim() : '');
        const pgmNo = item.pgmNo || '';
        const rawBreadcrumb = item.fullpgm2 || item.fullpgm || '';
        const displayNm = item.displayNm || (go ? `${go} ${nm}` : nm);
        const breadcrumb = formatBreadcrumb(rawBreadcrumb, displayNm, pgmId);

        // Highlight matching text in pgmGo, pgmNm, and pgmId
        const highlightedGo = highlightSearchMatch(go, q);
        const highlightedNm = highlightSearchMatch(nm, q);
        const highlightedPId = highlightSearchMatch(pgmId, q);

        const titleHtml = highlightedGo 
            ? `${highlightedGo} ${highlightedNm} [${highlightedPId}]`
            : `${highlightedNm} [${highlightedPId}]`;

        const topPgmNo = item.rootTopPgmNo || getTopPgmNoByGo(go) || '';

        html += `
            <div class="search-dropdown-item" 
                 data-top-pgm-no="${topPgmNo}"
                 data-pgm-no="${pgmNo}" 
                 data-pgm-id="${pgmId}" 
                 data-pgm-go="${go}" 
                 data-title="${displayNm}" 
                 data-breadcrumb="${breadcrumb}" 
                 onclick="onSearchDropdownItemClick(this)">
                <div class="item-title">
                    <i class="fa-solid fa-file-code menu-icon" style="color: #60a5fa; font-size: 11px;"></i>
                    <span>${titleHtml}</span>
                </div>
                ${breadcrumb ? `<div class="item-breadcrumb">${escapeHtml(breadcrumb)}</div>` : ''}
            </div>
        `;
    });

    dropdown.innerHTML = html;
    dropdown.style.display = 'block';
}

function highlightSearchMatch(text, query) {
    if (!text || !query) return escapeHtml(text || '');
    const str = String(text);
    const escaped = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const regex = new RegExp(`(${escaped})`, 'gi');
    return escapeHtml(str).replace(regex, '<mark class="search-highlight">$1</mark>');
}

function escapeHtml(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}

function onSearchDropdownItemClick(el) {
    if (!el) return;
    const dropdown = document.getElementById('sidebarSearchDropdown');
    const searchInput = document.getElementById('sidebarSearchInput');
    if (dropdown) dropdown.style.display = 'none';
    if (searchInput) searchInput.value = '';

    onSidebarMenuClick(el);
}

// Close search dropdown on click outside
document.addEventListener('click', function(e) {
    const searchContainer = document.querySelector('.sidebar-search');
    const dropdown = document.getElementById('sidebarSearchDropdown');
    if (dropdown && searchContainer && !searchContainer.contains(e.target)) {
        dropdown.style.display = 'none';
    }
});

function renderSubTreeHtml(list) {
    if (!list || list.length === 0) return '';

    const middleCategories = list.filter(item => item.pgmKindCode === 'M' && item.parentPgm !== '00000');
    const showGroupHeader = middleCategories.length > 1;

    let html = '';
    let inGroup = false;
    let groupIndex = 0;

    list.forEach(item => {
        if (item.parentPgm === '00000') return;

        const go = item.pgmGo ? item.pgmGo.trim() : '';
        const nm = (item.pgmNm && item.pgmNm.trim()) ? item.pgmNm.trim() : ((item.pgmNo && item.pgmNo.trim()) ? item.pgmNo.trim() : '');
        const displayNm = item.displayNm || (go ? `${go} ${nm}` : nm);
        const hasLineClass = (item.treeLine === 'Y' || item.treeLine === 'y') ? ' has-tree-line' : '';
        const isMiddleCategory = (item.pgmKindCode === 'M') || (item.treeLevel === 3);

        if (isMiddleCategory) {
            if (showGroupHeader) {
                if (inGroup) {
                    html += `</div></div>`;
                    inGroup = false;
                }

                groupIndex++;
                const collapsedClass = (groupIndex === 1) ? '' : ' collapsed';

                html += `
                    <div class="menu-group${collapsedClass}${hasLineClass}" data-pgm-no="${item.pgmNo || ''}">
                        <div class="menu-group-header" onclick="toggleMenuGroup(this)">
                            <div class="group-title-box">
                                <i class="fa-solid fa-folder-open group-icon"></i>
                                <span class="group-title">${displayNm}</span>
                            </div>
                            <i class="fa-solid fa-chevron-down toggle-icon"></i>
                        </div>
                        <div class="menu-group-children">
                `;
                inGroup = true;
            }
        } else {
            const pgmId = item.pgmId ? item.pgmId.trim() : (item.pgmNo ? item.pgmNo.trim() : '');
            const pgmGo = item.pgmGo ? item.pgmGo.trim() : '';
            const rawBreadcrumb = item.fullpgm2 || item.fullpgm || '';
            const breadcrumb = formatBreadcrumb(rawBreadcrumb, displayNm, pgmId);
            html += `
                <div class="tree-menu-item${hasLineClass}" data-top-pgm-no="${window.g_currentPgmNo || ''}" data-pgm-no="${item.pgmNo || ''}" data-pgm-id="${pgmId}" data-pgm-go="${pgmGo}" data-title="${displayNm}" data-breadcrumb="${breadcrumb}" onclick="onSidebarMenuClick(this)">
                    <i class="fa-solid fa-file-code menu-icon"></i> <span class="menu-label">${displayNm}</span>
                </div>
            `;
        }
    });

    if (inGroup) {
        html += `</div></div>`;
    }

    return html;
}

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

// Auto-load side menu for active top nav item on DOMContentLoaded (supports F5 refresh persistence)
document.addEventListener("DOMContentLoaded", function() {
    if (!window.location.pathname.includes('/login') && !window.location.pathname.includes('/w_login_aams')) {
        if (!verifyCorpGrCookie()) return;
        startTokenMonitor();
    }

    // 1. Check if there is a saved active top category from sessionStorage
    let pgmNo = null;
    try {
        const raw = sessionStorage.getItem("AAMS_MDI_TABS_STATE");
        if (raw) {
            const state = JSON.parse(raw);
            if (state) {
                if (state.activeTabKey && Array.isArray(state.openTabs)) {
                    const activeTab = state.openTabs.find(t => t.tabKey === state.activeTabKey || t.pgmNo === state.activeTabKey);
                    if (activeTab) {
                        pgmNo = findTopCategoryForTab(activeTab);
                    }
                }
                if (!pgmNo && state.activeTopPgmNo && document.querySelector(`.top-nav-item[data-pgm-no="${state.activeTopPgmNo}"]`)) {
                    pgmNo = state.activeTopPgmNo;
                }
            }
        }
    } catch(e) {}

    // 2. Update active class on top-nav-item in header
    let targetTopItem = pgmNo ? document.querySelector(`.top-nav-item[data-pgm-no="${pgmNo}"]`) : null;
    if (!targetTopItem) {
        targetTopItem = document.querySelector('.top-nav-item.active') || document.querySelector('.top-nav-item');
    }

    if (targetTopItem) {
        document.querySelectorAll('.top-nav-item').forEach(it => it.classList.remove('active'));
        targetTopItem.classList.add('active');
        pgmNo = targetTopItem.getAttribute('data-pgm-no');
    } else {
        pgmNo = '00804';
    }

    window.g_currentPgmNo = pgmNo;
    loadSideMenu(pgmNo);
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

function startTokenMonitor() {
    checkTokenStatus();
    if (tokenCheckInterval) clearInterval(tokenCheckInterval);
    tokenCheckInterval = setInterval(checkTokenStatus, 10000);
}

function checkTokenStatus() {
    safeFetchJson('/api/auth/token-status')
        .then(data => {
            if (!data || !data.success || data.expired) {
                if (isExtendModalOpen) {
                    closeTokenExtendModal();
                    handleLogout();
                }
                return;
            }

            currentRemainingSeconds = data.remainingSeconds || 0;

            // Warning threshold: 5 minutes (300 seconds) before expiration
            if (currentRemainingSeconds <= 300 && currentRemainingSeconds > 0) {
                openTokenExtendModal();
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

    updateCountdownDisplay();
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
    if (tokenCountdownInterval) {
        clearInterval(tokenCountdownInterval);
        tokenCountdownInterval = null;
    }
}

function extendAccessToken() {
    fetch('/api/auth/extend-token', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(data => {
        if (data && data.success) {
            closeTokenExtendModal();
            currentRemainingSeconds = data.remainingSeconds || 3000;
            startTokenMonitor();
        } else {
            alert(data.message || '토큰 연장에 실패했습니다.');
        }
    })
    .catch(err => {
        console.error('Token extension error:', err);
        alert('토큰 연장 요청 중 오류가 발생했습니다.');
    });
}

/**
 * Responsive Mobile Sidebar Drawer Controller & Window Resize Helper
 */
function toggleSidebar() {
    const sidebar = document.querySelector('.left-sidebar');
    const body = document.body;
    if (!sidebar) return;
    
    sidebar.classList.toggle('sidebar-open');
    body.classList.toggle('sidebar-backdrop-open');
}

// Close sidebar on backdrop click (outside click)
document.addEventListener('click', function(e) {
    if (document.body.classList.contains('sidebar-backdrop-open')) {
        const sidebar = document.querySelector('.left-sidebar');
        const toggleBtn = document.querySelector('.mobile-sidebar-toggle');
        if (sidebar && !sidebar.contains(e.target) && (!toggleBtn || !toggleBtn.contains(e.target))) {
            sidebar.classList.remove('sidebar-open');
            document.body.classList.remove('sidebar-backdrop-open');
        }
    }
});

/**
 * Dynamic Header Collision Detector
 * 화면이 작아지거나 창 크기가 변해 대분류와 유저정보가 겹쳐질 때 대분류를 접고 사이드바에 수납
 */
function checkHeaderCollision() {
    const topNav = document.getElementById('topNavContainer');
    const userInfo = document.querySelector('.top-header-right');
    const logo = document.querySelector('.top-header-logo');
    if (!topNav || !userInfo) return;

    const body = document.body;
    const width = window.innerWidth;

    // 모바일/태블릿 규격 (<= 1100px)에서는 상시 compact 모드 유지
    if (width <= 1100) {
        if (!body.classList.contains('header-compact-mode')) {
            body.classList.add('header-compact-mode');
            if (typeof initSidebarTopTree === 'function') {
                initSidebarTopTree(g_currentPgmNo);
            }
        }
        return;
    }

    // 데스크톱 규격 (> 1100px):
    // 실제 11개 대분류 아이템과 로고, 유저 정보가 차지하는 총 필요 너비 동적 계산
    let navItemsWidth = 0;
    topNav.querySelectorAll('.top-nav-item').forEach(it => {
        navItemsWidth += it.offsetWidth + 2;
    });

    const logoWidth = logo ? logo.offsetWidth : 220;
    const userWidth = userInfo.offsetWidth || 240;
    const requiredTotal = logoWidth + navItemsWidth + userWidth + 24;

    if (width < requiredTotal) {
        // 실제 화면 너비가 부족하여 겹치는 경우만 compact 모드 전환
        if (!body.classList.contains('header-compact-mode')) {
            body.classList.add('header-compact-mode');
            if (typeof initSidebarTopTree === 'function') {
                initSidebarTopTree(g_currentPgmNo);
            }
        }
    } else {
        // 충분한 너비가 확보되면 정상 데스크톱 레이아웃 복원
        if (body.classList.contains('header-compact-mode')) {
            body.classList.remove('header-compact-mode');
            const sidebar = document.querySelector('.left-sidebar');
            if (sidebar) sidebar.classList.remove('sidebar-open');
            body.classList.remove('sidebar-backdrop-open');

            if (typeof loadSideMenu === 'function') {
                loadSideMenu(g_currentPgmNo);
            }
        }
    }
}

// Window resize listener to automatically redraw Tabulator instances and update sidebar menu mode
window.addEventListener('resize', function() {
    checkHeaderCollision();

    if (typeof Tabulator !== 'undefined') {
        Tabulator.findTable(".tabulator").forEach(table => {
            try { table.redraw(true); } catch(e) {}
        });
    }
});

// Initial header collision check on DOM load
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(checkHeaderCollision, 50);
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

