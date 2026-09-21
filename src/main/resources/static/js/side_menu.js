/**
 * AAMS Side Menu & Navigation Controller
 * Handles:
 * - Top Category / Sidebar Menu Mapping & Navigation
 * - Dynamic Sub-tree Loading & Rendering
 * - Sidebar Program Search & Dropdown Keyboard Navigation (Arrow Up/Down, Enter, Boundary Clamping)
 * - Responsive Mobile Sidebar Drawer & Viewport Mode Switching
 */

// Global State
window.g_currentPgmNo = window.g_currentPgmNo || '00804';
let g_lastIsMobile = (window.innerWidth <= 876);
let g_topMenuDataCache = null;
let g_allMenuListCache = null;
let g_searchActiveIndex = -1;

/**
 * Safe fetch helper (fallback if safeFetchJson is not in window)
 */
function getSafeFetchJson(url, options) {
    if (typeof window.safeFetchJson === 'function') {
        return window.safeFetchJson(url, options);
    }
    return fetch(url, options).then(res => res.json()).catch(err => {
        console.error('Fetch error:', err);
        return null;
    });
}

/**
 * HTML escape helper (fallback if escapeHtml is not in window)
 */
function getEscapeHtml(str) {
    if (typeof window.escapeHtml === 'function') {
        return window.escapeHtml(str);
    }
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}

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

function initSidebarTopTree(activePgmNo) {
    const container = document.getElementById('sidebarMenuContainer');
    if (!container) return;

    if (g_topMenuDataCache) {
        renderTopCategoryFolders(g_topMenuDataCache, activePgmNo);
        return;
    }

    getSafeFetchJson('/api/menu/top')
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
        getSafeFetchJson(`/api/menu/side?pgmNo=${encodeURIComponent(pgmNo)}`)
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

    // If screen is in compact mode (Tablet-L <= 1415px), use Top Category Tree Folders in sidebar
    if (document.body.classList.contains('header-compact-mode') || window.innerWidth <= 1415) {
        initSidebarTopTree(targetNo);
        return;
    }

    // On Desktop (> 1415px): Render ONLY sub-items for selected pgmNo without wrapping in top category folders!
    const container = document.getElementById('sidebarMenuContainer');
    if (!container) return;

    getSafeFetchJson(`/api/menu/side?pgmNo=${encodeURIComponent(targetNo)}`)
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

    // 모바일 환경이거나 오프캔버스 드로어로 열려있는 경우 사이드바 메뉴 자동 닫기
    const sidebar = document.querySelector('.left-sidebar');
    const isMobileMode = (window.innerWidth <= 876) || document.body.classList.contains('header-compact-mode') || (sidebar && sidebar.classList.contains('sidebar-open'));
    if (isMobileMode) {
        closeMobileSidebar();
    }
}

function filterSidebarMenu(query) {
    const q = (query || '').trim().toLowerCase();
    const dropdown = document.getElementById('sidebarSearchDropdown');
    if (!dropdown) return;

    if (!q) {
        dropdown.style.display = 'none';
        dropdown.innerHTML = '';
        g_searchActiveIndex = -1;
        return;
    }

    if (!g_allMenuListCache) {
        getSafeFetchJson('/api/menu/all')
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
        g_searchActiveIndex = -1;
        dropdown.innerHTML = `
            <div style="padding: 12px; color: #94a3b8; font-size: 11px; text-align: center;">
                <i class="fa-solid fa-magnifying-glass" style="margin-bottom: 4px;"></i><br>
                '${getEscapeHtml(q)}' 검색 결과가 없습니다.
            </div>
        `;
        dropdown.style.display = 'block';
        return;
    }

    let html = '';
    filtered.forEach((item, index) => {
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
        const activeClass = (index === 0) ? ' active' : '';

        html += `
            <div class="search-dropdown-item${activeClass}" 
                 data-index="${index}"
                 data-top-pgm-no="${topPgmNo}"
                 data-pgm-no="${pgmNo}" 
                 data-pgm-id="${pgmId}" 
                 data-pgm-go="${go}" 
                 data-title="${displayNm}" 
                 data-breadcrumb="${breadcrumb}" 
                 onclick="onSearchDropdownItemClick(this)"
                 onmouseenter="setSearchActiveIndex(${index})">
                <div class="item-title">
                    <i class="fa-solid fa-file-code menu-icon" style="color: #60a5fa; font-size: 11px;"></i>
                    <span>${titleHtml}</span>
                </div>
                ${breadcrumb ? `<div class="item-breadcrumb">${getEscapeHtml(breadcrumb)}</div>` : ''}
            </div>
        `;
    });

    dropdown.innerHTML = html;
    dropdown.style.display = 'block';
    dropdown.scrollTop = 0;
    g_searchActiveIndex = 0; // 목록 존재 시 첫 번째 행 기본 포커스
}

function handleSidebarSearchKeydown(event) {
    const dropdown = document.getElementById('sidebarSearchDropdown');
    if (!dropdown || dropdown.style.display === 'none') {
        if (event.key === 'Enter') {
            event.preventDefault();
            filterSidebarMenu(event.target.value);
        }
        return;
    }

    const items = dropdown.querySelectorAll('.search-dropdown-item');
    if (!items || items.length === 0) return;

    if (event.key === 'ArrowDown') {
        event.preventDefault();
        if (g_searchActiveIndex < items.length - 1) {
            g_searchActiveIndex++;
            updateSearchDropdownActive(items, g_searchActiveIndex);
        }
    } else if (event.key === 'ArrowUp') {
        event.preventDefault();
        if (g_searchActiveIndex > 0) {
            g_searchActiveIndex--;
            updateSearchDropdownActive(items, g_searchActiveIndex);
        }
    } else if (event.key === 'Enter') {
        event.preventDefault();
        let targetItem = null;
        if (g_searchActiveIndex >= 0 && g_searchActiveIndex < items.length) {
            targetItem = items[g_searchActiveIndex];
        } else {
            targetItem = items[0];
        }
        if (targetItem) {
            onSearchDropdownItemClick(targetItem);
        }
    } else if (event.key === 'Escape') {
        dropdown.style.display = 'none';
        g_searchActiveIndex = -1;
    }
}

function updateSearchDropdownActive(items, index) {
    items.forEach((item, i) => {
        if (i === index) {
            item.classList.add('active');
            item.scrollIntoView({ block: 'nearest' });
        } else {
            item.classList.remove('active');
        }
    });
}

function setSearchActiveIndex(index) {
    const dropdown = document.getElementById('sidebarSearchDropdown');
    if (!dropdown) return;
    const items = dropdown.querySelectorAll('.search-dropdown-item');
    g_searchActiveIndex = index;
    items.forEach((item, i) => {
        if (i === index) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });
}

function highlightSearchMatch(text, query) {
    if (!text || !query) return getEscapeHtml(text || '');
    const str = String(text);
    const escaped = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const regex = new RegExp(`(${escaped})`, 'gi');
    return getEscapeHtml(str).replace(regex, '<mark class="search-highlight">$1</mark>');
}

function onSearchDropdownItemClick(el) {
    if (!el) return;
    const dropdown = document.getElementById('sidebarSearchDropdown');
    const searchInput = document.getElementById('sidebarSearchInput');
    if (dropdown) dropdown.style.display = 'none';
    if (searchInput) {
        searchInput.value = '';
        searchInput.blur();
    }
    g_searchActiveIndex = -1;

    onSidebarMenuClick(el);
}

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
 * Responsive Mobile Sidebar Drawer Controller & Window Resize Helper
 */
function toggleSidebar() {
    const sidebar = document.querySelector('.left-sidebar');
    const body = document.body;
    if (!sidebar) return;
    
    sidebar.classList.toggle('sidebar-open');
    body.classList.toggle('sidebar-backdrop-open');
}

function closeMobileSidebar() {
    const sidebar = document.querySelector('.left-sidebar');
    if (sidebar) {
        sidebar.classList.remove('sidebar-open');
    }
    document.body.classList.remove('sidebar-backdrop-open');
}

/**
 * Responsive Viewport & Header/Sidebar Mode Controller
 * - 데스크톱 (> 1415px): top_header 대분류 표시, side_menu는 선택된 대분류의 하위 메뉴만 표시
 * - 태블릿-L (<= 1415px): top_header 대분류 숨김, side_menu에 대분류가 통합되어 트리 폴더로 표시 (header-compact-mode)
 * - 태블릿-S / 모바일 (<= 876px): 모바일 버전 형식 적용
 */
function checkHeaderCollision() {
    const body = document.body;
    const width = window.innerWidth;

    // 태블릿-L 기준점 (1415px 이하): top_header 대분류 숨김 & side_menu 트리 폴더 통합
    if (width <= 1415) {
        if (!body.classList.contains('header-compact-mode')) {
            body.classList.add('header-compact-mode');
            if (typeof initSidebarTopTree === 'function') {
                initSidebarTopTree(window.g_currentPgmNo);
            }
        }
    } else {
        // 데스크톱 규격 (> 1415px): 정상 데스크톱 레이아웃 복원
        if (body.classList.contains('header-compact-mode')) {
            body.classList.remove('header-compact-mode');
            const sidebar = document.querySelector('.left-sidebar');
            if (sidebar) sidebar.classList.remove('sidebar-open');
            body.classList.remove('sidebar-backdrop-open');

            if (typeof loadSideMenu === 'function') {
                loadSideMenu(window.g_currentPgmNo);
            }
        }
    }
}

// Global Window Exports
window.getTopPgmNoByGo = getTopPgmNoByGo;
window.extractPgmGoFromTab = extractPgmGoFromTab;
window.findTopCategoryForTab = findTopCategoryForTab;
window.formatBreadcrumb = formatBreadcrumb;
window.onHeaderMenuClick = onHeaderMenuClick;
window.initSidebarTopTree = initSidebarTopTree;
window.renderTopCategoryFolders = renderTopCategoryFolders;
window.toggleTopCategoryGroup = toggleTopCategoryGroup;
window.expandTopCategoryFolder = expandTopCategoryFolder;
window.loadTopCategorySubTree = loadTopCategorySubTree;
window.loadSideMenu = loadSideMenu;
window.toggleMenuGroup = toggleMenuGroup;
window.renderSubTreeHtml = renderSubTreeHtml;
window.onSidebarMenuClick = onSidebarMenuClick;
window.filterSidebarMenu = filterSidebarMenu;
window.renderSearchDropdownResults = renderSearchDropdownResults;
window.handleSidebarSearchKeydown = handleSidebarSearchKeydown;
window.updateSearchDropdownActive = updateSearchDropdownActive;
window.setSearchActiveIndex = setSearchActiveIndex;
window.highlightSearchMatch = highlightSearchMatch;
window.onSearchDropdownItemClick = onSearchDropdownItemClick;
window.toggleSidebar = toggleSidebar;
window.closeMobileSidebar = closeMobileSidebar;
window.checkHeaderCollision = checkHeaderCollision;

// DOM Event Listeners for Sidebar & Search
document.addEventListener('click', function(e) {
    // 1. Close search dropdown on click outside
    const searchContainer = document.querySelector('.sidebar-search');
    const dropdown = document.getElementById('sidebarSearchDropdown');
    if (dropdown && searchContainer && !searchContainer.contains(e.target)) {
        dropdown.style.display = 'none';
        g_searchActiveIndex = -1;
    }

    // 2. Close mobile sidebar on backdrop click
    if (document.body.classList.contains('sidebar-backdrop-open')) {
        const sidebar = document.querySelector('.left-sidebar');
        const toggleBtn = document.querySelector('.mobile-sidebar-toggle');
        if (sidebar && !sidebar.contains(e.target) && (!toggleBtn || !toggleBtn.contains(e.target))) {
            closeMobileSidebar();
        }
    }
});

// Window resize listener to handle responsive sidebar/header mode
window.addEventListener('resize', function() {
    checkHeaderCollision();
});

// Auto-load side menu for active top nav item on DOMContentLoaded (supports F5 refresh persistence)
document.addEventListener("DOMContentLoaded", function() {
    if (window.location.pathname.includes('/login') || window.location.pathname.includes('/w_login_aams')) {
        return;
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

    // Header collision check
    setTimeout(checkHeaderCollision, 50);
});
