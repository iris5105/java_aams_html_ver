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

function loadSideMenu(pgmNo) {
    const container = document.getElementById('sidebarMenuContainer');
    if (!container) return;

    safeFetchJson(`/api/menu/side?pgmNo=${encodeURIComponent(pgmNo)}`)
        .then(data => {
            if (!data) return;
            renderSideMenu(data);
        });
}

function toggleMenuGroup(headerEl) {
    if (!headerEl) return;
    const groupEl = headerEl.closest('.menu-group');
    if (!groupEl) return;
    groupEl.classList.toggle('collapsed');
}

function renderSideMenu(list) {
    const container = document.getElementById('sidebarMenuContainer');
    if (!container) return;

    if (!list || list.length === 0) {
        container.innerHTML = '<div class="menu-item" style="color: #94a3b8; padding: 12px;"><i class="fa-solid fa-circle-info"></i> 메뉴 없음</div>';
        return;
    }

    // Count how many middle categories (중분류) exist in the list
    const middleCategoryCount = list.filter(item => item.pgmKindCode === 'M' || item.treeLevel === 3).length;
    const showGroupHeader = middleCategoryCount > 1; // Render group headers ONLY if there are multiple middle categories (> 1)

    let html = '';
    let inGroup = false;
    let groupIndex = 0;

    list.forEach(item => {
        // Skip Top Navigation Level (Level 2) in side menu
        if (item.treeLevel === 2) {
            return;
        }

        const go = item.pgmGo ? item.pgmGo.trim() : '';
        const nm = (item.pgmNm && item.pgmNm.trim()) ? item.pgmNm.trim() : ((item.pgmNo && item.pgmNo.trim()) ? item.pgmNo.trim() : '');
        const displayNm = item.displayNm || (go ? `${go} ${nm}` : nm);
        const hasLineClass = (item.treeLine === 'Y' || item.treeLine === 'y') ? ' has-tree-line' : '';

        // PGM_KIND_CODE === 'M' takes priority to be recognized as Middle Category (중분류)
        const isMiddleCategory = (item.pgmKindCode === 'M') || (item.treeLevel === 3);

        if (isMiddleCategory) {
            if (showGroupHeader) {
                if (inGroup) {
                    html += `</div></div>`;
                    inGroup = false;
                }

                groupIndex++;
                // Expand ONLY the first middle category (groupIndex === 1), collapse the remaining (groupIndex > 1)
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
            // If showGroupHeader is false (middleCategoryCount <= 1), skip rendering the single group header
        } else {
            // Leaf screen menu item (PGM_KIND_CODE === 'P')
            html += `
                <div class="menu-item${hasLineClass}" data-pgm-no="${item.pgmNo || ''}">
                    <i class="fa-solid fa-file-code"></i> <span>${displayNm}</span>
                </div>
            `;
        }
    });

    if (inGroup) {
        html += `</div></div>`;
    }

    container.innerHTML = html;
}

// Auto-load side menu for initial active top nav item on DOMContentLoaded
document.addEventListener("DOMContentLoaded", function() {
    const activeTopItem = document.querySelector('.top-nav-item.active');
    if (activeTopItem) {
        const pgmNo = activeTopItem.getAttribute('data-pgm-no');
        if (pgmNo) {
            loadSideMenu(pgmNo);
        }
    }
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
    const modal = document.getElementById('companyModal');
    if (modal) modal.style.display = 'flex';
    if (allCompanies.length === 0) {
        fetchCompanies();
    } else {
        renderCompanies(allCompanies);
    }
}

function closeCompanyModal() {
    const modal = document.getElementById('companyModal');
    if (modal) modal.style.display = 'none';
}

function fetchCompanies() {
    safeFetchJson('/api/home/companies')
        .then(data => {
            if (!data) return;
            allCompanies = data || [];
            renderCompanies(allCompanies);
        });
}

function renderCompanies(list) {
    const grid = document.getElementById('companyGrid');
    if (!grid) return;
    if (!list || list.length === 0) {
        grid.innerHTML = '<div style="grid-column: span 2; text-align: center; color: #94a3b8; padding: 20px;">등록된 회사가 없습니다.</div>';
        return;
    }

    const activeCorpGr = window.currentCorpGr || '';

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
