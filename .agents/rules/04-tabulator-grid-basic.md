---
trigger: always_on
---

# 04. Tabulator 그리드 기초 및 컬럼 구성 개발 표준 가이드

본 문서는 파워빌더 DataWindow(.srd)를 웹 Tabulator 그리드로 변환할 때 필수적으로 준수해야 하는 컬럼 구성, 정렬, 원클릭 인라인 편집, 드롭다운(List Editor), 그리고 그리드 테두리 표준 규격입니다.

---

## 1. 컬럼 구성 및 srd 메타데이터 반영 원칙

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

---

## 2. 드롭다운(DDDW & List Editor) 클릭 시 기존 값 표시 유지 표준

1. **클릭 즉시 기존 값 유지**:
   - `colDef.editor === "list"` 또는 `valuesLookup`/`values`가 적용된 컬럼 클릭 시, 사용자가 목록에서 다른 값을 선택해 변경하기 전까지 셀 내부 `<input>`에 기존 값/라벨을 유지(`input.value`, `placeholder`)하고, 우측 드롭다운 화살표(`.aams-dddw-arrow`, `▼`)를 표출한다.
2. **드롭다운 팝업 활성화**:
   - 드롭다운 팝업(`.tabulator-edit-list`) 열림 시 기존 선택 항목에 `.active` 클래스를 부여하여 파란색 하이라이트 및 뷰포트 스크롤 안착을 보장한다.

---

## 3. 그리드 시각적 정합성 및 배제 규칙

1. **테이블 조회 건수(Row Count) 배지 표시 절대 금지 (Zero-Count-Badge 원칙)**:
   - 파워빌더 DataWindow 원본 환경과 동일하게, 테이블 패널 헤더(`sub-grid-header`, `pane-header` 등)나 그리드 상단/주변에 임의의 조회 건수 표시 배지(`<span class="badge ...">0건</span>`, `<span id="*-count">...</span>` 등)를 절대 작성하지 않는다.
   - 테이블 패널 헤더에는 순수한 패널 제목(`sub-title`, `panel-title`)과 실제 기능 동작에 필요한 서브 액션 버튼(`btn-sub-grid`, 행 추가/삭제/복사 등)만을 배치하여 시각적 군더더기를 배제한다.
2. **그리드 행 outline 속성 절대 금지 (Zero-Row-Outline 원칙)**:
   - 그리드 행 선택(`.tabulator-selected`) 및 포커스(`:focus`) 시 행 전체 요소에 `outline`을 지정하지 않는다 (`outline: none !important`).
   - `layout: "fitDataFill"` 등 그리드 너비가 가변적이거나 컨테이너보다 작은 구조에서 행 엘리먼트에 outline이 부여되면 우측 끝 빈 공간이나 마지막 컬럼 셀 상단/우측에 불필요한 돌출선이나 이중 테두리가 발생하는 시각적 결함이 유발된다.
   - 행 선택 하이라이트는 공통 CSS의 배경색(`background-color: #bae6fd`)과 셀 경계선(`border-bottom`, `border-right`)으로만 표현한다.
3. **수정 불가능한 셀 클릭 시 왜곡 방지 (Zero-Cell-Distortion)**:
   - 비편집 셀 클릭 시 개별 셀에 임의의 포커스 링 테두리나 배경색 변경을 주지 않고, 행 선택(`.tabulator-selected`)만 깔끔하게 유지한다.
