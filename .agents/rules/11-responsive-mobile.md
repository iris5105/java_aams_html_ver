---
trigger: always_on
---

# 11. 반응형 레이아웃 및 모바일 UX 개발 표준 가이드 (Responsive & Mobile UX)

본 문서는 AAMS 시스템의 반응형 브레이크포인트 표준, 모바일 세로 순차 스택(`layout-mobile-stack`), 290px 최소 높이 보장, 모바일 행 포커스 제어, 그리고 모바일 전용 MDI 탭 네비게이션 규격을 정의합니다.

---

## 1. 반응형 브레이크포인트 규격 (Responsive Breakpoint Standard)

공통 필터는 모든 해상도에서 라벨과 INPUT/DDDW/달력 컨트롤의 지정 크기를 유지한다. 공간이 부족하면 `.filter-item` 묶음 단위로 다음 줄에 배치하며, 모바일이라고 항목이나 컨트롤을 `width:100%`로 늘리지 않는다. 중첩 필터 프래그먼트는 공통 CSS의 `display:contents`를 통해 개별 항목이 상위 flex 레이아웃에서 줄바꿈된다. 화면별 명시적인 별도 배치(안내 문구 전용 행 등)는 화면 전용 CSS로 관리한다.

AAMS는 데스크톱 고해상도 모니터뿐만 아니라 현장 태블릿 및 모바일 기기에서의 원활한 조회를 위해 아래 2대 표준 브레이크포인트를 기준으로 동작합니다.

### 1.1 표준 브레이크포인트 정의
| 뷰포트 규격 | 브레이크포인트 | 권장 레이아웃 동작 |
| :--- | :--- | :--- |
| **데스크톱 (Desktop)** | `width > 1415px` | 3분할 이상 와이드 레이아웃, 그리드-리포트 병렬 배치 |
| **태블릿-L (Tablet Landscape)** | `876px < width <= 1415px` | 2분할 레이아웃 유지, 서브 패널 비율 압축 |
| **모바일 (Mobile)** | `width <= 876px` | **단일 컬럼 세로 스택 (`layout-mobile-stack`)**, 리포트/상세 뷰는 모달 팝업으로 분기 |

---

## 2. 모바일 레이아웃 세로 순차 스택 표준 (`layout-mobile-stack`)

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
    .layout-split-h > .split-gutter-h {
        display: none !important; /* 모바일에서는 스플리터 숨김 */
    }
}
```

---

## 3. 모바일 복합 그리드 최소 높이(290px) 및 세로 스크롤 표준 규격 (Zero-Squished-Grid)

1. **문제점 방어**:
   - 마스터-디테일 또는 3개 이상의 그리드가 배치된 복합 화면(예: `w_ja032a`, `w_ja032e_put`)에서 모바일(`width <= 876px`) 접근 시, 전체 높이가 3등분되어 각 그리드가 80~120px로 찌그러져 데이터가 1건밖에 안 보이는 현상을 원천 차단한다.
2. **최상위 세로 스크롤 컨테이너 (`.layout-mobile-stack-container`)**:
   - 화면 최상위 `.view-container`에 반드시 `.layout-mobile-stack-container`를 부여한다.
   - 모바일에서 `height: 100% !important; overflow-y: auto !important; -webkit-overflow-scrolling: touch !important; padding-bottom: 24px !important;`가 적용되어 화면 전체가 세로로 시원하게 스크롤된다.
3. **각 그리드 최소 높이(`290px`) 보장 (Zero-Squished-Grid 원칙)**:
   - 상단/좌측 마스터 그리드 및 하단/우측의 모든 서브/상세 그리드는 모바일에서 기본적으로 **최소 `290px` 이상의 높이**(`flex: 0 0 290px !important; height: 290px !important; min-height: 290px !important;`)를 보장받는다. 단, 두 pane이 모두 Tabulator인 단순 2분할은 가용 높이 50:50 규칙을 우선 적용한다.
   - 이를 통해 그리드 헤더 및 가로 스크롤바를 제외하고도 **최소 6~8건 이상의 데이터 행이 온전히 표출**되어 사용자가 한눈에 여러 데이터를 편안하게 조회할 수 있다.
4. **중첩 분할(Nested Split) 세로 순차 전개**:
   - `.layout-split-h` 내부에 `.layout-split-v`가 중첩된 구조라도, 모바일 환경에서는 스플릿바(`split-gutter-h`, `split-gutter-v`)가 숨겨지고 자식 그리드들이 위에서 아래로 순차 배치된다.

### 3.1 단순 Master·Detail과 복합 Split의 높이 규칙

- 단순 상하 Master·Detail 화면은 `.layout-split-v.layout-mobile-stack`을 사용한다. 공통 CSS가 상단과 하단 pane을 각각 `290px`로 고정해 DETAIL 그리드가 헤더만 남거나 0px로 축소되지 않도록 한다.
- 단순 DETAIL pane 내부의 `.pane-body`, `.grid-table-wrapper`, `.tabulator-aams-grid`, `.tabulator`는 부모 높이를 100%로 채우며, `min-height: 0`과 `overflow: hidden`을 유지한다.
- Split이 없는 단일 화면은 최하단 여백을 5px로 제한한다. 상하/좌우 두 pane이 모두 Tabulator이면 각 pane을 가용 높이의 50%로 나눈다.
- 두 pane 중 하나만 Tabulator이면 해당 그리드 pane은 약 10개 행이 보이는 360px을 확보하고, 반대 pane은 고정 높이를 두지 않고 내용 높이에 맞춰 확장한다.
- Master 그리드 + 입력 폼 DETAIL 조합은 모바일에서 DETAIL pane을 숨기고 선택 행 클릭 시 중앙 모달로 표시한다. 모달에는 닫기와 함께 DETAIL 새로고침·저장 액션을 제공하며, 데스크톱의 Split 동작은 유지한다.
- `.split-lr-container`, `.special-note-box`, `.io-grid-box`, 중첩 `.layout-split-h`/`.layout-split-v`가 포함된 복합 pane은 단순 규칙에서 제외하고 기존 nested 전용 규칙으로 세로 순차 배치한다.
- 중첩 Split이 상단 pane 또는 좌측 pane에 있는 경우에도 해당 부모 pane의 290px 고정을 해제하고, 내부 자식 pane을 각각 290px로 세로 배치한다. 부모의 `overflow:hidden` 때문에 두 번째 그리드가 잘리지 않도록 한다.
- 화면 템플릿에서 모바일 전용 `height: ... !important`를 반복 선언하지 않는다. 공통 규칙을 수정해야 할 때는 `layout-split-v.css`와 본 절의 예외 조건을 함께 갱신한다.

---

## 4. 모바일 환경과 그리드 Rowfocus 정책 연계

1. **리포트 뷰어가 있는 경우의 모바일 방어**:
   - 우측에 `reportViewer`가 있는 화면에서 모바일(`width <= 876px`)로 접근한 경우:
     - 조회 또는 새로고침 시 **첫 번째 행을 자동 선택하지 않는다 (deselect 유지)**.
     - 첫 행 자동 선택으로 인해 의도치 않은 전체화면 모바일 모달 팝업이 즉시 떠서 목록 조회를 방해하는 현상을 원천 방지한다.
     - 사용자가 특정 행을 명시적으로 터치/클릭했을 때에만 상세 모달이 팝업으로 표출된다.
2. **리포트 뷰어가 없는 경우**:
   - PC, 태블릿, 모바일 모든 환경에서 조회/새로고침 시 첫 번째 행을 자동 선택/포커스하여 상세 서브 그리드나 패널 데이터가 즉시 연동되도록 한다.

---

## 5. 모바일 환경 MDI 탭 네비게이션 및 오작동 닫힘 방지 표준 규격 (Tab Navigation Standard)

1. **문제점 방어**:
   - 모바일 환경에서 탭 박스 크기가 작아 탭 전환을 위해 터치할 때 닫기(x) 버튼이 함께 눌려 의도치 않게 탭이 닫히는 심각한 오작동을 원천 차단한다.
2. **상단 탭 바 이동 네비게이션 (`.tab-nav-btn-group`)**:
   - **모바일 전용 표출 원칙 (`width <= 876px`)**: 데스크톱 환경(`width > 876px`)에서는 탭 바에 충분한 여백이 있고 마우스 클릭 조작이 원활하므로 `.tab-nav-btn-group`은 **`display: none !important;`로 완전히 숨긴다.**
   - 모바일 환경(`width <= 876px`)에서 탭이 1개 이상 열려 있을 때에만 상단 탭 바 우측 [모두 닫기] 버튼 바로 좌측에 **`[◀] 1/3 [▶]` 형태의 이전/다음 탭 이동 컨트롤**이 활성화 표시(`.tab-nav-btn-group.active { display: inline-flex !important; }`)된다.
   - 탭이 2개 이상 열려 있을 때 이전(`btn-tab-prev`) 및 다음(`btn-tab-next`) 버튼이 활성화되어 닫기 위험 없이 탭간을 자유롭고 빠르게 순환 전환할 수 있다.
   - 중앙의 탭 카운터(`tab-nav-counter`)를 통해 현재 탭의 순번과 전체 열린 탭 수를 한눈에 파악할 수 있다.
3. **모바일 탭 박스 터치 영역 및 닫기 버튼 분리**:
   - 모바일에서 탭 박스 본체 클릭 시 무조건 해당 탭으로 **전환(`switchTab`)**되도록 안전 터치 영역을 보장한다.
   - 탭 박스 중앙에는 탭 순번 배지(`.tab-icon-badge`, `1`, `2`, `3`...)를 표출하여 직관성을 높인다.
   - 개별 탭 닫기(`x`) 버튼은 박스 전체를 덮지 않고 우측 상단에 작은 원형 영역으로 분리하여 의도치 않은 탭 닫힘을 원천 방지한다.
