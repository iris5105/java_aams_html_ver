---
trigger: always_on
---

# 08. 상단 공통 툴바 및 웹 표준 수동 조회 정책 가이드 (Toolbar & Query Policy)

본 문서는 AAMS 시스템의 상단 공통 툴바 표준 계약, MDI 탭 pane 바인딩, 새로고침 시 완전 리셋(Zero-Stale-Key), 웹 표준 UX 수동 조회 단일 정책, 그리고 필터 액션 버튼 인접 배치 규격을 정의합니다.

---

## 1. 상단 공통 툴바 표준 계약 (Toolbar Standard Contract)

화면 내에 [조회], [입력], [저장] 등의 액션 버튼을 임의로 중복 생성하지 않고, 시스템 상단 공통 툴바(`fragments/tab_header :: toolbarButtons`)를 사용하며 화면 스크립트에서 `currentPane` 객체에 표준 계약 함수를 바인딩합니다.

### 1.1 표준 계약 함수 목록
| 계약 함수 | 파워빌더 매핑 이벤트 | 설명 |
| :--- | :--- | :--- |
| `pane.onSearch = function() { ... }` | `ue_retrieve`, `clicked` on cb_retrieve | 상단 [조회] 버튼 클릭 시 호출 |
| `pane.onInput = function() { ... }` | `ue_insert`, `clicked` on cb_insert | 상단 [입력] (행 추가) 버튼 클릭 시 호출 |
| `pane.onSave = function() { ... }` | `ue_save`, `clicked` on cb_save | 상단 [저장] 버튼 클릭 시 호출 |
| `pane.onCorpGrChange = function(newCorpGr) { ... }` | `ue_corp_change`, `rbuttondown` on dw_corp | 상단 회사그룹 선택 변경 시 호출 |
| `pane.onExcel = function() { ... }` | `ue_excel` | 상단 [엑셀] 내보내기 버튼 클릭 시 호출 |
| `pane.onRefresh = function() { ... }` | `ue_reset`, `clicked` on cb_reset | 상단 [새로고침] 버튼 클릭 시 호출 |
| `pane.onDelete = function() { ... }` | `ue_delete`, `clicked` on cb_delete | 상단 [삭제] 버튼 클릭 시 호출 (필요 시) |

### 1.2 툴바 바인딩 표준 예시
```javascript
// 상단 공통 툴바 이벤트 바인딩
currentPane.onSearch = function() {
    loadMasterData();
};

currentPane.onInput = function() {
    addNewRow();
};

currentPane.onSave = function() {
    saveData();
};

currentPane.onCorpGrChange = function(newCorpGr) {
    // 주의: 필터 변경 시 자동 조회를 실행하지 않음 (규칙 2항 준수)
    // 필요한 경우 하이라이트 달력 날짜 목록 갱신 등의 메타데이터만 업데이트
    updateCalendarHighlightDates(newCorpGr);
};

currentPane.onExcel = function() {
    if (grid) {
        grid.download("xlsx", "데이터목록_" + getFilterYmd(currentPane, "YYYYMMDD") + ".xlsx", { sheetName: "목록" });
    }
};

currentPane.onRefresh = function() {
    // 새로고침 시에만 그리드 및 입력 폼 초기화 수행
    if (grid) grid.clearData();
    resetDetailPanel();
};
```

### 1.3 MDI 환경 `pane` 컨테이너 획득 표준 규격 (Zero-Hardcoded-ID & Pane Scoping)
MDI 프레임워크의 상단 공통 툴바(`button.js`)는 버튼 클릭 시 `getActiveTabPane(btn)`을 통해 최상위 MDI 탭 엘리먼트인 **`.tab-pane`**을 기준으로 계약 함수(`pane.onSearch`, `pane.onSave` 등)를 탐색합니다.
- **금지 패턴**: `document.getElementById('pane-W_...')`와 같이 임의의 ID를 하드코딩하거나, 자식 요소인 `.view-container`에만 계약 함수를 바인딩하면 툴바 버튼 클릭 시 이벤트를 수신하지 못합니다.
- **표준 패턴**: 반드시 `document.currentScript`를 활용하여 상위 `.tab-pane`을 획득하고, 양방향 폴백을 지정합니다:
  ```javascript
  const currentScript = document.currentScript;
  const pane = currentScript ? (currentScript.closest('.tab-pane') || currentScript.closest('.view-container')) : null;
  ```

### 1.4 새로고침(`onRefresh`) 시 상태 완전 초기화 (Zero-Stale-Key 원칙)
새로고침 실행 시 그리드 데이터만 비우고 상태 변수를 유지하면 심각한 연동 결함이 발생합니다.
- **상태 키 누락 시 결함**: 마스터-디테일 중복 fetch 방지 가드 키(`lastLoadedMasterKey`)가 남아 있으면, 새로고침 후 [조회]를 눌러 첫 번째 행이 자동 선택(Row Focus)될 때 이전 키와 동일하여 **상세 서브 그리드 조회가 차단(`return`)**됩니다.
- **필수 초기화 목록**:
  1. 모든 연동 그리드 데이터 클리어 (`gridMaster.clearData()`, `gridDetail.clearData()` 등)
  2. 마스터/서브 중복 조회 가드 키 초기화 (`lastLoadedMasterKey = null; lastLoadedSubKey = null;`)
  3. 선택된 행 데이터 캐시 초기화 (`currentMasterRowData = null; currentSelectedRow = null;`)
  4. **자동 조회(재조회) 절대 호출 금지**: 새로고침은 화면 상태를 초기화(Reset)하는 기능이므로, 핸들러 내부에서 `loadMasterData()`, `loadFundList()` 등의 조회 API를 호출해서는 안 됩니다. 실제 조회가 필요하면 사용자가 상단 [조회] 버튼(`pane.onSearch`)을 클릭해야 합니다.
  5. 표준 안내 토스트 표출 (`showToast("화면이 초기화되었습니다.", "info");`)

```javascript
pane.onClear = pane.onRefresh = function () {
    if (gridMaster) gridMaster.clearData();
    if (gridDetail) gridDetail.clearData();

    // 상태 키 및 선택 행 완전 리셋 (새로고침 후 재조회 시 첫 행 연동 보장)
    lastLoadedMasterKey = null;
    lastLoadedSubKey = null;
    currentMasterRowData = null;

    // 주의: 여기서 loadData() 등의 조회를 절대 자동 호출하지 않는다!

    if (typeof showToast === 'function') {
        showToast("화면이 초기화되었습니다.", "info");
    }
};
```

---

## 2. 상단 필터 및 수동 조회 단일 정책 (웹 표준 UX 정책)

> [!IMPORTANT]
> **필터 조건 변경 시 자동 조회 절대 금지 및 기존 데이터 유지 표출 원칙**  
> 레거시 파워빌더와 달리 웹 표준 UX에서는 불필요한 네트워크 트래픽과 화면 깜빡임을 방지하고 사용자의 의도된 시점에 조회가 실행되도록 단일 규격을 강제합니다.

1. **필터 및 조회 버튼 상시 활성화 (Always Enabled):**
   - 상단 필터바의 입력 요소(날짜 인풋, 달력 버튼, 드롭다운, 코드 검색 등) 및 상단 툴바의 [조회] 버튼은 데이터 조회 실행 여부와 관계없이 항상 활성화(`enabled`) 상태를 유지합니다.
   - 조회 완료 후 필터나 조회 버튼을 잠그거나(`disabled`), 새로고침을 강제하지 않습니다.
2. **필터 조건 변경 시 자동 조회 절대 금지:**
   - 상단 필터바의 날짜 선택(달력 팝업 선택, 날짜 input change/input), DDDW 드롭다운 변경, 다이나믹 코드 검색 팝업 선택, 회사그룹 변경(`pane.onCorpGrChange`) 등 **필터 조건이 변경될 때 자동으로 조회를 실행(`loadData`, fetch 등)하지 않습니다.**
3. **필터 변경 시 기존 데이터 유지 규격:**
   - 사용자가 필터 조건을 변경하더라도, 테이블(그리드)이나 상세 패널에 표시된 데이터는 사용자가 상단 툴바의 [조회] 버튼을 클릭하여 새 데이터 조회가 완료되기 전까지 **기존 데이터를 그대로 유지하여 표출**합니다.
   - 필터 변경 이벤트에서 `grid.clearData()` 등으로 기존 데이터를 비우지 않습니다.
4. **수동 조회 단일 실행 원칙:**
   - 실제 데이터 조회 및 테이블 갱신은 **사용자가 상단 툴바의 [조회] 버튼(`pane.onSearch`)을 클릭했을 때에만 단독으로 실행**됩니다.
   - *예외 (초기 자동 조회):* 파워빌더 화면 원본에 `boolean eb_direct_retrieve = true` 구문이 명시된 경우에 한해, 화면 최초 진입 시 1회 자동 조회는 허용됩니다.

---

## 3. 필터 및 관련 액션 버튼 동일 컨테이너 인접 배치 표준 (UX 일체화 원칙)

> [!IMPORTANT]
> **필터와 동일한 공간에 있는 액션 버튼은 `.filter-left` 내에 하나의 div로 묶어서 나란히 배치**  
> 와이드 모니터나 고해상도 환경에서 화면 전용 액션 버튼(예: 변동성재계산, 평잔재계산, 엑셀종가IMPORT 등)이 오른쪽 끝(`.filter-actions`)으로 멀리 떨어져 있으면 사용자의 시선 이동과 마우스 동선이 길어져 극심한 UX 불편을 초래합니다.  
> 따라서 필터와 관련된 버튼은 오른쪽 끝으로 분리하지 않고, 반드시 필터 프래그먼트와 함께 **동일한 `<div class="filter-left">` 내부에 하나의 그룹으로 묶어서** 필터 조건 바로 우측에 나란히 표출합니다.

```html
<div class="filter-bar">
    <!-- 필터 컴포넌트와 관련 액션 버튼을 하나의 filter-left 그룹으로 일체화 -->
    <div class="filter-left">
        <div th:replace="~{fragments/filter/dc_ymd :: filter(label='기준일자')}"></div>
        <button type="button" class="t-btn btn-action" id="btnJa032aRecalculate" title="변동성 재계산 실행">
            <i class="fa-solid fa-calculator"></i> 변동성재계산
        </button>
    </div>
</div>
```
