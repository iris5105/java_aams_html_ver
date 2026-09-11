# 01. 공통 유틸리티 및 레포트 뷰어 규격 (`common.js`, `AamsReport`)

## 1. 개요 및 설계 목적

본 문서는 AAMS 웹 시스템의 클라이언트 공통 스크립트인 [common.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/common.js)의 핵심 아키텍처와 레포트 뷰어 확대 비율(`AamsReport`), 그리고 데이터 그리드(Tabulator) 행 선택 표준 규격에 대해 기술합니다.

---

## 2. 레포트 뷰어 확대 비율 공통 모듈 (`AamsReport`)

### 2.1 설계 배경
- 파워빌더 원본 소스([u_rd.sru](file:///d:/work/java_aams_html_ver/pb_recource/TOP/u_rd.sru#L89))에서는 `INT ii_zoomRatio = 120`을 통해 전체 리포트 뷰어의 기본 확대 배율을 120%로 고정하고 있었습니다.
- 웹 전환 시스템에서는 브라우저의 `<iframe>`을 통해 PDF 스트림을 렌더링하므로, 현대 웹 브라우저(Chrome, Edge, Firefox)의 표준 PDF Open Parameters인 `#zoom=120`을 URL 해시 파라미터로 제어합니다.
- 각 화면마다 하드코딩하지 않고, `common.js`의 `AamsReport` 유틸리티를 통해 일괄적으로 중앙 집중 제어합니다.

### 2.2 구현 코드 (`common.js`)
```javascript
/**
 * AAMS Report Viewer 공통 유틸리티
 * 파워빌더 u_rd.sru의 ii_zoomRatio = 120 표준 규격 반영
 */
window.AamsReport = {
    DEFAULT_ZOOM: 120, // 공통 기본 확대 배율 (120%)

    /**
     * 리포트 미리보기 URL에 표준 PDF 파라미터(기본 zoom=120, toolbar, navpanes) 부착
     * @param {string} url - 원본 리포트 URL
     * @param {number|string} [zoom] - 지정 확대 배율 (기본값: DEFAULT_ZOOM = 120)
     * @returns {string} 해시 파라미터가 포함된 최종 뷰어 URL
     */
    formatPreviewUrl: function(url, zoom) {
        if (!url || url === 'about:blank') return url || '';
        var targetZoom = (zoom !== undefined && zoom !== null) ? zoom : this.DEFAULT_ZOOM;
        var cleanUrl = url.split('#')[0];
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
    }
};
```

### 2.3 각 화면에서의 사용 방법
```javascript
// 1) 미리보기 URL 생성 시
var rawUrl = "/api/daily/ja020k/preview?seriesGb=" + seriesGb + "&ymd=" + ymd;
var previewUrl = AamsReport.formatPreviewUrl(rawUrl); // 결과: /api/daily/ja020k/preview?...#toolbar=1&navpanes=0&zoom=120

// 2) iframe에 직접 설정 시
AamsReport.setFrameSrc(iframeElement, rawUrl);
```

---

## 3. 그리드 행 선택 삼중 안전망 (Triple Fallback)

### 3.1 문제점 및 해결 방안
- Tabulator 그리드 내에서 편집 가능 셀(input, 드롭다운 등)이 클릭될 때 이벤트 전파 중단(`stopPropagation`)이 발생하거나, 브라우저 환경에 따라 이벤트 버블링 타이밍이 달라 행 선택이 누락되는 현상이 발생할 수 있습니다.
- 이를 방지하기 위해 개발 가이드(규칙 8)에 따라 **삼중 안전망(Triple Fallback)**을 표준 계약으로 적용합니다.

### 3.2 구현 표준 규격
```javascript
// 1) 전역 헬퍼 연결 (캡처링/버블링 단일 이벤트 바인딩)
setupTabulatorRowSelection(gridMaster, function(row, data) {
    syncDetail(row, data);
});

// 2) rowClick 이벤트 안전망
gridMaster.on("rowClick", function(e, row) {
    syncDetail(row, row ? row.getData() : null);
});

// 3) rowSelectionChanged 이벤트 안전망
gridMaster.on("rowSelectionChanged", function(data, rows) {
    if (rows && rows.length > 0) {
        syncDetail(rows[0], rows[0].getData());
    }
});
```

### 3.3 상세 연동 함수 (`syncDetail`) 가드 패턴
마스터 행을 연이어 클릭했을 때 불필요한 중복 API 호출을 방지하기 위해 키 비교 가드를 반드시 적용합니다:
```javascript
let lastLoadedMasterKey = null;

function syncDetail(row, masterRowData) {
    if (!row) return;
    if (!row.isSelected || !row.isSelected()) {
        row.select();
    }
    var data = masterRowData || (row.getData ? row.getData() : null);
    if (!data) return;

    // 복합 키 구성 (회사코드 + 메인키)
    var currentKey = (data.corpGr || "") + "_" + (data.fundCd || data.mainKey || "");
    if (lastLoadedMasterKey === currentKey) return; // 중복 호출 방지 가드
    lastLoadedMasterKey = currentKey;

    // 하위 상세 리포트 또는 디테일 그리드 조회 호출
    loadDetailReport(data);
}
```

---

## 4. MDI 탭 다중 초기화 방지 패턴 (`startInit`)

### 4.1 문제점
- 다중 탭(MDI) 환경에서는 `tab_manager.js`에 의해 동적으로 HTML 뷰가 로드됩니다.
- 이때 `DOMContentLoaded` 이벤트와 `document.readyState === "complete"` 조건이 겹치면서 이벤트 리스너와 Tabulator 그리드가 2회 중복 생성되는 문제가 발생할 수 있습니다.

### 4.2 표준 단일 진입점 패턴
```javascript
(function() {
    var currentScript = document.currentScript;
    var pane = currentScript ? (currentScript.closest('.tab-pane') || currentScript.closest('.view-container')) : document;
    
    var isInitialized = false;

    function startInit() {
        if (isInitialized) return;
        isInitialized = true;

        initCalendar();
        initDddw();
        initGrid();
        bindEvents();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", startInit);
    } else {
        startInit();
    }
})();
```

---

## 5. 공통 툴바 표준 계약 함수 (규칙 9)

상단 공통 툴바(`fragments/tab_header :: toolbarButtons`)는 개별 버튼의 클릭 이벤트를 직접 작성하지 않고, 탭 패널 객체(`pane`)에 표준 계약 함수를 등록하여 호출받습니다:

| 계약 함수명 | 호출 시점 | 주요 역할 |
|---|---|---|
| `pane.onSearch` / `pane.onRetrieve` | 상단 [조회] 버튼 클릭 시 | 필터 조건으로 마스터 그리드 또는 리포트 재조회 |
| `pane.onCorpGrChange` | 상단 회사 선택 드롭다운 변경 시 | 기준일자 재조회 및 화면 데이터 전체 재조회 |
| `pane.onRefresh` | 상단 [새로고침] 버튼 클릭 시 | 그리드 clear, iframe 초기화(`about:blank`), 진입 초기 상태 복원 |
| `pane.onInput` | 상단 [입력] 버튼 클릭 시 | 신규 행 추가 (`grid.addRow({}, true)`) |
| `pane.onSave` | 상단 [저장] 버튼 클릭 시 | 변경된 행 추출 후 저장 API 호출 |
