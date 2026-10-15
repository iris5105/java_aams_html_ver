---
trigger: always_on
---

# 06. Tabulator 그리드 Summary 합계 행 개발 표준 가이드

본 문서는 파워빌더 DataWindow(.srd)의 Summary 밴드(`summary(height=...)`)에 정의된 집계식 및 라벨을 Tabulator 그리드의 본문 일체형 합계 행으로 변환하고 라이프사이클을 동기화하기 위한 표준 규격입니다.

---

## 1. 데이터 Summary Row 패턴 채택 이유 (vs Tabulator bottomCalc)

1. **본문 일체형 스크롤 및 정렬 보장**:
   - Tabulator 내장 푸터 계산(`bottomCalc`)은 테이블 본문과 분리된 하단 고정 푸터 바(`.tabulator-footer`)에 렌더링되므로, 파워빌더 DataWindow처럼 테이블 본문의 마지막 행으로 일체감 있게 스크롤/정렬되는 Summary Band의 시각적 형태 및 셀별 복합 텍스트(`합계`, `(USD계)`) 표현에 제약이 있다.
2. **단일 표준 채택**:
   - 따라서 실제 데이터 배열 끝에 `{ isSummaryRow: true, ... }` 객체를 추가하는 **Data Summary Row 패턴**을 단일 표준으로 채택한다.

---

## 2. srd 메타데이터 분석 및 매핑 원칙

1. **라벨 및 위치 매핑**:
   - `.srd`의 `text(band=summary text="..." x="..." ...)`에서 지정된 라벨(예: `합계`, `(USD계)`)은 x 좌표가 일치하는 해당 컬럼(종목명, 변동성 구분 등)에 매핑한다.
2. **집계 표현식 매핑**:
   - `compute(band=summary expression="sum(컬럼 for all)" ...)`은 해당 x 좌표의 수량/금액/비중 컬럼에 대해 전체 일반 행의 합계를 산출하여 바인딩한다.
3. **비집계 컬럼 처리**:
   - 요약/합계 대상이 아닌 컬럼(순서, 종목코드, 만기일, 일수, 돋보기/달력 버튼 등)은 빈 문자열(`""`)로 비워둔다.

---

## 3. 스타일링 및 표시 규칙

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

---

## 4. 컬럼 정의 시 방어 규칙 (Editor & Formatter & Add-on Button)

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

---

## 5. 라이프사이클 이벤트 및 동적 재계산 표준 (`recalcSummaryRow`)

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

---

## 6. 마스터-디테일 연동 및 DB 저장 방어 (Zero-Summary-Leakage 원칙)

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
