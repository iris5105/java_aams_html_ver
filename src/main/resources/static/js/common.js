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

let g_currentPgmNo = '01000';
let g_lastIsMobile = (window.innerWidth <= 1100);

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
            });
    }
}

function loadSideMenu(pgmNo) {
    if (pgmNo) g_currentPgmNo = pgmNo;
    const targetNo = g_currentPgmNo || '01000';

    // If screen width is <= 1100px (header top nav is hidden), use Top Category Tree Folders in sidebar
    if (window.innerWidth <= 1100) {
        initSidebarTopTree(targetNo);
        return;
    }

    // On Desktop (> 1100px): Render ONLY sub-items for selected pgmNo without wrapping in top category folders!
    const container = document.getElementById('sidebarMenuContainer');
    if (!container) return;

    safeFetchJson(`/api/menu/side?pgmNo=${encodeURIComponent(targetNo)}`)
        .then(data => {
            if (!data) return;
            container.innerHTML = renderSubTreeHtml(data);
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

    if (window.tabManager) {
        window.tabManager.openTab(pgmNo, pgmId, title, null, breadcrumb, pgmGo);
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

        html += `
            <div class="search-dropdown-item" 
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
                <div class="tree-menu-item${hasLineClass}" data-pgm-no="${item.pgmNo || ''}" data-pgm-id="${pgmId}" data-pgm-go="${pgmGo}" data-title="${displayNm}" data-breadcrumb="${breadcrumb}" onclick="onSidebarMenuClick(this)">
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

// Auto-load side menu for initial active top nav item on DOMContentLoaded
document.addEventListener("DOMContentLoaded", function() {
    const activeTopItem = document.querySelector('.top-nav-item.active');
    const pgmNo = activeTopItem ? activeTopItem.getAttribute('data-pgm-no') : '01000';
    loadSideMenu(pgmNo);

    // Start token expiration monitoring if logged in
    if (!window.location.pathname.includes('/login') && !window.location.pathname.includes('/w_login_aams')) {
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

/**
 * Logout Handler
 */
function handleLogout() {
    fetch('/api/auth/logout', { method: 'POST' })
        .then(() => {
            localStorage.clear();
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

// Window resize listener to automatically redraw Tabulator instances and update sidebar menu mode
window.addEventListener('resize', function() {
    const isMobile = (window.innerWidth <= 1100);
    if (isMobile !== g_lastIsMobile) {
        g_lastIsMobile = isMobile;
        loadSideMenu(g_currentPgmNo);
    }

    if (typeof Tabulator !== 'undefined') {
        Tabulator.findTable(".tabulator").forEach(table => {
            try { table.redraw(true); } catch(e) {}
        });
    }
});

/**
 * Global Common Breadcrumb Builder Helper
 */
function buildBreadcrumbText(fullpgm2, title, pgmId) {
    return formatBreadcrumb(fullpgm2, title, pgmId);
}
