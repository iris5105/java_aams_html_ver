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

### 2.4 모든 DDDW 드롭다운의 2열 커스텀 컴포넌트 필수 적용 표준 (Zero-Native-Select 원칙)

> [!IMPORTANT]
> **브라우저 기본 `<select>` 방치 절대 금지 및 2열 커스텀 컴포넌트(`f_dddwctl.get2ColItemFormatter`) 필수 적용**  
> 상단 필터바의 모든 DDDW(단일 DDDW, 복수 DDDW1/2/3) 및 화면 내의 모든 드롭다운(펀드, 포트, 매매처, 거래구분 등)은 브라우저 기본 `<select>`에 `<option>`만 추가하여 밋밋한 네이티브 드롭다운으로 방치하는 것을 엄격히 금지합니다.  
> 반드시 `window.initFilterDddw` 또는 `window.f_dddwctl.get2ColItemFormatter(selectEl, options, config)`를 호출하여 파워빌더 DataWindow와 동일한 **[코드 | 명칭] 2열 테이블형 커스텀 드롭다운(`.dddw-select-custom`)으로 일관되게 변환**해야 합니다.

1. **동적 API 데이터(펀드목록, 포트목록 등) 로드 시 변환 표준 패턴**:
   ```javascript
   fetch('/api/.../fund-list?...')
       .then(res => res.json())
       .then(list => {
           var options = [];
           if (Array.isArray(list) && list.length > 0) {
               options = list.map(function (f) {
                   return {
                       code: f.fundCd,
                       name: (f.fundNm || f.xxFundCd || f.fundCd || '').toString().trim()
                   };
               });
           }

           // 반드시 f_dddwctl.get2ColItemFormatter를 호출하여 2열 커스텀 위젯으로 변환!
           if (window.f_dddwctl && typeof window.f_dddwctl.get2ColItemFormatter === 'function') {
               window.f_dddwctl.get2ColItemFormatter(fundSelect, options, {
                   codeTitle: "코드",
                   nameTitle: "펀드명",
                   defaultVal: options.length > 0 ? options[0].code : "",
                   onSelect: function (code, name) {
                       fundSelect.value = code;
                       loadPortList(code); // 하위 연동 실행
                   }
               });
           }
       });
   ```
2. **2열 드롭다운의 혜택 및 일관성**:
   - 버튼에 선택된 명칭과 드롭다운 화살표(`▼`)가 일체형으로 렌더링됩니다.
   - 드롭다운 오픈 시 상단에 고정된 `[코드 | 명칭]` 헤더 행과 함께 정렬된 2열 테이블 팝업이 표출됩니다.
   - 클릭 즉시 값이 반영되고 `change` 이벤트가 버블링되어 하위 필터나 그리드 연동이 매끄럽게 동작합니다.

---

## 3. 달력 컴포넌트 표준 규격 (`aams_calendar.js` & `dc_ymd`)

> [!CAUTION]
> **날짜 입력창 수기 마크업 및 비표준 AamsCalendar 호출 엄격 금지 (Zero-Manual-Date-Markup 원칙)**  
> 1. 부트스트랩 `.input-group` 클래스나 임의의 `<input>` + `<button>` 태그를 화면에 직접 작성하면 `aams_calendar.js`의 필수 래퍼(`.aams-calendar-wrapper`)가 누락되어 달력 팝오버가 전혀 동작하지 않습니다.  
> 2. `AamsCalendar.init({ inputSelector: ..., btnSelector: ... })`와 같이 존재하지 않는 비표준 객체 단일 인자로 호출하면 인스턴스 등록이 실패합니다.

### 3.1 상단 필터바 날짜 마크업 표준 (공통 프래그먼트 연동)
상단 필터바의 기준일자는 화면마다 임의로 HTML을 작성하지 않고, 반드시 시스템 공통 타임리프 프래그먼트를 사용합니다:
```html
<!-- 단일 기준일자 필터 (dc_ymd) -->
<div th:replace="~{fragments/filter/dc_ymd :: filter(label='조회기준일')}"></div>
```
- 프래그먼트 내부에 `id="filterYmd"`, `.aams-calendar-wrapper`, `onclick="AamsCalendar.toggle('filterYmd', event)"`가 완전하게 구성되어 있습니다.

### 3.2 자바스크립트 달력 초기화 표준 (`initFilterCalendar`)
개별 화면 스크립트에서는 `common.js`에 내장된 표준 헬퍼인 **`initFilterCalendar(currentPane, options)`**를 필수로 호출합니다:
```javascript
// 달력 컴포넌트 초기화 표준 (common.js initFilterCalendar 공통 연동)
function initCalendar() {
    if (typeof window.initFilterCalendar === 'function') {
        window.initFilterCalendar(currentPane, {
            onSelect: function (selectedDate) {
                // 규칙 08 준수: 날짜 변경 시 자동 조회를 절대 실행하지 않고, 종속 필터(예: 펀드/포트) 목록만 갱신
                loadFundList();
            }
        });
    }
}
```

### 3.3 AamsCalendar 엔진 직접 호출 시 표준 시그니처 (2인자 엄수)
`AamsCalendar` 엔진을 직접 호출해야 하는 경우, 반드시 **첫 번째 인자는 `inputId`(문자열 또는 input 요소)**, **두 번째 인자는 `options`(객체)**를 전달해야 합니다:
```javascript
// 1) 순정 모드 (데이터 하이라이트 없이 표준 달력 팝오버)
AamsCalendar.initSimple('filterYmd', {
    pane: currentPane,
    initialYmd: '2026-10-19',
    onSelect: function(dateStr) { loadFundList(); }
});

// 2) 하이라이트 모드 (dw_c.ue_getdate 이벤트 존재 시 거래일/데이터 존재일 강조)
AamsCalendar.init('filterYmd', {
    pane: currentPane,
    initialYmd: '2026-10-19',
    datesApiUrl: '/api/common/calendar/dates',
    corpGr: resolveCorpGr(currentPane),
    onSelect: function(dateStr) { loadFundList(); }
});
```

### 3.4 조회 날짜 값 추출 표준 (`getFilterYmd`)
날짜 값을 읽을 때 개별 ID(`document.getElementById('filterYmd')`)를 직접 조회하지 말고, 공통 유틸리티 **`getFilterYmd(currentPane)`**를 사용합니다:
```javascript
var ymdDefault = getFilterYmd(currentPane);             // "2026-10-19" (YYYY-MM-DD)
var ymdRaw     = getFilterYmd(currentPane, 'YYYYMMDD');  // "20261019"
```

---

## 4. 다이나믹 코드 검색 컴포넌트 (`dynamic_code_search.js`)

파워빌더의 `f_find_code` 호출이나 종목/펀드/거래처 등 팝업 검색이 필요한 경우 [dynamic_code_search.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/dynamic_code_search.js)의 `DynamicCodeSearch`를 사용합니다.

### 4.1 핵심 규격
1. **양방향 바인딩:** 코드 검색 팝업에서 특정 행을 선택하면 코드 필드와 명칭 필드가 함께 바인딩됩니다.
2. **수기 입력 후 포커스 아웃 연동:** 코드 input에 사용자가 직접 6~12자리 코드를 수기 입력한 경우 `DynamicCodeSearch.searchByCode`를 통해 서버에서 명칭을 즉시 조회하여 명칭 input/셀에 자동 채번합니다.
3. **필터 변경 시 자동 조회 금지 준수:** 코드 검색으로 특정 종목이나 계좌가 선택되었더라도 전체 그리드 데이터 조회는 자동으로 실행하지 않고 상단 [조회] 버튼 클릭 시에 실행합니다.

### 4.3 파워빌더 `ue_setcodesearch` 동적 WHERE 절(`addWhere`) 연동 표준

파워빌더 화면(`.srw`)의 `dw_c::ue_setcodesearch` 또는 `dw_list::ue_setcodesearch` 이벤트에 정의된 동적 `rs_Where` 및 return `seq` 값을 100% 반영합니다.

1. **상단 필터바 바인딩 시 `addWhere` 함수 지정**:
   - `DynamicCodeSearch.bind()` 호출 시 `addWhere` 옵션(함수 또는 문자열)을 지정하여 기준일자(`filterYmd`) 및 작업일자(`idt_workdate`) 기준으로 해지일자(`HAEJI_YMD`) 검증 등 동적 조건을 실시간 생성하여 서버로 전달합니다:
     ```javascript
     codeSearchInstance = window.DynamicCodeSearch.bind({
         inputEl: "#filterXx",
         btnEl: "#btnCodeSearchXx",
         textEl: "#textXxName",
         columnNm: "rcd",
         seq: 4, // 파워빌더 ue_setcodesearch의 RETURN seq 값 일치
         pane: currentPane,
         getCorpGr: function () {
             return window.resolveCorpGr ? window.resolveCorpGr(currentPane) : "";
         },
         addWhere: function () {
             // w_ja035b.srw dw_c::ue_setcodesearch:
             // rs_Where = "nvl(HAEJI_YMD, '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "') >= '" + string (idt_workdate,'yyyy.mm.dd') + "'"
             var ymd = window.getFilterYmd ? window.getFilterYmd(currentPane, 'YYYY.MM.DD') : "";
             return "nvl(HAEJI_YMD, '" + ymd + "') >= '" + ymd + "'";
         },
         onSelect: function (code, name, rowData) { ... }
     });
     ```
2. **그리드 내부 돋보기 팝업(`openModal`) 및 수기 코드 검증(`cellEdited`) 시 `addWhere` 전달**:
   - 그리드 셀 돋보기 클릭 시 `DynamicCodeSearch.openModal({ columnNm: 'rcd', seq: 4, addWhere: addWhere, ... })`로 전달합니다.
   - 그리드 셀 수기 입력 시 `/api/common/code-search/get?columnNm=rcd&seq=4&corpGr=...&code=...&addWhere=...` 파라미터를 누락 없이 바인딩하여 유효성 검증에서도 동일한 조건이 적용되도록 보장합니다.

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

---

## 6. 클라이언트 스토리지 및 세션 기반 작업일자 관리 표준 (Zero-Stale-LocalStorage-Date 원칙)

> [!IMPORTANT]
> **영업일자(workDate) 및 전영업일자(junyongDate)의 localStorage 저장 절대 금지**  
> 1. `localStorage`는 브라우저를 닫아도 영구 유지되는 영속 스토리지입니다.  
> 2. `workDate`(영업일자)와 `junyongDate`(전영업일자)는 DB 마감 처리, 날짜 경과, 그리고 **회사그룹(`corpGr`) 변경 시마다 달라지는 동적 업무 기준일자**입니다.  
> 3. 이를 `localStorage`에 저장하면 날짜가 변경되거나 다른 회사로 전환해도 오래된 날짜(Stale Cache)가 영구 보존되어 화면의 일자가 왜곡되는 치명적 결함이 발생합니다.  
> 4. 따라서 **날짜 관련 정보는 반드시 브라우저 세션 생명주기를 따르는 `sessionStorage`에서만 관리**하며, 회사 변경 시 백엔드 API(`/api/auth/switch-company`, `/api/common/workdate`)의 최신 `SZX0AA.HYUN_YMD`를 수신하여 `sessionStorage`와 런타임 메모리에 즉시 갱신합니다.

1. **스토리지 역할 분리 규격**:
   - `localStorage`: 장기 인증 토큰(`accessToken`, `refreshToken`), 사용자 고유 식별자(`userId`, `userNm`, `corpGr`) 등 영속 데이터만 저장.
   - `sessionStorage`: 현재 탭 세션의 MDI 탭 상태(`AAMS_MDI_TABS_STATE`), 현재 작업회사의 최신 영업일자(`workDate`, `workYmd`), 전영업일자(`junyongDate`, `junyongYmd`), 화면 캐시(`aams_work_dates`) 보관.
2. **로고 클릭 및 회사 변경 시 실시간 동기화 (`selectCompany`)**:
   - 상단 헤더 로고 또는 사이드바 로고 클릭 후 회사 변경 모달에서 새 회사를 선택했을 때, 백엔드 `/api/auth/switch-company` 응답으로 반환되는 새 회사의 `corpGr`, `workDate`, `junyongDate`를 `sessionStorage`에 즉시 반영하고, `localStorage`에 남아있던 오래된 날짜 키는 완전 삭제(`removeItem`)한다.
   - 전역 런타임 변수(`window.currentCorpGr`, `window.currentWorkDate`, `window.currentJunyongDate`) 및 `WorkDateSyncManager`에 즉시 반영 후 화면을 갱신한다.
