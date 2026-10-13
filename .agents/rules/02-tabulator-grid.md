---
trigger: always_on
---

# AAMS Tabulator 그리드 개발 표준 가이드

본 문서는 파워빌더 DataWindow(.srd)를 웹 Tabulator 그리드로 변환하고 마스터-디테일 연동 및 인라인 편집을 구현할 때 반드시 준수해야 하는 표준 규격입니다.

---

## 1. 컬럼 구성 및 기본 옵션 표준

1. **srd 메타데이터 반영 원칙**:
   - Tabulator 컬럼 목록은 `.srd` 파일의 각 컬럼의 `text`를 가져와서 순서대로 100% 반영한다.
   - 컬럼의 `hozAlign` 및 포맷은 `.srd`의 alignment(0: left, 1: right, 2: center) 및 format을 따른다.
   - `.srd`의 `tab_order`(또는 `tabsequence`)를 기반으로 편집 가능 여부(`editor`)를 결정한다 (`0` 또는 `32766` 이상은 read-only).
2. **원클릭 인라인 편집 진입 필수 옵션 (`editTriggerEvent: "click"`)**:
   - 편집 가능한 컬럼(`editor` 존재)이 포함된 그리드는 초기화 옵션에 반드시 `editTriggerEvent: "click"`을 명시한다.
   - 단일 행 선택(`selectableRows: 1`) 환경에서도 비선택 행의 셀을 단 1회 클릭했을 때 행 선택과 동시에 즉각 에디터(`<input>`, `list` 등)가 열리고 포커스가 유지되도록 보장한다.
3. **편집 가능 셀 선행 선택 핸들러 (`aamsCellEdit`)**:
   - 편집 가능한 셀의 컬럼 설정에는 반드시 `cellClick: aamsCellEdit`를 지정한다.
   - `common.js`의 `aamsCellEdit`는 비선택 행 클릭 시 행 선택 전환 후 지연 실행을 통해 마우스 이벤트 버블링과 DOM 포커스 간섭을 원천 차단한다.
4. **신규 행 인라인 편집 허용 예외 규격**:
   - 기존에 서버에서 조회된 데이터는 수정을 제한하고 행 선택만 가능하게 하며, 신규로 추가된 행(`isNew: true`)에 대해서만 인라인 수정을 허용할 경우 `editor`를 동적 함수로 분기한다:
     ```javascript
     editor: function (cell) {
         var rowData = cell.getRow().getData();
         return rowData.isNew ? "input" : false;
     }
     ```

---

## 2. 그리드 내부 특수 컨트롤 규격 (돋보기 검색 & 달력 팝업 & 명칭 컬럼)

1. **다이나믹 서치 버튼 컬럼 (`p_xx_컬럼명`)**:
   - `.srd` 파일에 `p_xx_컬럼명` 비트맵 컨트롤이 존재하는 경우, 대상 코드 컬럼 바로 우측에 타이틀이 없는 빈칸(`title: ""`, `field: "p_xx_컬럼명"`, `width: 36`, `resizable: false`, `headerSort: false`)을 생성한다.
   - 셀 내부에는 돋보기 버튼(`.btn-grid-addon.btn-search`)을 렌더링하고, 클릭 시 `DynamicCodeSearch.openModal`을 호출한다:
     ```javascript
     {
         title: "",
         field: "p_xx_fund_cd",
         width: 36,
         minWidth: 36,
         maxWidth: 36,
         hozAlign: "center",
         headerSort: false,
         resizable: false,
         formatter: function () {
             return '<button type="button" class="btn-grid-addon btn-search" title="검색"><i class="fa-solid fa-magnifying-glass"></i></button>';
         },
         cellClick: function (e, cell) {
             e.stopPropagation();
             openFundSearchModal(cell.getRow());
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

## 3. 그리드 날짜(Date) 타입 수기 입력 3단계 유효성 검증 표준

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

## 4. 테이블 행 선택(Row Select) 및 마스터-디테일 연동 표준 규격

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
2. **동일 키 중복 API 호출 방지 가드**:
   - 상세 연동 함수(`syncDetail`)는 동일한 키값에 대한 불필요한 중복 fetch를 방지하는 가드(`lastLoadedMasterKey === currentKey`)를 반드시 둔다:
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

---

## 5. 데이터 조회 및 새로고침 시 행 포커스 (Row Focus) 2대 표준 정책

1. **리포트 뷰어(reportViewer)가 있는 경우**:
   - **모바일 환경 (width <= 876px)**: 조회/새로고침 시 어디든 rowfocus를 강제하지 않는다 (deselect 유지하여 모바일 모달 팝업의 원치 않는 자동 오픈 방지).
   - **PC/태블릿 환경 (width > 876px)**: 그리드의 첫 번째 행을 자동 선택/포커스(`rows[0].select()`)하여 우측 리포트에 첫 행 내용이 즉시 표출되도록 한다.
2. **리포트 뷰어(reportViewer)가 없는 경우**:
   - PC, 태블릿, 모바일 모든 환경에서 데이터 조회/새로고침 시 첫 번째 행을 자동 선택/포커스(`rows[0].select()`)하여 상세 그리드 또는 패널 연동 데이터가 즉시 표출되도록 한다.
3. **내장 자동 분기**:
   - 상기 정책은 `common.js`의 `setupTabulatorRowSelection(grid)`에 내장되어 뷰포트 크기 및 화면 구조에 따라 자동 분기된다.

---

## 6. 그리드 행/셀 테두리 및 정합성 규격 (Zero-Row-Outline 원칙)

1. **행 outline 속성 절대 금지**:
   - 그리드 행 선택(`.tabulator-selected`) 및 포커스(`:focus`) 시 행 전체 요소에 `outline`을 지정하지 않는다 (`outline: none !important`).
   - `layout: "fitDataFill"` 등 그리드 너비가 가변적이거나 컨테이너보다 작은 구조에서 행 엘리먼트에 outline이 부여되면 우측 끝 빈 공간이나 마지막 컬럼 셀 상단/우측에 불필요한 돌출선이나 이중 테두리가 발생하는 시각적 결함이 유발된다.
   - 행 선택 하이라이트는 공통 CSS의 배경색(`background-color: #bae6fd`)과 셀 경계선(`border-bottom`, `border-right`)으로만 표현한다.
