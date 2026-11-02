---
trigger: always_on
---

# 10. MDI 탭 및 스플리터 분할 레이아웃 개발 표준 가이드 (Layout & Splitter)

본 문서는 AAMS 시스템의 MDI 동적 탭 로딩 환경에서의 단일 초기화 진입점 패턴(`startInit`), 무결성 스크립트 격리 원칙, `AamsSplitter`를 이용한 분할 레이아웃, 파워빌더 `.srw` 소스 분석 기반 레이아웃 매핑, 그리고 컨테이너 높이/폼 잠금 표준을 정의합니다.

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
    <div class="split-pane pane-left" style="width: 50%;">
        <div class="panel-header">마스터 목록</div>
        <div class="panel-body">
            <div id="gridMaster" class="tabulator-custom-grid"></div>
        </div>
    </div>

    <!-- 스플리터 드래그 바 -->
    <div class="split-gutter-h"></div>

    <!-- 우측 패널 (예: 상세 그리드 또는 리포트) -->
    <div class="split-pane pane-right" style="width: 50%;">
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
    <div class="split-pane pane-top" style="height: 55%;">
        <div id="gridTop" class="tabulator-custom-grid"></div>
    </div>

    <!-- 상하 스플리터 드래그 바 -->
    <div class="split-gutter-v"></div>

    <!-- 하단 패널 -->
    <div class="split-pane pane-bottom" style="height: 45%;">
        <div id="gridBottom" class="tabulator-custom-grid"></div>
    </div>
</div>
```

### 2.3 패널 및 거터 클래스 계약 (CSS / AamsSplitter 공통 규격)

> [!IMPORTANT]
> 공통 CSS(`layout-split-h.css`, `layout-split-v.css`)와 `AamsSplitter`는 아래의 **정확한 클래스명**으로 직접 자식 패널과 거터를 찾습니다. 별칭을 새로 만들거나 과거 예제의 클래스명을 사용하면 스플리터 초기화, 드래그, 모바일 세로 전개 규칙이 적용되지 않습니다.

| 분할 방향 | 좌표 패널 클래스 | 거터 클래스 | 금지하는 과거/임의 클래스 |
| :--- | :--- | :--- | :--- |
| 좌우 (`.layout-split-h`) | 좌측 `.pane-left`, 우측 `.pane-right` | `.split-gutter-h` | `.split-left`, `.split-right`, `.gutter-h` |
| 상하 (`.layout-split-v`) | 상단 `.pane-top`, 하단 `.pane-bottom` | `.split-gutter-v` | `.split-top`, `.split-bottom`, `.gutter-v` |

- 모든 패널에는 의미를 명확히 하기 위해 `split-pane`를 함께 부여합니다. 예: `class="split-pane pane-left"`.
- 패널과 거터는 분할 컨테이너의 **직접 자식**이어야 하며 순서는 `첫 패널 → 거터 → 두 번째 패널`을 유지합니다.
- 중첩 분할도 동일합니다. 외부 좌우 분할은 `.pane-left/.pane-right`, 내부 상하 분할은 `.pane-top/.pane-bottom`만 사용합니다.
- 구현·리뷰 전 `AamsSplitter.init(pane)` 호출과 위 클래스 계약을 함께 확인합니다. CSS를 화면별로 복제하거나 전역 선택자에 별칭을 추가하지 않습니다.

### 2.4 자바스크립트 스플리터 초기화 표준 (`AamsSplitter.init(rootEl)`)

> [!CAUTION]
> **존재하지 않는 `AamsSplitter.create(...)` 임의 호출 엄격 금지 (TypeError 방어)**  
> `aams_splitter.js` 모듈에는 `create(...)` 함수가 존재하지 않으며, 단일 표준 진입점인 **`AamsSplitter.init(rootEl)`**만을 지원합니다.  
> 임의의 `AamsSplitter.create({ container, direction, ... })`를 호출하면 `Uncaught TypeError: window.AamsSplitter.create is not a function` 런타임 오류가 발생합니다.

스플리터 드래그 종료 시 `aams_splitter.js` 내부 엔진(`onMouseUp`)에서 패널 내 Tabulator 그리드를 재계산합니다. 단, Tabulator가 `tableBuilt` 되기 전이거나 탭이 숨겨진 상태에서는 redraw를 실행하지 않도록 `safeRedraw` 가드와 활성화 이벤트를 함께 사용합니다. Splitter는 그리드 DOM이 생성된 뒤, 화면당 한 번만 초기화합니다.
따라서 개별 화면 스크립트에서는 다음과 같이 최상위 `pane`을 전달하여 초기화합니다:

```javascript
// 스플리터 초기화 표준 (AamsSplitter.init 단일 진입점 호출)
function initSplitter() {
    if (window.AamsSplitter && typeof window.AamsSplitter.init === 'function') {
        window.AamsSplitter.init(currentPane);
    }
}
```

---

## 3. 파워빌더 소스(.srw) 기반 윈도우 상속 및 스플릿바 정밀 분석 매핑 표준

> [!WARNING]
> **다른 화면 레이아웃 맹목적 복사 절대 금지 및 .srw 원본 컨트롤 좌표 검증 필수 원칙**  
> 유사한 업무 도메인이라 하더라도 화면마다 부모 윈도우 클래스나 스플릿바의 방향이 완전히 다를 수 있습니다. 타 화면 마크업을 임의로 복사하지 말고 대상 `.srw` 파일의 상속 구조와 좌표를 직접 확인해야 합니다.

1. **파워빌더 부모 윈도우 클래스(`from ...`) 식별**:
   * `from wt_vertdetail`: **좌우 수평 분할(Vertical Detail) 계열**  
     기본적으로 좌측이 `dw_list`(마스터), 우측이 `dw_detail`(디테일)이며, 중앙에 수직 스플릿바(`pf_u_splitbar_vertical`)가 존재합니다. 웹 마크업은 기본 **`.layout-split-h`**가 최상위가 됩니다.
   * `from wt_sheet` / `from wt_maindetail`: **상하 수직 분할(Horizontal Sheet) 계열**  
     기본적으로 상단이 `dw_list`(마스터), 하단이 `dw_detail`(디테일)이며, 중앙에 수평 스플릿바(`pf_u_splitbar_horizontal`)가 존재합니다. 웹 마크업은 기본 **`.layout-split-v`**가 최상위가 됩니다.
   * `from wt_dual`: **좌우 1:1 대등 비교 계열** (좌측 패널과 우측 패널 50:50 분할).

2. **스플릿바 컨트롤 및 드래그 대상 오브젝트 확인**:
   * `pf_u_splitbar_vertical`: 화면을 좌우로 나누는 수직 바 (`.split-gutter-h`)
   * `pf_u_splitbar_horizontal`: 화면을 상하로 나누는 수평 바 (`.split-gutter-v`)
   * 속성 중 `leftdragobject`, `rightdragobject`, `topdragobject`, `bottomdragobject`를 반드시 확인하여 어느 그리드들이 하나의 패널로 묶여 리사이징되는지 식별합니다.

3. **3개 이상 그리드 복합 중첩 분할(Nested Split) 2대 표준 패턴**:
   * **패턴 A: 좌측 마스터 1개 + 우측 상하 디테일 2개 (예: `w_ja032e_put`)**:
     * 원본 구조: 부모 `wt_vertdetail`의 좌측 `dw_list` + 우측에 가로 스플릿바 `st_port`(`pf_u_splitbar_horizontal`)로 분할된 `dw_port`(상단)와 `dw_detail`(하단).
     * 웹 표준 마크업: 외부 **`.layout-split-h`** (좌: `.pane-left`, 우: `.pane-right`) 내부에, 우측 패널(`.pane-right`)이 **`.layout-split-v`** (상: `.pane-top`, 하: `.pane-bottom`)를 포함하는 중첩 구조:
       ```html
       <div class="layout-split-h split-body layout-mobile-stack" data-split-key="PGM_H" data-default-ratio="42:58">
           <!-- 좌측: 마스터 그리드 (전체 높이 활용) -->
           <div class="pane-left master-section">
               <div id="gridList" class="tabulator-aams-grid"></div>
           </div>
           <div class="split-gutter-h"></div>
           <!-- 우측: 상하 2분할 영역 -->
           <div class="pane-right detail-section">
               <div class="layout-split-v" data-split-key="PGM_V" data-default-ratio="38:62">
                   <div class="pane-top">
                       <div id="gridSub" class="tabulator-aams-grid"></div>
                   </div>
                   <div class="split-gutter-v"></div>
                   <div class="pane-bottom">
                       <div id="gridDetail" class="tabulator-aams-grid"></div>
                   </div>
               </div>
           </div>
       </div>
       ```
   * **패턴 B: 상단 마스터 1개 + 하단 좌우 디테일 2개 (예: `w_ja032a`)**:
     * 원본 구조: 상단 `dw_list` + 하단에 세로 스플릿바로 분할된 `dw_port`(하단 좌)와 `dw_detail`(하단 우).
     * 웹 표준 마크업: 외부 **`.layout-split-v`** (상: `.pane-top`, 하: `.pane-bottom`) 내부에, 하단 패널(`.pane-bottom`)이 **`.layout-split-h`** (좌: `.pane-left`, 우: `.pane-right`)를 포함하는 중첩 구조.

### 3.1 모바일 중첩 Split 높이 표준

- `width <= 876px`에서는 `.layout-mobile-stack`이 있는 상하/좌우 Split을 세로 순차 배치하고, 각 그리드 pane은 공통 CSS에서 최소 290px을 확보합니다.
- 내부 `.layout-split-v`가 외부 좌측 pane 또는 외부 상단 pane에 놓이는 경우에도 부모의 고정 290px/`overflow:hidden`을 해제하여 내부 두 pane이 모두 표시되도록 합니다.
- 화면 템플릿에는 이 예외를 위한 개별 `height`/`overflow` CSS를 추가하지 않고 `layout-split-h.css`, `layout-split-v.css`의 중첩 규칙을 사용합니다.

---

## 4. 상세 패널 데이터 수정 권한 및 양방향 보호 동기화 (Form Protection)

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

## 5. 컨테이너 높이 및 스크롤 관리 표준 (Container Dimensions)

MDI 탭 내부에서 불필요한 이중 브라우저 스크롤바가 발생하지 않고 Tabulator 그리드 내부의 자체 가상 스크롤이 올바르게 작동하도록 컨테이너 치수를 엄격히 관리합니다.

1. **최상위 컨테이너:**
   - `.tab-pane` 직하위의 메인 래퍼는 `height: 100%`, `display: flex`, `flex-direction: column`, `overflow: hidden` 구조를 유지합니다.
2. **그리드 래퍼 패널:**
   - 그리드가 위치하는 패널은 `flex: 1`, `height: 100%`, `min-height: 0`을 지정하여 브라우저 창 크기가 조절될 때 그리드가 컨테이너 잔여 공간을 100% 채우도록 설계합니다.
3. **윈도우 리사이즈 동기화:**
   - 윈도우 창 크기가 변경될 때 Tabulator 그리드가 크기를 즉시 인지하도록 공통 리스너가 바인딩되어 있으며, 필요 시 `grid.redraw(true)`를 호출합니다.
