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
     editor: "input",
     editable: function (cell) {
         var rowData = cell.getRow().getData();
         return !!rowData.isNew;
     }
     ```
5. **테이블 조회 건수(Row Count) 배지 표시 절대 금지 (Zero-Count-Badge 원칙)**:
   - 파워빌더 DataWindow 원본 환경과 동일하게, 테이블 패널 헤더(`sub-grid-header`, `pane-header` 등)나 그리드 상단/주변에 임의의 조회 건수 표시 배지(`<span class="badge ...">0건</span>`, `<span id="*-count">...</span>` 등)를 절대 작성하지 않는다.
   - 테이블 패널 헤더에는 순수한 패널 제목(`sub-title`, `panel-title`)과 실제 기능 동작에 필요한 서브 액션 버튼(`btn-sub-grid`, 행 추가/삭제/복사 등)만을 배치하여 시각적 군더더기를 배제한다.

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
4. **마스터-디테일 비동기 연동 시 서브 그리드 포커스 탈취 차단 및 DDDW 기존 값 표시 표준 규격**:
   - **서브 그리드의 포커스 탈취 원천 차단 (`AamsFocusManager.shouldBlockFocusSteal`)**:
     - 사용자가 마스터 그리드의 행/셀을 조작한 직후 비동기로 로드되는 서브 그리드의 `dataLoaded` 및 `focusRow`에서, 마스터 그리드가 활성 상태라면 서브 그리드의 DOM `focus()` 실행을 원천 차단하고 시각적 행 선택(`rows[0].select()`)만 유지한다.
   - **수정 불가능한 셀 클릭 시 테두리/배경색 왜곡 방지 (Zero-Cell-Distortion)**:
     - 비편집 셀 클릭 시 개별 셀에 임의의 포커스 링 테두리나 배경색 변경을 주지 않고, 행 선택(`.tabulator-selected`)만 깔끔하게 유지한다.
   - **DDDW 및 하드코딩 드롭다운(List Editor) 클릭 시 기존 값 표시 유지 표준**:
     - `colDef.editor === "list"` 또는 `valuesLookup`/`values`가 적용된 컬럼 클릭 시, 사용자가 목록에서 다른 값을 선택해 변경하기 전까지 셀 내부 `<input>`에 기존 값/라벨을 유지(`input.value`, `placeholder`)하고, 우측 드롭다운 화살표(`.aams-dddw-arrow`, `▼`)를 표출한다.
     - 드롭다운 팝업(`.tabulator-edit-list`) 열림 시 기존 선택 항목에 `.active` 클래스를 부여하여 파란색 하이라이트 및 뷰포트 스크롤 안착을 보장한다.

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

---

## 7. 파워빌더 DataWindow(.srd) Summary 밴드 기반 합계 행 (Summary Row) 표준 규격

파워빌더 DataWindow의 `summary(height=...)` 밴드에 집계 표현식(`compute(band=summary ...)`)이나 라벨(`text(band=summary ...)`)이 정의된 화면을 Tabulator 그리드로 전환할 때 적용하는 표준 규격입니다.

### 1. srd 메타데이터 분석 및 매핑 원칙
- **라벨 및 위치 매핑**:
  - `.srd`의 `text(band=summary text="..." x="..." ...)`에서 지정된 라벨(예: `합계`, `(USD계)`)은 x 좌표가 일치하는 해당 컬럼(종목명, 변동성 구분 등)에 매핑한다.
- **집계 표현식 매핑**:
  - `compute(band=summary expression="sum(컬럼 for all)" ...)`은 해당 x 좌표의 수량/금액/비중 컬럼에 대해 전체 일반 행의 합계를 산출하여 바인딩한다.
- **비집계 컬럼 처리**:
  - 요약/합계 대상이 아닌 컬럼(순서, 종목코드, 만기일, 일수, 돋보기/달력 버튼 등)은 빈 문자열(`""`)로 비워둔다.

### 2. 데이터 Summary Row 패턴 채택 이유 (vs Tabulator bottomCalc)
- Tabulator 내장 푸터 계산(`bottomCalc`)은 테이블 본문과 분리된 하단 고정 푸터 바(`.tabulator-footer`)에 렌더링되므로, 파워빌더 DataWindow처럼 테이블 본문의 마지막 행으로 일체감 있게 스크롤/정렬되는 Summary Band의 시각적 형태 및 셀별 복합 텍스트(`합계`, `(USD계)`) 표현에 제약이 있다.
- 따라서 실제 데이터 배열 끝에 `{ isSummaryRow: true, ... }` 객체를 추가하는 **Data Summary Row 패턴**을 단일 표준으로 채택한다.

### 3. 스타일링 및 표시 규칙
1. **파워빌더 표준 연노랑 배경 (`aams-summary-row`)**:
   - Tabulator 옵션의 `rowFormatter`에서 `isSummaryRow` 여부를 검사하여 전역 공통 클래스를 부여한다:
     ```javascript
     rowFormatter: function (row) {
         var data = row.getData();
         if (data && data.isSummaryRow) {
             row.getElement().classList.add("aams-summary-row");
         }
     }
     ```
   - 공통 CSS(`.tabulator-row.aams-summary-row`)에 의해 `#fbf2c4` 배경색, 테두리, 굵은 텍스트(`font-weight: 600`)가 자동 적용된다.
2. **데이터 0건일 때의 표시 원칙**:
   - 일반 데이터 행이 0건일 때는 합계 행을 생성하지 않으며, **데이터가 1건 이상 존재할 때에만** 맨 마지막 행으로 표출한다.
3. **행 선택(Select) 및 마우스 클릭/드래그 차단 (Select-Disabled)**:
   - 합계 행은 단순 요약/집계 표시용이므로 행 선택(Row Select)이나 마우스 클릭, 텍스트 드래그가 불가능해야 한다.
   - 공통 CSS(`.tabulator-row.aams-summary-row`)에 `pointer-events: none !important`, `user-select: none !important`, `outline: none !important`가 내장되어 있어 마우스 클릭 시 행 선택 전환이나 하이라이트가 원천 차단된다.

### 4. 컬럼 정의 시 방어 규칙 (Editor & Formatter & Add-on Button)
1. **에디터 비활성화 (`editable`)**:
   - 합계 행의 셀은 수정할 수 없으므로, 편집 가능 컬럼은 `editor`는 문자열(`"input"`, `"list"`)로 유지하고 `editable`을 동적 함수로 지정하여 합계 행일 때 편집을 차단한다:
     ```javascript
     editor: "input",
     editable: function (cell) {
         var rowData = cell.getRow().getData();
         return !rowData.isSummaryRow;
     }
     ```
2. **포매터 분기 (`formatter`)**:
   - 비대상 컬럼은 `if (row && row.isSummaryRow) return "";`로 빈칸 처리한다.
   - 대상 컬럼은 가운데 정렬 텍스트(예: `합계`) 또는 천단위 콤마 숫자 및 볼드 처리를 적용한다:
     ```javascript
     // 텍스트 라벨 (예: 종목명 컬럼)
     formatter: function (cell) {
         var row = cell.getRow().getData();
         if (row && row.isSummaryRow) {
             return '<div style="text-align: center; font-weight: bold; width: 100%;">합계</div>';
         }
         return cell.getValue() || "";
     }
     // 숫자 합계 (예: 금액 컬럼)
     formatter: function (cell) {
         var row = cell.getRow().getData();
         var val = cell.getValue();
         var str = val != null ? (window.formatNumber ? window.formatNumber(val, 0) : Number(val).toLocaleString()) : '0';
         if (row && row.isSummaryRow) {
             return '<span class="cell-text-blue font-bold">' + str + '</span>';
         }
         return '<span class="cell-text-blue">' + str + '</span>';
     }
     ```
3. **돋보기(`p_xx_`) 및 달력(`p_dd_`) 버튼 비활성화**:
   - 합계 행에서는 버튼 아이콘을 렌더링하지 않고 클릭 이벤트도 즉시 차단한다:
     ```javascript
     formatter: function (cell) {
         var row = cell.getRow().getData();
         if (row && row.isSummaryRow) return "";
         return '<button type="button" class="btn-grid-addon btn-search" title="검색"><i class="fa-solid fa-magnifying-glass"></i></button>';
     },
     cellClick: function (e, cell) {
         e.stopPropagation();
         if (cell.getRow().getData().isSummaryRow) return;
         openModal(cell.getRow());
     }
     ```

### 5. 라이프사이클 이벤트 및 동적 재계산 표준 (`recalcSummaryRow`)
화면에는 데이터 변경 시 합계를 즉시 갱신하는 재계산 함수를 두고, 아래 4대 라이프사이클 시점에 호출한다:

```javascript
function recalcSummaryRow() {
    if (!grid) return;
    var rows = grid.getRows();
    var normalRows = rows.filter(function (r) {
        var d = r.getData();
        return d && !d.isSummaryRow && !d.isDeleted;
    });
    var summaryRow = rows.find(function (r) {
        var d = r.getData();
        return d && d.isSummaryRow;
    });

    // 데이터가 0건이면 합계 행 제거
    if (normalRows.length === 0) {
        if (summaryRow) summaryRow.delete();
        return;
    }

    // 합계 집계
    var totalAmt = 0;
    normalRows.forEach(function (r) {
        totalAmt += parseFloat(r.getData().amt) || 0;
    });

    var summaryData = {
        isSummaryRow: true,
        itemNm: "합계",
        amt: totalAmt
    };

    if (summaryRow) {
        summaryRow.update(summaryData);
    } else {
        grid.addRow(summaryData, false);
    }
}
```

1. **데이터 로드 시 (`loadData`)**:
   - 서버에서 데이터를 조회했을 때 `data.length > 0`이면 합계 객체를 추가한 `data.concat([summaryData])`로 바인딩한다.
   - 최초 1행 자동 선택(Row Focus) 시 `!r.getData().isSummaryRow`인 실제 데이터 행을 선택한다.
2. **셀 편집 완료 시 (`cellEdited`)**:
   - 일반 행의 셀 편집 완료 시 `recalcSummaryRow()`를 호출하여 실시간 반영한다.
3. **행 추가 / 복사 시 (`addRow`)**:
   - 새 행 추가 시, 기존에 `summaryRow`가 존재하면 `grid.addRow(newRow, true, summaryRow)` (summaryRow 직전)를 호출하여 **합계 행이 항상 최하단에 유지되도록 보장**한다. 추가 후 `recalcSummaryRow()`를 호출한다.
4. **행 삭제 시 (`deleteRow`)**:
   - `if (d.isSummaryRow) return;`으로 합계 행 삭제를 원천 방지한다.
   - 일반 행 삭제 완료 후 `recalcSummaryRow()`를 호출하여 남은 행의 합계를 갱신한다.

### 6. 마스터-디테일 연동 및 DB 저장 방어 (Zero-Summary-Leakage 원칙)
1. **마스터 그리드 행 선택 안전망**:
   - 합계 행을 클릭했을 때 하위 상세 서브 그리드가 잘못 조회되거나 키값이 왜곡되는 것을 방지하기 위해 가드를 둔다:
     ```javascript
     function canSync(row, data) {
         var d = data || (row && row.getData ? row.getData() : null);
         return d && !d.isSummaryRow;
     }
     ```
2. **DB 저장(`saveData`) 페이로드 분리**:
   - `grid.getData()`를 순회하여 변경 행(`isNew`, `isUpdated`, `isDeleted`)을 추출할 때 반드시 합계 행을 건너뛴다:
     ```javascript
     grid.getData().forEach(function (d) {
         if (d.isSummaryRow) return; // 합계 행은 서버 전송에서 원천 배제
         if (d.isNew || d.isUpdated || d.isDeleted) changedList.push(d);
     });
     ```

