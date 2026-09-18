# 07. 반응형 스플리터 및 그리드 표준 색상/스타일 규격 (`aams_splitter.js`, `tabulator-custom.css`)

## 1. 개요 및 설계 목적

본 문서는 AAMS 웹 시스템에서 **화면 패널 분할(`aams_splitter.js`)**, **데이터 그리드 색상 표준화(`tabulator-custom.css`)**, 그리고 **MDI 환경에서의 공통 스크립트/스타일 재사용 원칙(Zero-Garbage Code, Zero-Inline-Style)**에 대해 상세히 기술합니다.

---

## 2. 반응형 대화형 스플리터 (`aams_splitter.js`)

### 2.1 설계 배경 및 기능
- 마스터-상세(Master-Detail), 마스터-리포트(Master-Report) 등의 분할 레이아웃 화면에서 사용자가 원하는 비율로 패널 크기를 자유롭게 드래그 조절할 수 있도록 지원합니다.
- 기본 비율 60:40(마스터 60%, 상세/리포트 40%)을 제공하며, 조절된 위치는 브라우저 `localStorage`에 자동 저장되어 재방문 시 복원됩니다.
- 우측 패널에 Crownix Report 뷰어(`<iframe>`)가 배치된 경우, 마우스 드래그 리사이징 시 마우스 포인터가 iframe 내부로 진입하여 이벤트가 가로채이는 현상을 방지하기 위해 드래그 중 `disableIframePointerEvents` 및 `.is-splitter-resizing` 오버레이 보호 메커니즘을 자체 내장하고 있습니다.

### 2.2 표준 HTML 레이아웃 규격

#### A. 좌우 수평 분할 (Horizontal Split)
```html
<div class="layout-split-h" data-split-key="unique_screen_key">
    <div class="split-pane split-left">
        <!-- 좌측 마스터 그리드 / 목록 영역 -->
    </div>
    <div class="splitter-gutter splitter-gutter-h" title="좌우 드래그하여 크기 조절"></div>
    <div class="split-pane split-right">
        <!-- 우측 상세 그리드 / 폼 / 리포트 뷰어 영역 -->
    </div>
</div>
```

#### B. 상하 수직 분할 (Vertical Split)
```html
<div class="layout-split-v" data-split-key="unique_screen_key">
    <div class="split-pane split-top">
        <!-- 상단 마스터 그리드 -->
    </div>
    <div class="splitter-gutter splitter-gutter-v" title="상하 드래그하여 크기 조절"></div>
    <div class="split-pane split-bottom">
        <!-- 하단 상세 그리드 / 패널 -->
    </div>
</div>
```

### 2.3 클라이언트 JS 초기화
화면 초기화 진입점(`startInit`)에서 1줄로 호출합니다:
```javascript
if (window.AamsSplitter && typeof window.AamsSplitter.init === 'function') {
    AamsSplitter.init(pane);
}
```

---

## 3. Tabulator 그리드 표준 색상 시스템 (`tabulator-custom.css`)

### 3.1 원칙: Zero-Inline-Style
- Tabulator 컬럼 정의(`columns`)의 `title`이나 셀 포매터(`formatter`) 내부에 `style="color:..."` 등의 인라인 스타일을 절대로 직접 작성하지 않습니다.
- 모든 색상 및 배지, 강조 표시는 [tabulator-custom.css](file:///d:/work/java_aams_html_ver/src/main/resources/static/css/tabulator-custom.css)의 공통 클래스를 사용합니다.

### 3.2 컬럼 헤더 타이틀 색상 (`headerCssClass`)
파워빌더 DataWindow(.srd) 색상 매핑 규격:
```javascript
{ title: "종목명", field: "itemNm", headerCssClass: "col-hdr-blue" }   // PB color="16711680" (파랑)
{ title: "상환일", field: "payYmd", headerCssClass: "col-hdr-red" }    // PB color="128"/"255" (빨강)
{ title: "펀드코드", field: "fundCd", headerCssClass: "col-hdr-green" } // PB color="32768" (초록)
{ title: "발행정보", field: "balhInfo", headerCssClass: "col-hdr-balh" } // 주황색 헤더
```

### 3.3 데이터 셀 포매터 텍스트 색상
포매터에서 특정 텍스트를 강조할 때 공통 클래스를 부여한 `<span>` 태그를 반환합니다:
- 파란색 텍스트: `<span class="cell-text-blue">...</span>`
- 빨간색 텍스트: `<span class="cell-text-red">...</span>`
- 초록색 텍스트: `<span class="cell-text-green">...</span>`
- 회색 비활성 텍스트: `<span class="cell-text-muted">...</span>`

### 3.4 등락률 및 가격 변동
- 상승/플러스(빨간색, `▲`): `<span class="cell-price-up">`
- 하락/마이너스(파란색, `▼`): `<span class="cell-price-down">`

### 3.5 거래구분 및 상태/파일 배지
- 거래구분: `.cell-tr-buy`, `.cell-tr-sell`, `.cell-tr-in`, `.cell-tr-out`, `.cell-tr-acquire`
- 상태 배지: `.badge-status-success` (정상/초록), `.badge-status-error` (오류/빨강)
- 첨부파일 배지: `.file-badge`
- 완료/해지 행 시각적 잠금: `row.getElement().classList.add('row-completed');`

---

## 4. MDI 조각 뷰 작성 및 가비지 코드 방지 원칙 (Zero-Garbage Code)

### 4.1 공통 전역 스크립트 중복 선언 금지
메인 프레임워크인 [w_home5.html](file:///d:/work/java_aams_html_ver/src/main/resources/templates/views/home/w_home5.html)의 `<head>`에 다음 5개 전역 스크립트가 이미 로드되어 있습니다:
1. `common.js` (전역 유틸리티, `resolveCorpGr`, `setupTabulatorRowSelection`, `AamsReport`, `aamsCellEdit` 등)
2. `aams_calendar.js` (`AamsCalendar`)
3. `f_dddwctl.js` (`f_dddwctl`)
4. `dynamic_code_search.js` (`openDynamicSearchModal`)
5. `aams_splitter.js` (`AamsSplitter`)

**규칙**: MDI 탭으로 동적 로드되는 조각 템플릿(`.html`) 내부에서는 상기 5개 스크립트에 대한 `<script src="...">` 태그를 중복 선언하지 않고, 전역 객체를 직접 호출합니다.

### 4.2 공통 스타일 중복 선언 금지
행 선택 하이라이트(`.tabulator-selected`), 인라인 편집 테두리(`.cell-editable-blue`), MRD 리포트 내보내기 버튼(`.btn-export-format`) 등은 공통 CSS에 이미 구현되어 있으므로 각 화면 템플릿에 로컬 `<style>` 블록을 생성하지 않습니다.
