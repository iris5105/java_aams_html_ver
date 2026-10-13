---
trigger: always_on
description: "MDI 탭 조각 뷰 라이프사이클, AamsSplitter 드래그 리사이징 레이아웃, 모바일/태블릿 반응형 브레이크포인트 표준 가이드"
---

# 05. MDI 탭 및 분할 레이아웃 / 반응형 표준 가이드 (Layout & Responsive Guide)

본 가이드는 AAMS 시스템의 MDI(Multi-Document Interface) 동적 탭 로딩 환경에서의 단일 초기화 진입점 패턴, 무결성 스크립트 격리 원칙, `AamsSplitter`를 이용한 유연한 화면 분할 레이아웃, 그리고 모바일/태블릿 다바이스 대응을 위한 반응형 브레이크포인트 표준 규격을 정의합니다.

---

## 1. MDI 단일 진입점 초기화 패턴 (Single Entry-Point Pattern)

AAMS는 MDI 탭 구조로 동작하므로, 개별 업무 화면 HTML은 완전한 문서가 아닌 메인 프레임워크의 탭 컨테이너(`div.tab-pane`)로 동적 로드(AJAX/Fetch)되는 **조각 뷰(Fragment View)**입니다.

### 1.1 중복 초기화 방지 (`startInit`)
브라우저 환경에 따라 `DOMContentLoaded`와 `document.readyState === 'complete'` 체크가 중복 트리거되어 그리드가 이중 생성되거나 이벤트 리스너가 중복 바인딩되는 문제를 차단하기 위해 반드시 `isInitialized` 플래그를 사용하는 단일 진입점 패턴을 적용합니다.

```javascript
(function() {
    var currentScript = document.currentScript;
    var pane = currentScript ? (currentScript.closest('.tab-pane') || currentScript.closest('.view-container')) : null;
    if (!pane) pane = document.querySelector('.tab-pane.active') || document;
    var isInitialized = false;

    function startInit() {
        if (isInitialized) return;
        isInitialized = true;

        // 1) 그리드 초기화
        initGrids();
        // 2) 상단 툴바 및 필터 바인딩
        initToolbarAndFilters();
        // 3) 스플리터 바인딩
        initSplitter();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", startInit);
    } else {
        startInit();
    }
})();
```

### 1.2 공통 스크립트 및 스타일 중복 로드 엄격 금지 (Zero-Garbage Code)
- MDI 메인 프레임(`index.html`)에서 이미 공통 CSS(`tabulator-custom.css`, `style.css`, `report-viewer.css` 등)와 공통 라이브러리(`tabulator.min.js`, `flatpickr.min.js`, `common.js`, `aams_splitter.js` 등)를 로드하고 있습니다.
- 개별 탭 조각 뷰 HTML 내에서 `<script src="...">`나 `<link rel="stylesheet">` 태그로 공통 자원을 다시 불러오는 행위를 엄격히 금지합니다.
- 조각 뷰 내부에는 순수 화면 템플릿 마크업과 해당 화면 전용 `<script>` 블록만을 포함합니다.

---

## 2. AamsSplitter 분할 레이아웃 표준 (Splitter Layout)

마스터-디테일 화면, 그리드-리포트 화면, 또는 복수 그리드 비교 화면은 공통 모듈 [aams_splitter.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/aams_splitter.js)를 사용하여 사용자가 마우스 드래그로 너비나 높이를 조절할 수 있도록 구성합니다.

### 2.1 좌우 수평 분할 레이아웃 (`.layout-split-h`)
```html
<div class="layout-split-h" id="splitHorizontalContainer">
    <!-- 좌측 패널 (예: 마스터 그리드) -->
    <div class="split-pane split-left" style="width: 50%;">
        <div class="panel-header">마스터 목록</div>
        <div class="panel-body">
            <div id="gridMaster" class="tabulator-custom-grid"></div>
        </div>
    </div>

    <!-- 스플리터 드래그 바 -->
    <div class="gutter-h"></div>

    <!-- 우측 패널 (예: 상세 그리드 또는 리포트) -->
    <div class="split-pane split-right" style="width: 50%;">
        <div class="panel-header">상세 내역</div>
        <div class="panel-body">
            <div id="gridDetail" class="tabulator-custom-grid"></div>
        </div>
    </div>
</div>
```

### 2.2 상하 수직 분할 레이아웃 (`.layout-split-v`)
```html
<div class="layout-split-v" id="splitVerticalContainer">
    <!-- 상단 패널 -->
    <div class="split-pane split-top" style="height: 55%;">
        <div id="gridTop" class="tabulator-custom-grid"></div>
    </div>

    <!-- 상하 스플리터 드래그 바 -->
    <div class="gutter-v"></div>

    <!-- 하단 패널 -->
    <div class="split-pane split-bottom" style="height: 45%;">
        <div id="gridBottom" class="tabulator-custom-grid"></div>
    </div>
</div>
```

### 2.3 자바스크립트 스플리터 바인딩 및 그리드 리사이징 동기화
스플리터 드래그로 패널의 크기가 변경되면 Tabulator 그리드의 가상 렌더링 뷰포트를 재계산해야 하므로 반드시 `onResize` 콜백에서 `grid.redraw(true)`를 호출합니다.

```javascript
function initSplitter() {
    if (!window.AamsSplitter) return;

    AamsSplitter.create({
        container: "#splitHorizontalContainer",
        gutter: ".gutter-h",
        direction: "horizontal", // "horizontal" 또는 "vertical"
        minSize: [300, 300],     // 각 패널의 최소 크기 (px)
        onResize: function() {
            if (gridMaster) gridMaster.redraw(true);
            if (gridDetail) gridDetail.redraw(true);
        }
    });
}
```

---

## 3. 상세 패널 데이터 수정 권한 및 양방향 보호 동기화 (Form Protection)

데이터의 수정 권한이 특정 조건(예: 본인이 작성한 건, 결재 전 상태 등)에만 부여되는 화면의 경우, 그리드 셀의 편집 가능 여부뿐만 아니라 상세 폼 패널의 입력 요소들에도 일관되게 잠금 처리를 동기화합니다.

```javascript
function updateFormEditLock(isEditable) {
    var form = document.getElementById("detailForm");
    if (!form) return;

    var inputs = form.querySelectorAll("input, textarea, select");
    inputs.forEach(function(el) {
        if (isEditable) {
            el.removeAttribute("readonly");
            el.removeAttribute("disabled");
            el.classList.remove("input-locked");
        } else {
            el.setAttribute("readonly", "readonly");
            if (el.tagName === "SELECT") el.setAttribute("disabled", "disabled");
            el.classList.add("input-locked"); // 배경색 잠금 (#f1f5f9)
        }
    });
}
```

---

## 4. 반응형 브레이크포인트 규격 (Responsive Breakpoint Standard)

AAMS는 데스크톱 고해상도 모니터뿐만 아니라 현장 태블릿 및 모바일 기기에서의 원활한 조회를 위해 아래 2대 표준 브레이크포인트를 기준으로 동작합니다.

### 4.1 표준 브레이크포인트 정의
| 뷰포트 규격 | 브레이크포인트 | 권장 레이아웃 동작 |
| :--- | :--- | :--- |
| **데스크톱 (Desktop)** | `width > 1415px` | 3분할 이상 와이드 레이아웃, 그리드-리포트 병렬 배치 |
| **태블릿-L (Tablet Landscape)** | `876px < width <= 1415px` | 2분할 레이아웃 유지, 서브 패널 비율 압축 |
| **모바일 (Mobile)** | `width <= 876px` | **단일 컬럼 세로 스택 (`layout-mobile-stack`)**, 리포트/상세 뷰는 모달 팝업으로 분기 |

### 4.2 모바일 레이아웃 세로 순차 스택 표준 (`layout-mobile-stack`)
`width <= 876px` 환경에서는 가로 스플리터나 병렬 분할이 자동으로 해제되고 세로 스택 구조로 전환됩니다:
```css
/* tabulator-custom.css 또는 layout 공통에 정의된 반응형 규칙 */
@media (max-width: 876px) {
    .layout-split-h {
        flex-direction: column !important;
    }
    .layout-split-h > .split-pane {
        width: 100% !important;
        height: auto !important;
        flex: none !important;
    }
    .layout-split-h > .gutter-h {
        display: none !important; /* 모바일에서는 스플리터 숨김 */
    }
}
```

### 4.3 모바일 환경과 그리드 Rowfocus 정책 연계
- [02-tabulator-grid.md](file:///d:/work/java_aams_html_ver/.agents/rules/02-tabulator-grid.md)에 명시된 바와 같이, 우측에 `reportViewer`가 있는 화면에서 모바일(`width <= 876px`)로 접근한 경우:
  - 조회 또는 새로고침 시 **첫 번째 행을 자동 선택하지 않습니다.**
  - 첫 행 자동 선택으로 인해 의도치 않은 전체화면 모바일 모달 팝업이 즉시 떠서 목록 조회를 방해하는 현상을 원천 방지합니다.
  - 사용자가 특정 행을 명시적으로 터치/클릭했을 때에만 상세 모달이 팝업으로 표출됩니다.

---

## 5. 컨테이너 높이 및 스크롤 관리 표준 (Container Dimensions)

MDI 탭 내부에서 불필요한 이중 브라우저 스크롤바가 발생하지 않고 Tabulator 그리드 내부의 자체 가상 스크롤이 올바르게 작동하도록 컨테이너 치수를 엄격히 관리합니다.

1. **최상위 컨테이너:**
   - `.tab-pane` 직하위의 메인 래퍼는 `height: 100%`, `display: flex`, `flex-direction: column`, `overflow: hidden` 구조를 유지합니다.
2. **그리드 래퍼 패널:**
   - 그리드가 위치하는 패널은 `flex: 1`, `height: 100%`, `min-height: 0`을 지정하여 브라우저 창 크기가 조절될 때 그리드가 컨테이너 잔여 공간을 100% 채우도록 설계합니다.
3. **윈도우 리사이즈 동기화:**
   - 윈도우 창 크기가 변경될 때 Tabulator 그리드가 크기를 즉시 인지하도록 공통 리스너가 바인딩되어 있으며, 필요 시 `grid.redraw(true)`를 호출합니다.
