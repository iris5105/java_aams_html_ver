/**
 * W_HOME5 Data Fetchers & Tabulator Grid Controllers
 */

let gridPublicStocks = null;
let gridSubscriptions = null;
let gridProposals = null;
let gridDayTr = null;
let gridGyul = null;
let gridRate = null;

function switchSubTab(tabId, el) {
    const gyulEl = document.getElementById('gyulTab');
    const rateEl = document.getElementById('rateTab');
    if (gyulEl) gyulEl.style.display = 'none';
    if (rateEl) rateEl.style.display = 'none';
    
    document.querySelectorAll('.panel-tab-item').forEach(item => item.classList.remove('active'));

    const target = document.getElementById(tabId);
    if (target) target.style.display = 'block';
    if (el) el.classList.add('active');

    if (tabId === 'rateTab') {
        if (!gridRate) initRateGrid();
        loadRateChanges();
        if (gridRate) gridRate.redraw(true);
    }
    if (tabId === 'gyulTab') {
        if (!gridGyul) initGyulGrid();
        loadGyulAccounts();
        if (gridGyul) gridGyul.redraw(true);
    }
}

// Global Tabulator Initializer for Home Page
document.addEventListener("DOMContentLoaded", function() {
    initHomeGrids();
});

function initHomeGrids() {
    initPublicStocksGrid();
    initSubscriptionsGrid();
    initProposalsGrid();
    initDayTrGrid();
    initGyulGrid();
}

// 1. 공모기본정보 (dw_4 / d_home04)
function initPublicStocksGrid() {
    const el = document.getElementById('grid-public-stocks');
    if (!el || gridPublicStocks) return;
    gridPublicStocks = new Tabulator(el, {
        layout: "fitColumns",
        height: "100%",
        placeholder: "<span>데이터가 없습니다.</span>",
        columns: [
            { title: "발행기관", field: "balhCo", hozAlign: "center", width: 100 },
            { title: "공모종목명", field: "jmNm", minWidth: 120 },
            { title: "공모일자", field: "ymd", hozAlign: "center", width: 90, formatter: cell => formatDate(cell.getValue()) },
            { title: "청약증권사", field: "jgTrCoNm", minWidth: 100 },
            { title: "시작일자", field: "startYmd", hozAlign: "center", width: 90, formatter: cell => formatDate(cell.getValue()) },
            { title: "마감일자", field: "endYmd", hozAlign: "center", width: 90, formatter: cell => formatDate(cell.getValue()) },
            { title: "납입일", field: "nabibYmd", hozAlign: "center", width: 90, formatter: cell => formatDate(cell.getValue()) },
            { title: "상장일자", field: "sjYmd", hozAlign: "center", width: 90, formatter: cell => formatDate(cell.getValue()) },
            { title: "수수료율(%)", field: "susuPer", hozAlign: "right", width: 90 },
            { title: "상장예정코드", field: "sjJmCd", hozAlign: "center", width: 100 },
            { title: "상장예정종목명", field: "xxSjJmCd", minWidth: 110 }
        ]
    });
}

function loadPublicStocks() {
    if (!gridPublicStocks) initPublicStocksGrid();
    safeFetchJson('/api/home/public-stocks')
        .then(data => {
            if (gridPublicStocks) gridPublicStocks.setData(Array.isArray(data) ? data : []);
        });
}

// 2. 수요예측참여내역(최근1개월) (dw_5 / d_home05)
function initSubscriptionsGrid() {
    const el = document.getElementById('grid-subscriptions');
    if (!el || gridSubscriptions) return;
    gridSubscriptions = new Tabulator(el, {
        layout: "fitColumns",
        height: "100%",
        placeholder: "<span>데이터가 없습니다.</span>",
        columns: [
            { title: "종목명", field: "jmNm", minWidth: 110 },
            { title: "상장예정종목", field: "jmCd", hozAlign: "center", width: 100, formatter: cell => cell.getValue() || (cell.getRow().getData() ? cell.getRow().getData().jmcd : null) || '-' },
            { title: "청약일", field: "cyYmd", hozAlign: "center", width: 90, formatter: cell => formatDate(cell.getValue()) },
            { title: "청약수량", field: "cyJusu", hozAlign: "right", width: 90, formatter: "money", formatterParams: { precision: 0 } },
            { title: "청약단가", field: "cyDanga", hozAlign: "right", width: 90, formatter: "money", formatterParams: { precision: 0 } },
            { title: "청약금액", field: "cyAek", hozAlign: "right", width: 100, formatter: "money", formatterParams: { precision: 0 } },
            { title: "매도제한", field: "lockEnd", hozAlign: "center", width: 90 }
        ]
    });
}

function loadSubscriptions() {
    if (!gridSubscriptions) initSubscriptionsGrid();
    safeFetchJson('/api/home/subscriptions')
        .then(data => {
            if (gridSubscriptions) gridSubscriptions.setData(Array.isArray(data) ? data : []);
        });
}

// 3. 시스템 개발 및 수정의뢰 현황 (dw_6 / d_home06)
function initProposalsGrid() {
    const el = document.getElementById('grid-proposals');
    if (!el || gridProposals) return;
    gridProposals = new Tabulator(el, {
        layout: "fitColumns",
        height: "100%",
        placeholder: "<span>데이터가 없습니다.</span>",
        columns: [
            { title: "의뢰일시", field: "ymd", hozAlign: "center", width: 120, formatter: cell => formatDate(cell.getValue(), true) },
            { title: "개발 의뢰내용", field: "title", minWidth: 150 },
            { title: "완료일시", field: "contentYmd", hozAlign: "center", width: 120, formatter: cell => formatDate(cell.getValue(), true) }
        ]
    });
}

function loadProposals() {
    if (!gridProposals) initProposalsGrid();
    safeFetchJson('/api/home/proposals')
        .then(data => {
            if (gridProposals) gridProposals.setData(Array.isArray(data) ? data : []);
        });
}

// 4. 당일거래현황 (dw_1 / d_home01)
function initDayTrGrid() {
    const el = document.getElementById('grid-daytr');
    if (!el || gridDayTr) return;
    gridDayTr = new Tabulator(el, {
        layout: "fitColumns",
        height: "100%",
        placeholder: "<span>데이터가 없습니다.</span>",
        columns: [
            { title: "거래유형", field: "jasanGb", minWidth: 90 },
            { title: "거래구분", field: "trCd", hozAlign: "center", width: 80 },
            { title: "건수", field: "trCount", hozAlign: "right", width: 80, formatter: "money", formatterParams: { precision: 0 } },
            { title: "거래금액", field: "trAek", hozAlign: "right", minWidth: 110, formatter: "money", formatterParams: { precision: 0 } },
            { title: "펀드수", field: "fundCount", hozAlign: "center", width: 70 }
        ]
    });
}

function loadDayTr() {
    if (!gridDayTr) initDayTrGrid();
    safeFetchJson('/api/home/day-tr')
        .then(data => {
            if (gridDayTr) gridDayTr.setData(Array.isArray(data) ? data : []);
        });
}

// 5-1. 당월결산계좌LIST (dw_2 / d_home02)
function initGyulGrid() {
    const el = document.getElementById('grid-gyul');
    if (!el || gridGyul) return;
    gridGyul = new Tabulator(el, {
        layout: "fitColumns",
        height: "100%",
        placeholder: "<span>데이터가 없습니다.</span>",
        columns: [
            { title: "계약만료월", field: "gyulYmd", hozAlign: "center", width: 100, formatter: cell => formatDate(cell.getValue()) },
            { title: "펀드코드", field: "fundCd", hozAlign: "center", width: 90 },
            { title: "펀드명", field: "fundNm", minWidth: 120 }
        ]
    });
}

function loadGyulAccounts() {
    if (!gridGyul) initGyulGrid();
    safeFetchJson('/api/home/gyul-accounts')
        .then(data => {
            if (gridGyul) gridGyul.setData(Array.isArray(data) ? data : []);
        });
}

// 5-2. 당월이자(만기) (dw_3 / d_home03)
function initRateGrid() {
    const el = document.getElementById('grid-rate');
    if (!el || gridRate) return;
    gridRate = new Tabulator(el, {
        layout: "fitColumns",
        height: "100%",
        placeholder: "<span>데이터가 없습니다.</span>",
        columns: [
            { title: "종목코드", field: "jmCd", hozAlign: "center", width: 90 },
            { title: "종목명", field: "cjNm", minWidth: 110 },
            { title: "펀드명", field: "fundNm", minWidth: 110 },
            { title: "이자수령일", field: "afIjaYmd", hozAlign: "center", width: 100, formatter: cell => formatDate(cell.getValue()) },
            { title: "계좌명", field: "fundNm", minWidth: 100 },
            { title: "관리번호", field: "fundCd", hozAlign: "center", width: 90 }
        ]
    });
}

function loadRateChanges() {
    if (!gridRate) initRateGrid();
    safeFetchJson('/api/home/rate-changes')
        .then(data => {
            if (gridRate) gridRate.setData(Array.isArray(data) ? data : []);
        });
}
