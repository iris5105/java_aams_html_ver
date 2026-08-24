/**
 * W_HOME5 Data Fetchers & Panel Tab Handler
 */

function switchSubTab(tabId, el) {
    document.getElementById('gyulTab').style.display = 'none';
    document.getElementById('rateTab').style.display = 'none';
    document.querySelectorAll('.panel-tab-item').forEach(item => item.classList.remove('active'));

    document.getElementById(tabId).style.display = 'block';
    if (el) el.classList.add('active');

    if (tabId === 'rateTab') loadRateChanges();
    if (tabId === 'gyulTab') loadGyulAccounts();
}

// Card 1 (Top-Left): 공모기본정보 (dw_4 / d_home04)
function loadPublicStocks() {
    safeFetchJson('/api/home/public-stocks')
        .then(data => {
            if (!data) return;
            const tbody = document.getElementById('tbody-public-stocks');
            if (!tbody) return;
            if (Array.isArray(data) && data.length > 0) {
                tbody.innerHTML = data.map(item => `
                    <tr>
                        <td class="text-center">${item.balhCo || '-'}</td>
                        <td>${item.jmNm || '-'}</td>
                        <td class="text-center date-col">${formatDate(item.ymd)}</td>
                        <td>${item.jgTrCoNm || '-'}</td>
                        <td class="text-center date-col">${formatDate(item.startYmd)}</td>
                        <td class="text-center date-col">${formatDate(item.endYmd)}</td>
                        <td class="text-center date-col">${formatDate(item.nabibYmd)}</td>
                        <td class="text-center date-col">${formatDate(item.sjYmd)}</td>
                        <td class="text-right">${item.susuPer || '-'}</td>
                        <td class="text-center">${item.sjJmCd || '-'}</td>
                        <td>${item.xxSjJmCd || '-'}</td>
                    </tr>
                `).join('');
            } else {
                tbody.innerHTML = `<tr><td colspan="11" class="text-center" style="color: #94a3b8; padding: 12px;">데이터 없음</td></tr>`;
            }
        });
}

// Card 2 (Top-Middle): 수요예측참여내역(최근1개월) (dw_5 / d_home05)
function loadSubscriptions() {
    safeFetchJson('/api/home/subscriptions')
        .then(data => {
            if (!data) return;
            const tbody = document.getElementById('tbody-subscriptions');
            if (!tbody) return;
            if (Array.isArray(data) && data.length > 0) {
                tbody.innerHTML = data.map(item => `
                    <tr>
                        <td>${item.jmNm || '-'}</td>
                        <td>${item.jmCd || item.jmcd || '-'}</td>
                        <td class="text-center date-col">${formatDate(item.cyYmd) || '-'}</td>
                        <td class="text-right">${item.cyJusu ? item.cyJusu.toLocaleString() : '-'}</td>
                        <td class="text-right">${item.cyDanga ? item.cyDanga.toLocaleString() : '-'}</td>
                        <td class="text-right">${item.cyAek ? item.cyAek.toLocaleString() : '-'}</td>
                        <td class="text-center">${item.lockEnd || '-'}</td>
                    </tr>
                `).join('');
            } else {
                tbody.innerHTML = `<tr><td colspan="7" class="text-center" style="color: #94a3b8; padding: 12px;">데이터 없음</td></tr>`;
            }
        });
}

// Card 3 (Top-Right): 시스템 개발 및 수정의뢰 현황 (dw_6 / d_home06)
function loadProposals() {
    safeFetchJson('/api/home/proposals')
        .then(data => {
            if (!data) return;
            const tbody = document.getElementById('tbody-proposals');
            if (!tbody) return;
            if (Array.isArray(data) && data.length > 0) {
                tbody.innerHTML = data.map(item => `
                    <tr>
                        <td class="text-center date-time-col">${formatDate(item.ymd, true)}</td>
                        <td>${item.title || '-'}</td>
                        <td class="text-center date-time-col">${formatDate(item.contentYmd, true)}</td>
                    </tr>
                `).join('');
            } else {
                tbody.innerHTML = `<tr><td colspan="3" class="text-center" style="color: #94a3b8; padding: 12px;">데이터 없음</td></tr>`;
            }
        });
}

// Card 4 (Bottom-Left): 당일거래현황 (dw_1 / d_home01)
function loadDayTr() {
    safeFetchJson('/api/home/day-tr')
        .then(data => {
            if (!data) return;
            const tbody = document.getElementById('tbody-daytr');
            if (!tbody) return;
            if (Array.isArray(data) && data.length > 0) {
                tbody.innerHTML = data.map(item => `
                    <tr>
                        <td>${item.jasanGb || '-'}</td>
                        <td class="text-center">${item.trCd || '-'}</td>
                        <td class="text-right">${item.trCount ? item.trCount.toLocaleString() : 0}</td>
                        <td class="text-right">${item.trAek ? item.trAek.toLocaleString() : 0}</td>
                        <td class="text-center">${item.fundCount || 0}</td>
                    </tr>
                `).join('');
            } else {
                tbody.innerHTML = `<tr><td colspan="5" class="text-center" style="color: #94a3b8; padding: 12px;">데이터 없음</td></tr>`;
            }
        });
}

// Card 5-1 (Bottom-Middle): 당월결산계좌LIST
function loadGyulAccounts() {
    safeFetchJson('/api/home/gyul-accounts')
        .then(data => {
            if (!data) return;
            const tbody = document.getElementById('tbody-gyul');
            if (!tbody) return;
            if (Array.isArray(data) && data.length > 0) {
                tbody.innerHTML = data.map(item => `
                    <tr>
                        <td class="text-center date-col">${formatDate(item.gyulYmd)}</td>
                        <td class="text-center">${item.fundCd || '-'}</td>
                        <td>${item.fundNm || '-'}</td>
                    </tr>
                `).join('');
            } else {
                tbody.innerHTML = `<tr><td colspan="3" class="text-center" style="color: #94a3b8; padding: 12px;">데이터 없음</td></tr>`;
            }
        });
}

// Card 5-2 (Bottom-Middle): 당월이자(만기) (dw_2 / dw_3)
function loadRateChanges() {
    safeFetchJson('/api/home/rate-changes')
        .then(data => {
            if (!data) return;
            const tbody = document.getElementById('tbody-rate');
            if (!tbody) return;
            if (Array.isArray(data) && data.length > 0) {
                tbody.innerHTML = data.map(item => `
                    <tr>
                        <td class="text-center">${item.jmCd || '-'}</td>
                        <td>${item.cjNm || '-'}</td>
                        <td>${item.fundNm || '-'}</td>
                        <td class="text-center date-col">${formatDate(item.afIjaYmd) || '-'}</td>
                        <td>${item.fundNm || '-'}</td>
                        <td>${item.fundCd || '-'}</td>
                    </tr>
                `).join('');
            } else {
                tbody.innerHTML = `<tr><td colspan="4" class="text-center" style="color: #94a3b8; padding: 12px;">데이터 없음</td></tr>`;
            }
        });
}
