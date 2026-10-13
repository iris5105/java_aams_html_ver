---
trigger: always_on
description: "상단 공통 툴바, 필터바 프래그먼트, f_dddwctl 드롭다운, AamsCalendar, DynamicCodeSearch 및 공통 JS 유틸리티 연동 표준 가이드"
---

# 04. 공통 컴포넌트 및 JS 유틸리티 표준 가이드 (Common Components & JS Guide)

본 가이드는 AAMS 시스템의 상단 공통 툴바 표준 계약, 데이터윈도우(dw_c) 기반 상단 필터바 프래그먼트 구성, 웹 표준 UX 조회 정책, DDDW 드롭다운(`f_dddwctl.js`), 달력 컴포넌트(`aams_calendar.js`), 다이나믹 코드 검색(`dynamic_code_search.js`), 그리고 재사용 공통 JavaScript 함수 사용 규격을 정의합니다.

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
  4. 안내 토스트 표출 (`showToast("화면이 초기화되었습니다.", "info");`)

```javascript
pane.onClear = pane.onRefresh = function () {
    if (gridMaster) gridMaster.clearData();
    if (gridDetail) gridDetail.clearData();

    // 상태 키 및 선택 행 완전 리셋 (새로고침 후 재조회 시 첫 행 연동 보장)
    lastLoadedMasterKey = null;
    lastLoadedSubKey = null;
    currentMasterRowData = null;

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

## 3. 상단 필터바 프래그먼트 연동 규격 (Filter Fragment Standard)

상단 필터바 영역을 개별 화면마다 임의로 HTML로 직접 작성하지 않고, 참조하는 파워빌더 창(`srw`)의 `dw_c` 컨트롤이 사용하는 데이터윈도우 객체(`dataobject`)를 확인하여 공통 프래그먼트를 연동합니다.

### 3.1 공통 필터 프래그먼트 매핑표 (`templates/fragments/filter/`)
| dw_c dataobject | 프래그먼트 파일 | 설명 및 파라미터 |
| :--- | :--- | :--- |
| `dc_ymd` | `dc_ymd.html` | 단일 기준일자 필터 (`filter(label='기준일자')`) |
| `dc_ymd_dddw` | `dc_ymd_dddw.html` | 일자 + DDDW 드롭다운 필터 (`filter(labelYmd='...', labelDddw='...')`) |
| `dc_xx_ymd` | `dc_xx_ymd.html` | 시작일자 ~ 종료일자 기간 필터 |
| `dc_fund_ymd` | `dc_fund_ymd.html` | 펀드코드 검색 + 기준일자 필터 |

### 3.2 동적 라벨 변경 표준
화면별로 필터 라벨을 변경해야 하는 경우 아래 세 가지 방식 중 하나를 사용합니다:
1. **타임리프 프래그먼트 파라미터 전달:**
   ```html
   <div th:replace="~{fragments/filter/dc_ymd :: filter(label='LOAD기일')}"></div>
   ```
2. **`th:with` 컨텍스트 변수 지정:**
   ```html
   <div th:replace="~{fragments/filter/dc_ymd_dddw :: filter}" th:with="labelYmd='매매일자', labelDddw='거래구분'"></div>
   ```
3. **클라이언트 자바스크립트 함수 호출:**
   ```javascript
   setFilterLabel('filterYmd', 'LOAD기일');
   ```

### 3.3 전폭 배경색 단절 방지 래퍼 구조
필터 영역과 화면 전용 서브 버튼(예: 체결등록, NEW체결, 평잔재계산 등)이 공존할 때 배경색 단절이 발생하지 않도록 전체 영역을 `<div class="filter-bar">`로 감싸고 분할 배치합니다:
```html
<div class="filter-bar">
    <!-- 좌측 공통 필터 컴포넌트 -->
    <div class="filter-left">
        <div th:replace="~{fragments/filter/dc_ymd :: filter(label='기준일자')}"></div>
    </div>
    <!-- 우측 화면 전용 액션 버튼 -->
    <div class="filter-actions">
        <button type="button" class="btn btn-secondary btn-sm" id="btnRecalc">평잔재계산</button>
        <button type="button" class="btn btn-primary btn-sm" id="btnRegister">체결등록</button>
    </div>
</div>
```

---

## 4. DDDW 드롭다운 컴포넌트 (`f_dddwctl.js`)

파워빌더 화면(`srw`)의 스크립트에 `f_dddwctl` 함수 호출이 있는 항목은 공통 스크립트 [f_dddwctl.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/f_dddwctl.js)를 사용하여 일관된 2칸 드롭다운 리스트로 구성합니다.

### 4.1 핵심 규격
1. **드롭다운 리스트 2칸 분할 구성:**
   - DDDW로 표출되는 모든 선택 목록은 **2칸 (앞: 코드, 뒤: 코드명)**으로 분할 표시합니다.
2. **화면 표출 규격:**
   - 그리드 셀이나 선택 input 요소에는 사용자가 직관적으로 인지할 수 있도록 **코드명(텍스트)**이 표출되도록 처리합니다.
   - 서버 전송 시에는 코드(Value)가 매핑됩니다.

### 4.2 호출 예시 (그리드 에디터 연동)
```javascript
{
    title: "거래구분",
    field: "trGb",
    width: 120,
    hozAlign: "center",
    editor: "list",
    editorParams: {
        autocomplete: true,
        valuesLookup: function(cell, filterTerm) {
            return fDddwctl.lookup({
                corpGr: resolveCorpGr(currentPane),
                dddwName: "d_dddw_tr_gb",
                displayFormat: "name" // 화면에는 명칭 표시, 내부값은 코드
            });
        }
    },
    formatter: function(cell) {
        return fDddwctl.getName("d_dddw_tr_gb", cell.getValue()) || cell.getValue() || "";
    }
}
```

---

## 5. 달력 컴포넌트 (`aams_calendar.js`)

기준일자 및 기간 선택 시 [aams_calendar.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/aams_calendar.js)의 `AamsCalendar` 컴포넌트를 사용합니다.

### 5.1 하이라이트 모드 분기 규격 (규칙 16번)
파워빌더 원본 소스(`.srw`)의 `dw_c` 이벤트 구현 여부에 따라 달력 모드를 분기합니다:
- **하이라이트 모드:** `srw` 파일에 `dw_c.ue_getdate` 이벤트가 존재하는 경우, 영업일/거래일 목록을 서버에서 조회하여 특정 일자가 강조되는 하이라이트 모드로 전달합니다.
- **순정 모드:** `dw_c.ue_getdate` 이벤트가 없는 경우 순정 상태의 표준 달력으로 표출합니다.

### 5.2 달력 연동 예시
```javascript
// 하이라이트 모드 달력 초기화
AamsCalendar.init({
    inputSelector: '#filterYmd',
    btnSelector: '#btnCalendar',
    highlightMode: true, // dw_c.ue_getdate 이벤트 존재 시 true
    getCorpGr: function() { return resolveCorpGr(currentPane); },
    onSelect: function(selectedDate) {
        // 주의: 날짜 선택 시 자동으로 조회를 호출하지 않음 (값 바인딩만 수행)
        document.getElementById('filterYmd').value = selectedDate;
    }
});
```

---

## 6. 다이나믹 코드 검색 컴포넌트 (`dynamic_code_search.js`)

파워빌더의 `f_find_code` 호출이나 종목/펀드/거래처 등 팝업 검색이 필요한 경우 [dynamic_code_search.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/dynamic_code_search.js)의 `DynamicCodeSearch`를 사용합니다.

### 6.1 핵심 규격
1. **양방향 바인딩:** 코드 검색 팝업에서 특정 행을 선택하면 코드 필드와 명칭 필드가 함께 바인딩됩니다.
2. **수기 입력 후 포커스 아웃 연동:** 코드 input에 사용자가 직접 6~12자리 코드를 수기 입력한 경우 `DynamicCodeSearch.searchByCode`를 통해 서버에서 명칭을 즉시 조회하여 명칭 input/셀에 자동 채번합니다.
3. **필터 변경 시 자동 조회 금지 준수:** 코드 검색으로 특정 종목이나 계좌가 선택되었더라도 전체 그리드 데이터 조회는 자동으로 실행하지 않고 상단 [조회] 버튼 클릭 시에 실행합니다.

### 6.2 다이나믹 코드 검색 연동 예시
```javascript
// 종목 검색 팝업 바인딩
DynamicCodeSearch.bind({
    btnSelector: "#btnSearchItem",
    codeSelector: "#itemCd",
    nameSelector: "#itemNm",
    searchType: "ITEM", // 종목 검색
    getCorpGr: function() { return resolveCorpGr(currentPane); },
    onSelect: function(selectedItem) {
        document.getElementById("itemCd").value = selectedItem.itemCd || "";
        document.getElementById("itemNm").value = selectedItem.itemNm || "";
    }
});
```

---

## 7. 공통 JS 유틸리티 함수 (개별 중복 작성 엄격 금지)

공통 스크립트 [common.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/common.js)에 이미 정의된 유틸리티 함수들을 무조건 재사용하며, 개별 화면 스크립트 내에서 함수를 로컬로 재정의하는 행위(Zero-Garbage Code 위반)를 엄격히 금지합니다.

### 7.1 회사그룹(`corpGr`) 추출
```javascript
// 금지: function resolveCorpGr() { ... } 로컬 작성
// 표준 사용:
var corpGr = resolveCorpGr(currentPane); // 또는 getFilterCorpGr(currentPane)
```

### 7.2 조회일자(`filterYmd`) 추출
```javascript
// 금지: function getFilterYmd() { ... } 로컬 작성
// 표준 사용:
var ymdDefault = getFilterYmd(currentPane);                // "2026-10-13" (YYYY-MM-DD 기본형)
var ymdRaw     = getFilterYmd(currentPane, 'YYYYMMDD');     // "20261013"   (8자리 순수 숫자)
var ymdDot     = getFilterYmd(currentPane, 'YYYY.MM.DD');   // "2026.10.13" (점 구분자)
```

### 7.3 공통 UI 토스트 알림 및 대화상자
브라우저 기본 `window.alert`는 UI 흐름을 차단하고 심미성을 해치므로 절대 사용하지 않고 공통 모달/토스트를 호출합니다:
```javascript
// 1) 토스트 알림 (type: 'info' | 'success' | 'warning' | 'error', duration 기본 3000ms)
showToast("정상적으로 처리되었습니다.", "success");
showToast("필수 입력 항목이 누락되었습니다.", "warning", 4000);

// 2) 확인 대화상자 모달
showAlert("작업을 진행하시겠습니까?", function() {
    console.log("사용자 확인 완료");
});

// 3) 모달 백드롭 및 ESC 키 닫기 바인딩
setupModalBackdrop(modalElement, function() {
    modalElement.style.display = 'none';
});
```

### 7.4 숫자, 통화 및 백분율 포맷터
```javascript
// 1) 천단위 콤마 및 소수점 자리수 포맷팅
var formattedNum = formatNumber(1234567.89, 2); // "1,234,567.89"
var integerNum   = formatNumber(1234567, 0);    // "1,234,567"

// 2) 백분율 포맷팅
var formattedPct = formatPercent(12.3456, 2);   // "12.35%"
```
