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

function renderSideMenu(list) {
    const container = document.getElementById('sidebarMenuContainer');
    if (!container) return;

    if (!list || list.length === 0) {
        container.innerHTML = '<div class="menu-item" style="color: #94a3b8; padding: 12px;"><i class="fa-solid fa-circle-info"></i> 메뉴 없음</div>';
        return;
    }

    let html = '';
    list.forEach(item => {
        const go = item.pgmGo ? item.pgmGo.trim() : '';
        const id = (item.pgmId && item.pgmId.trim()) ? item.pgmId.trim() : (item.pgmNo ? item.pgmNo.trim() : '');
        const displayNm = go ? `${go} ${id}` : id;

        html += `
            <div class="menu-item" data-pgm-no="${item.pgmNo || ''}">
                <i class="fa-solid fa-file-code"></i> ${displayNm}
            </div>
        `;
    });

    container.innerHTML = html;
}

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
