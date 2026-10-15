---
trigger: always_on
---

# 09. 공통 컴포넌트 및 프론트엔드 JS 개발 표준 가이드 (Common Components & JS Guide)

본 문서는 데이터윈도우(dw_c) 기반 상단 필터바 프래그먼트 연동, DDDW 드롭다운(`f_dddwctl.js`), 달력 컴포넌트(`aams_calendar.js`), 다이나믹 코드 검색(`dynamic_code_search.js`), 그리고 재사용 공통 JavaScript 함수 사용 규격을 정의합니다.

---

## 1. 상단 필터바 프래그먼트 연동 규격 (Filter Fragment Standard)

상단 필터바 영역을 개별 화면마다 임의로 HTML로 직접 작성하지 않고, 참조하는 파워빌더 창(`srw`)의 `dw_c` 컨트롤이 사용하는 데이터윈도우 객체(`dataobject`)를 확인하여 공통 프래그먼트를 연동합니다.

### 1.1 공통 필터 프래그먼트 매핑표 (`templates/fragments/filter/`)
| dw_c dataobject | 프래그먼트 파일 | 설명 및 파라미터 |
| :--- | :--- | :--- |
| `dc_ymd` | `dc_ymd.html` | 단일 기준일자 필터 (`filter(label='기준일자')`) |
| `dc_ymd_dddw` | `dc_ymd_dddw.html` | 일자 + DDDW 드롭다운 필터 (`filter(labelYmd='...', labelDddw='...')`) |
| `dc_xx_ymd` | `dc_xx_ymd.html` | 시작일자 ~ 종료일자 기간 필터 |
| `dc_fund_ymd` | `dc_fund_ymd.html` | 펀드코드 검색 + 기준일자 필터 |

### 1.2 동적 라벨 변경 표준
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

---

## 2. DDDW 드롭다운 컴포넌트 (`f_dddwctl.js`)

파워빌더 화면(`srw`)의 스크립트에 `f_dddwctl` 함수 호출이 있는 항목은 공통 스크립트 [f_dddwctl.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/f_dddwctl.js)를 사용하여 일관된 2칸 드롭다운 리스트로 구성합니다.

### 2.1 핵심 규격
1. **드롭다운 리스트 2칸 분할 구성:**
   - DDDW로 표출되는 모든 선택 목록은 **2칸 (앞: 코드, 뒤: 코드명)**으로 분할 표시합니다.
2. **화면 표출 규격:**
   - 그리드 셀이나 선택 input 요소에는 사용자가 직관적으로 인지할 수 있도록 **코드명(텍스트)**이 표출되도록 처리합니다.
   - 서버 전송 시에는 코드(Value)가 매핑됩니다.

### 2.2 호출 예시 (그리드 에디터 연동)
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

### 2.3 상단 필터바 DDDW 드롭다운 (`dc_ymd_dddw`) 초기화 및 Zero-Hardcoding 표준
상단 필터 컴포넌트 [dc_ymd_dddw.html](file:///d:/work/java_aams_html_ver/src/main/resources/templates/fragments/filter/dc_ymd_dddw.html)를 연동할 때 사용하는 표준 규칙입니다:

1. **정확한 요소 셀렉터 (`#filterDddw`) 사용**:
   - 프래그먼트에 정의된 `<select>`의 고유 ID는 **`filterDddw`**입니다.
   - 임의의 비표준 ID(`#dddwSelect` 등)를 탐색하거나 하드코딩해서는 안 됩니다.
2. **공통 헬퍼 `initFilterDddw` 필수 사용**:
   - 임의의 미정의 함수(`fDddwctl.loadSelect` 등)를 호출하지 않고, [common.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/common.js)의 표준 유틸리티인 **`initFilterDddw(currentPane, config)`**를 호출합니다:
     ```javascript
     function initFilterBrokerDddw() {
         var corpGr = resolveCorpGr(currentPane);
         return initFilterDddw(currentPane, {
             selectId: 'filterDddw',
             dddwId: 'tr_co_cd',
             corpGr: corpGr,
             seq: 1,
             codeTitle: '코드',
             nameTitle: '매매처명',
             onSelect: function (code, name) {
                 // 규칙 준수: 필터 조건 변경 시 자동 조회는 절대 실행하지 않음
             }
         });
     }
     ```
   - `initFilterDddw`는 서버 API(`/api/common/dddw`) 조회 및 `f_dddwctl.get2ColItemFormatter`와 연동되어 **[코드 | 명칭] 2칸 분할 드롭다운**으로 자동 포맷팅되며, 화면 셀렉트박스에는 명칭이 표출됩니다.
3. **선택값 추출 시 Zero-Hardcoding 원칙 및 유효성 검증**:
   - 주문 생성이나 파라미터 전달 시 선택된 코드값을 읽을 때 삼항 연산자로 임의의 코드(예: `'00003'`)를 fallback 하드코딩하지 않습니다.
   - 값이 없는 경우 반드시 사용자에게 선택 유도 토스트를 띄우고 작업을 차단합니다:
     ```javascript
     var dddwSelect = currentPane.querySelector('#filterDddw, select[name="dddw"]');
     var trCoCd = dddwSelect ? (dddwSelect.value || '').trim() : '';
     if (!trCoCd) {
         if (typeof showToast === 'function') showToast("상단 필터에서 매매처를 선택해주세요.", "warning");
         return;
     }
     ```
4. **회사그룹 변경(`pane.onCorpGrChange`) 연동**:
   - 상단 회사그룹 변경 시 드롭다운 초기화 함수를 다시 호출하여 해당 회사그룹의 DDDW 목록으로 즉시 갱신합니다.

---

## 3. 달력 컴포넌트 (`aams_calendar.js`)

기준일자 및 기간 선택 시 [aams_calendar.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/aams_calendar.js)의 `AamsCalendar` 컴포넌트를 사용합니다.

### 3.1 하이라이트 모드 분기 규격
파워빌더 원본 소스(`.srw`)의 `dw_c` 이벤트 구현 여부에 따라 달력 모드를 분기합니다:
- **하이라이트 모드:** `srw` 파일에 `dw_c.ue_getdate` 이벤트가 존재하는 경우, 영업일/거래일 목록을 서버에서 조회하여 특정 일자가 강조되는 하이라이트 모드로 전달합니다.
- **순정 모드:** `dw_c.ue_getdate` 이벤트가 없는 경우 순정 상태의 표준 달력으로 표출합니다.

### 3.2 달력 연동 예시
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

## 4. 다이나믹 코드 검색 컴포넌트 (`dynamic_code_search.js`)

파워빌더의 `f_find_code` 호출이나 종목/펀드/거래처 등 팝업 검색이 필요한 경우 [dynamic_code_search.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/dynamic_code_search.js)의 `DynamicCodeSearch`를 사용합니다.

### 4.1 핵심 규격
1. **양방향 바인딩:** 코드 검색 팝업에서 특정 행을 선택하면 코드 필드와 명칭 필드가 함께 바인딩됩니다.
2. **수기 입력 후 포커스 아웃 연동:** 코드 input에 사용자가 직접 6~12자리 코드를 수기 입력한 경우 `DynamicCodeSearch.searchByCode`를 통해 서버에서 명칭을 즉시 조회하여 명칭 input/셀에 자동 채번합니다.
3. **필터 변경 시 자동 조회 금지 준수:** 코드 검색으로 특정 종목이나 계좌가 선택되었더라도 전체 그리드 데이터 조회는 자동으로 실행하지 않고 상단 [조회] 버튼 클릭 시에 실행합니다.

### 4.2 다이나믹 코드 검색 연동 예시
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

## 5. 공통 JS 유틸리티 함수 (개별 중복 작성 엄격 금지)

공통 스크립트 [common.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/common.js)에 이미 정의된 유틸리티 함수들을 무조건 재사용하며, 개별 화면 스크립트 내에서 함수를 로컬로 재정의하는 행위(Zero-Garbage Code 위반)를 엄격히 금지합니다.

### 5.1 회사그룹(`corpGr`) 추출
```javascript
// 금지: function resolveCorpGr() { ... } 로컬 작성
// 표준 사용:
var corpGr = resolveCorpGr(currentPane); // 또는 getFilterCorpGr(currentPane)
```

### 5.2 조회일자(`filterYmd`) 추출
```javascript
// 금지: function getFilterYmd() { ... } 로컬 작성
// 표준 사용:
var ymdDefault = getFilterYmd(currentPane);                // "2026-10-13" (YYYY-MM-DD 기본형)
var ymdRaw     = getFilterYmd(currentPane, 'YYYYMMDD');     // "20261013"   (8자리 순수 숫자)
var ymdDot     = getFilterYmd(currentPane, 'YYYY.MM.DD');   // "2026.10.13" (점 구분자)
```

### 5.3 공통 UI 토스트 알림 및 대화상자
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

### 5.4 숫자, 통화 및 백분율 포맷터
```javascript
// 1) 천단위 콤마 및 소수점 자리수 포맷팅
var formattedNum = formatNumber(1234567.89, 2); // "1,234,567.89"
var integerNum   = formatNumber(1234567, 0);    // "1,234,567"

// 2) 백분율 포맷팅
var formattedPct = formatPercent(12.3456, 2);   // "12.35%"
```
