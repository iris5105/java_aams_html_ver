---
trigger: always_on
---

# 12. MRD 리포트 뷰어 개발 표준 가이드 (Crownix Report Viewer)

본 문서는 Crownix Reporting Server(MRD) 기반 서식 리포트 미리보기, PDF/Excel/Word/PPT/HWP 5종 포맷 내보내기, 공통 리포트 프래그먼트 연동, 그리고 일체형 제어 엔진인 `AamsReport.bindViewer`의 표준 사용 규격을 정의합니다.

---

## 1. MRD 리포트 아키텍처 개요 (Architecture Overview)

```
[클라이언트 웹 브라우저]
   │  1) AamsReport.bindViewer() 호출
   │  2) iframe preview 요청 / 5종 포맷 다운로드 요청
   ▼
[AAMS Spring Boot 백엔드]
   │  - /api/common/rd/preview
   │  - /api/common/rd/export
   │  - RdReportService (가변 파라미터 암호화 및 URL 토큰 생성)
   ▼
[Crownix Report Server (RD Server)]
   │  - rd_파일명.mrd 서식 파일 컴파일 및 데이터베이스 조회
   ▼
[HTML5 웹 리포트 뷰어 또는 바이너리 파일 다운로드 스트림]
```

---

## 2. 백엔드 공통 RD API 규격 (Backend Standard API)

개별 업무 컨트롤러에서 RD 리포트를 처리하기 위한 별도 컨트롤러를 생성하지 않으며, 백엔드 공통 서비스 [RdReportService.java](file:///d:/work/java_aams_html_ver/src/main/java/com/kfp/aams/common/service/RdReportService.java) 및 공통 엔드포인트를 사용합니다.

### 2.1 공통 엔드포인트 목록
- **미리보기 URL:** `/api/common/rd/preview`
  - 요청 파라미터: `mrdPath`, `corpGr`, 가변 비즈니스 파라미터들
  - 응답: 뷰어 임베딩용 최종 웹 리포트 렌더링 URL
- **내보내기 다운로드:** `/api/common/rd/export`
  - 요청 파라미터: `mrdPath`, `format` (`pdf` | `excel` | `word` | `ppt` | `hwp`), `corpGr`, `downloadName`
  - 응답: 첨부파일 바이너리 스트림 (`Content-Disposition: attachment; filename=...`)

---

## 3. 공통 리포트 뷰어 프래그먼트 마크업 (Fragment Markup)

HTML 템플릿 작성 시 리포트 뷰어 컨테이너를 직접 마크업하지 않고, [templates/fragments/report/report_viewer.html](file:///d:/work/java_aams_html_ver/src/main/resources/templates/fragments/report/report_viewer.html) 공통 프래그먼트를 사용합니다.

```html
<!-- 우측 또는 하단 리포트 패널 -->
<div class="split-pane split-right" id="reportPanel">
    <div th:replace="~{fragments/report/report_viewer :: reportViewer(
        title='펀드 운용보고서',
        modalId='fundReportMobileModal'
    )}"></div>
</div>
```

### 3.1 프래그먼트 내장 요소
- **리포트 헤더:** 리포트 제목(`h4.report-title`) 및 현재 상태/기준일 표출 라벨
- **5종 포맷 내보내기 툴바 (`.report-export-group`):**
  - PDF, Excel, Word, PPT, HWP 다운로드 버튼
  - 새 창 열기 버튼 (`.btn-open-window`)
- **임베디드 iframe:** MRD HTML5 뷰어가 표출되는 반응형 iframe (`#reportFrame`)
- **로딩 스피너:** 리포트 렌더링 중 표출되는 오버레이 스피너 (`.report-loading-spinner`)
- **모바일 모달 컨테이너:** `width <= 876px` 환경에서 전체화면으로 팝업되는 모달 다이얼로그

---

## 4. 자바스크립트 일체형 제어 엔진 (`AamsReport.bindViewer`)

개별 화면 스크립트에서 5종 내보내기 버튼 이벤트, 새 창 열기, 모바일 모달 팝업 제어, iframe 로딩 스피너 등을 중복 코딩하는 행위(Zero-Garbage Code 위반)를 절대 금지합니다.  
공통 스크립트 [common.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/common.js)의 `AamsReport.bindViewer(currentPane, config)` 1개로 일괄 바인딩합니다.

### 4.1 일체형 바인딩 표준 예시
```javascript
var reportViewer = (window.AamsReport && typeof window.AamsReport.bindViewer === 'function')
    ? window.AamsReport.bindViewer(currentPane, {
        reportFile: 'rd_ja010b.mrd',             // MRD 서식 파일명
        modalId: 'fundReportMobileModal',         // 모바일 모달 ID (생략 시 기본 reportMobileModal)
        zoom: '120',                              // 줌 비율 (기본 120, 'page-width' 등 가능)
        
        // 1) 회사그룹 동적 반환
        getCorpGr: function () { 
            return resolveCorpGr(currentPane); 
        },
        
        // 2) MRD 서식으로 전달할 가변 파라미터 빌더
        buildParams: function (data) {
            return {
                fund_cd: data.fundCd || '',
                fund_nm: data.fundNm || '',
                ymd: getFilterYmd(currentPane, 'YYYY.MM.DD')
            };
        },
        
        // 3) 리포트 뷰어 상단 헤더 타이틀 동적 생성
        getTitle: function (data) {
            return (data.fundNm || '') + ' (' + (data.fundCd || '') + ') 일별운용보고서';
        },
        
        // 4) 상태 및 기준 정보 표출 텍스트
        getStatus: function (data, params) {
            return "조회일자: " + getFilterYmd(currentPane);
        },
        
        // 5) 5종 포맷 다운로드 시 파일명 규칙
        getDownloadName: function (data, params) {
            var safeNm = (data.fundNm || '').trim().replace(/[\\/:*?"<>|]/g, "_") || "보고서";
            return (getFilterYmd(currentPane) || '') + "_" + safeNm + "(" + (data.fundCd || '') + ")";
        },
        
        // 6) 선택적 사전 검증 훅 (원장 미생성 체크 등 필요 시)
        onBeforePreview: function (data, proceed) {
            // 원장 생성 여부 확인이 필요한 경우 비동기 체크 후 proceed() 호출
            proceed();
        }
    })
    : null;
```

---

## 5. 마스터 그리드와 리포트 연동 표준 (`syncDetail`)

마스터 그리드의 행 선택 시 PC 환경과 모바일 환경을 분기 처리합니다.

```javascript
function syncDetail(row, masterRowData) {
    if (!row) return;
    var data = masterRowData || (row.getData ? row.getData() : null);
    if (!data) return;

    // 키값 동일 여부 중복 호출 가드
    var currentKey = (data.corpGr || "") + "_" + (data.fundCd || "");
    if (lastLoadedMasterKey === currentKey) return;
    lastLoadedMasterKey = currentKey;

    // 디바이스 환경 감지 및 리포트 로딩 분기
    if (AamsReport.isMobileView(currentPane)) {
        // 모바일 환경: 사용자가 명시적으로 행을 클릭했을 때만 모달 팝업 오픈
        if (isUserClick && reportViewer) {
            reportViewer.openMobile(data);
        }
    } else {
        // PC / 태블릿 환경: 우측 임베디드 패널에 리포트 즉시 로드
        if (reportViewer) {
            reportViewer.loadPreview(data);
        }
    }
}
```

---

## 6. 상단 공통 [엑셀] 버튼과의 연동

상단 공통 툴바의 [엑셀] 버튼 클릭 시, 화면 내에 그리드가 주 대상인 경우 그리드 엑셀 내보내기를 수행하지만, **MRD 리포트가 주 화면인 경우 리포트의 Excel 포맷 내보내기를 트리거**합니다.

```javascript
currentPane.onExcel = function () {
    if (reportViewer && currentSelectedRowData) {
        // 리포트 뷰어의 엑셀 내보내기 엔진 호출
        reportViewer.exportFormat('excel');
    } else if (gridMaster) {
        // 리포트 미선택 시 기본 마스터 그리드 다운로드
        gridMaster.download("xlsx", "목록.xlsx", { sheetName: "Sheet1" });
    }
};
```
