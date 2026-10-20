---
trigger: always_on
---

# 05. Tabulator 그리드 이벤트 및 인터랙션 개발 표준 가이드

본 문서는 Tabulator 그리드의 특수 컨트롤(돋보기/달력/명칭), 날짜 수기 입력 유효성 검증, 행 선택 및 마스터-디테일 연동, 서브 그리드 포커스 방어, 그리고 행 포커스(Row Focus) 표준 정책을 정의합니다.

---

## 1. 그리드 내부 특수 컨트롤 규격 (돋보기 & 달력 & 명칭)

1. **다이나믹 서치 버튼 컬럼 (`xx_btn_컬럼명`) 표준 기본 틀**:
   - `.srd` 파일에 `p_xx_컬럼명` 비트맵 컨트롤이 존재하는 경우, 대상 코드 컬럼 바로 우측에 타이틀이 없는 빈칸(`title: ""`, `field: "xx_btn_컬럼명"`, `width: 36`, `resizable: false`, `headerSort: false`)을 생성한다.
   - **펀드코드 검색 (`xx_btn_fundCd`) DynamicCodeSearch 기본 틀**:
     ```javascript
     {
         title: "",
         field: "xx_btn_fundCd",
         width: 36,
         minWidth: 36,
         maxWidth: 36,
         hozAlign: "center",
         headerSort: false,
         resizable: false,
         formatter: function(cell) {
             const isNew = cell.getRow().getData().isNew;
             const disClass = isNew ? "" : "disabled";
             return `<button type="button" class="btn-grid-addon btn-search ${disClass}" title="펀드 검색"><i class="fa-solid fa-magnifying-glass"></i></button>`;
         },
         cellClick: function(e, cell) {
             e.stopPropagation();
             const row = cell.getRow();
             const data = row.getData();
             if (!data.isNew && !data._isNew) {
                 if (gridMaster) { gridMaster.deselectRow(); row.select(); }
                 return;
             }
             const curVal = data.fundCd || "";
             if (window.DynamicCodeSearch && typeof window.DynamicCodeSearch.openModal === 'function') {
                 window.DynamicCodeSearch.openModal({
                     columnNm: "fund_cd", // 상황에 따라 fund_cd 또는 rcd
                     seq: 1,              // 파워빌더 ue_setcodesearch return 값 일치
                     initialKeyword: curVal,
                     onSelect: function(code, name) {
                         row.update({ fundCd: code, fundNm: name });
                     }
                 });
             }
         }
     }
     ```
   - **종목 검색 (`xx_btn_jmCd`) ItemSearch 기본 틀**:
     ```javascript
     {
         title: "",
         field: "xx_btn_jmCd",
         width: 36,
         minWidth: 36,
         maxWidth: 36,
         hozAlign: "center",
         headerSort: false,
         resizable: false,
         formatter: function(cell) {
             const isNew = cell.getRow().getData().isNew;
             const disClass = isNew ? "" : "disabled";
             return `<button type="button" class="btn-grid-addon btn-search ${disClass}" title="종목 검색"><i class="fa-solid fa-magnifying-glass"></i></button>`;
         },
         cellClick: function(e, cell) {
             e.stopPropagation();
             const row = cell.getRow();
             const data = row.getData();
             if (!data.isNew && !data._isNew) {
                 if (gridMaster) { gridMaster.deselectRow(); row.select(); }
                 return;
             }
             const curVal = data.jmCd || data.yjCd || "";
             if (window.DynamicCodeSearch && typeof window.DynamicCodeSearch.openModal === 'function') {
                 window.DynamicCodeSearch.openModal({
                     columnNm: "koscom_cd", // 도메인에 따라 koscom_cd, jm_cd, yj_cd, cj_cd
                     seq: 1,
                     initialKeyword: curVal,
                     onSelect: function(code, name) {
                         row.update({ jmCd: code, jjNm: name });
                     }
                 });
             }
         }
     }
     ```
2. **달력 팝업 버튼 컬럼 (`p_dd_컬럼명`)**:
   - `.srd` 파일에 `p_dd_컬럼명` 비트맵 컨트롤이 존재하는 경우, 날짜 컬럼 바로 우측에 타이틀이 없는 빈칸(`title: ""`, `field: "p_dd_컬럼명"`, `width: 36`, `resizable: false`, `headerSort: false`)을 생성한다.
   - 셀 내부에는 달력 버튼(`.btn-grid-addon.btn-cal`)을 렌더링하고, 클릭 시 `AamsCalendar.openDatePicker`를 호출하여 날짜를 선택하도록 연동한다:
     ```javascript
     {
         title: "",
         field: "p_dd_mangi_ymd",
         width: 36,
         minWidth: 36,
         maxWidth: 36,
         hozAlign: "center",
         headerSort: false,
         resizable: false,
         formatter: function () {
             return '<button type="button" class="btn-grid-addon btn-cal" title="날짜 선택"><i class="fa-regular fa-calendar-days"></i></button>';
         },
         cellClick: function (e, cell) {
             e.stopPropagation();
             var row = cell.getRow();
             var curVal = row.getData().mangiYmd || "";
             if (window.AamsCalendar && typeof window.AamsCalendar.openDatePicker === 'function') {
                 window.AamsCalendar.openDatePicker({
                     anchorEl: cell.getElement(),
                     initialYmd: curVal,
                     format: 'dash',
                     onSelect: function (selectedYmd) {
                         row.update({ mangiYmd: selectedYmd, isUpdated: true });
                     }
                 });
             }
         }
     }
     ```
3. **명칭 컬럼(`xx_컬럼명`) 및 코드 수기 입력 시 자동 조회 연동**:
   - 명칭 컬럼의 `field`는 `.srd`의 명칭과 1:1로 일치시킨다 (`xxFundCd`, `xxYjCd`, `xxKoscomCd` 등).
   - 코드 컬럼을 직접 수기 입력(`cellEdited`)했을 때, 유효한 코드이면 백엔드(`/api/common/code-search/get`) 조회를 통해 명칭 컬럼에 자동으로 이름을 세팅하고, 유효하지 않으면 돋보기 모달을 자동 오픈한다:
     ```javascript
     function onMasterFundCdChanged(cell) {
         var row = cell.getRow();
         var val = (cell.getValue() || "").trim();
         var corpGr = resolveCorpGr(currentPane);
         markRowUpdated(cell);
         if (!val) {
             row.update({ xxFundCd: "", fundNm: "" });
             return;
         }
         fetch('/api/common/code-search/get?columnNm=fund_cd&seq=1&corpGr=' + encodeURIComponent(corpGr) + '&code=' + encodeURIComponent(val))
             .then(res => res.json())
             .then(data => {
                 if (data && data.code) {
                     row.update({ fundCd: data.code, xxFundCd: data.codeName || data.name || '', isUpdated: true });
                 } else {
                     openFundSearchModal(row);
                 }
             })
             .catch(() => openFundSearchModal(row));
     }
     ```

---

## 2. 그리드 날짜(Date) 타입 수기 입력 3단계 유효성 검증 표준

1. **에디터 지정 (`aamsDateEditor`)**:
   - `editor: (window.aamsDateEditor || "input")`를 지정하여 입력/포커스 아웃 시점에 구분자 자동 정규화(YYYY-MM-DD)를 수행한다.
2. **셀 편집 완료 검증 (`aamsValidateDateCell`)**:
   - `cellEdited` 콜백에 `aamsValidateDateCell`을 연결하여 연/월/일 범위 및 윤년을 정밀 검증하고, 유효하지 않은 값 입력 시 경고 토스트 표출 및 이전 값으로 롤백한다.
3. **저장 시 전수 검증 (`aamsValidateGridDates`)**:
   - 상단 공통 [저장] 버튼(`pane.onSave`) 실행 시, `aamsValidateGridDates(grid, ['mangiYmd', ...])`를 호출하여 전체 행의 날짜 유효성을 일괄 검사하고 실패 시 저장을 차단한다:
     ```javascript
     {
         title: "만기일",
         field: "mangiYmd",
         hozAlign: "center",
         editor: window.aamsDateEditor || "input",
         editorParams: { separator: "-" },
         cellClick: aamsCellEdit,
         cellEdited: function (cell) {
             aamsValidateDateCell(cell, function (c, validDate) {
                 markRowUpdated(c);
             });
         }
     }
     ```

---

## 3. 테이블 행 선택(Row Select) 및 마스터-디테일 연동 표준 규격

1. **삼중 안전망 (Triple Fallback) 표준 계약**:
   - 마스터-디테일 구조(또는 상세 패널/서브 그리드 연동 화면)에서는 다음 3가지 이벤트를 모두 연결하여 이벤트 누락을 원천 방지한다:
     ```javascript
     // 1) 전역 헬퍼 연결 (캡처링/버블링 단일 이벤트 바인딩)
     setupTabulatorRowSelection(gridMaster, function (row, data) {
         syncDetail(row, data);
     });
     // 2) rowClick 이벤트 안전망
     gridMaster.on("rowClick", function (e, row) {
         syncDetail(row, row ? row.getData() : null);
     });
     // 3) rowSelectionChanged 이벤트 안전망
     gridMaster.on("rowSelectionChanged", function (data, rows) {
         if (rows && rows.length > 0) {
             syncDetail(rows[0], rows[0].getData());
         }
     });
     ```
2. **동일 키 중복 API 호출 방지 가드 및 새로고침 시 리셋 필수 규칙**:
   - 상세 연동 함수(`syncDetail`)는 동일한 키값에 대한 불필요한 중복 fetch를 방지하는 가드(`lastLoadedMasterKey === currentKey`)를 반드시 둔다.
   - **새로고침/재조회 시 가드 리셋 필수**: 상단 [새로고침](`pane.onRefresh`) 및 마스터 재조회 진입 시 반드시 `lastLoadedMasterKey = null`로 초기화해야 한다. 이를 누락하면 새로고침 후 [조회] 시 첫 번째 행이 자동 선택되어도 중복 가드에 걸려 **하위 상세 그리드 조회가 차단(`return`)**되는 결함이 발생한다:
     ```javascript
     let lastLoadedMasterKey = null;
     function syncDetail(row, masterRowData) {
         if (!row) return;
         if (!row.isSelected || !row.isSelected()) row.select();
         var data = masterRowData || (row.getData ? row.getData() : null);
         if (!data) return;
         var currentKey = (data.corpGr || "") + "_" + (data.mainKey || data.fundCd || "");
         if (lastLoadedMasterKey === currentKey) return;
         lastLoadedMasterKey = currentKey;
         loadDetailGrid(data);
     }
     ```
3. **단일 그리드 활성화 표시**:
   - 서브 그리드가 없는 단일 그리드 화면에서도 행 선택 시 시각적 활성화를 위해 `setupTabulatorRowSelection(grid)`를 적용한다.
4. **마스터-디테일 비동기 연동 시 서브 그리드 포커스 탈취 차단 (`AamsFocusManager.shouldBlockFocusSteal`)**:
   - 사용자가 마스터 그리드의 행/셀을 조작한 직후 비동기로 로드되는 서브 그리드의 `dataLoaded` 및 `focusRow`에서, 마스터 그리드가 활성 상태라면 서브 그리드의 DOM `focus()` 실행을 원천 차단하고 시각적 행 선택(`rows[0].select()`)만 유지한다.

---

## 4. 데이터 조회 및 새로고침 시 행 포커스 (Row Focus) 2대 표준 정책

1. **리포트 뷰어(reportViewer)가 있는 경우**:
   - **모바일 환경 (width <= 876px)**: 조회/새로고침 시 어디든 rowfocus를 강제하지 않는다 (deselect 유지하여 모바일 모달 팝업의 원치 않는 자동 오픈 방지).
   - **PC/태블릿 환경 (width > 876px)**: 그리드의 첫 번째 행을 자동 선택/포커스(`rows[0].select()`)하여 우측 리포트에 첫 행 내용이 즉시 표출되도록 한다.
2. **리포트 뷰어(reportViewer)가 없는 경우**:
   - PC, 태블릿, 모바일 모든 환경에서 데이터 조회/새로고침 시 첫 번째 행을 자동 선택/포커스(`rows[0].select()`)하여 상세 그리드 또는 패널 연동 데이터가 즉시 표출되도록 한다.
3. **내장 자동 분기**:
   - 상기 정책은 `common.js`의 `setupTabulatorRowSelection(grid)`에 내장되어 뷰포트 크기 및 화면 구조에 따라 자동 분기된다.
