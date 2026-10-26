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

---

## 4. 연속 중복값 숨김 및 마스터 그리드 그룹 구분선 표준 (Suppress Repeating Values & Group Separator)

파워빌더 DataWindow의 `Suppress Repeating Values` 기능과 동일하게, 상위 분류나 그룹 코드가 연속된 행에서 동일하게 반복될 때 첫 행에만 표시하고 그 아래의 중복 텍스트는 자동으로 숨겨 그리드의 가독성을 극대화합니다.  
**사용자 표준 규격에 따라 지정된 21개 화면의 마스터 그리드(`master-grid`)에 한정하여 No.(시퀀스)와 체크박스 유형을 제외한 첫 번째, 두 번째 컬럼에 자동 적용**되며, **첫 번째 컬럼의 데이터 유형(그룹)이 변경될 때 이전 그룹 하단에 구분선(Group Separator Border)이 자동 표출**됩니다. 그 외의 다른 모든 화면은 일반 그리드로 표출됩니다.

1. **지정 화면 화이트리스트 마스터 그리드 자동 적용 (21개 화면 한정)**:
   - 적용 대상 화면: `W_JA990C`, `W_JA010M3`, `W_JA010J`, `W_JA010Q`, `W_JA010H1`, `W_JA020K1`, `W_JA010H`, `W_JA010G`, `W_JA010B`, `W_JA032E_PUT`, `W_JA032E_CALL`, `W_JA032O`, `W_JA032C`, `W_JA050A`, `W_JA032K`, `W_JA032D`, `W_API_PARAMS`, `W_JA033A`, `W_JA033B`, `W_JA033C`, `W_SZX0SE`
   - 상기 21개 화면을 제외한 나머지 모든 화면은 자동 적용되지 않으며 기본 그리드로 표출됩니다.
   - 대상 화면 내에서도 디테일 그리드, 서브 그리드, 데이터 인스펙터, 모달/팝업 그리드는 적용 대상에서 엄격히 배제됩니다.
   - 오직 마스터 그리드에 한하여 `No.`(시퀀스/순번) 및 **체크박스 유형 컬럼(`rowSelection`, `type="checkbox"`, `used` 등)을 제외한 첫 번째 및 두 번째 데이터 컬럼(정확히 2개 컬럼)**에 자동으로 중복값 숨김이 적용됩니다. (`W_SZX0SE`의 경우 대분류 `seriesG1`, 시리즈 `seriesG2` 컬럼 적용)
2. **첫 번째 컬럼 유형 변경 시 하단 그룹 구분선 (Group Separator Border)**:
   - 첫 번째 데이터 컬럼(No 및 체크박스 제외 첫 컬럼, 예: `Company`, 펀드코드 등)의 값이 동일하게 유지되다가 다른 유형의 값으로 바뀔 때, **이전 데이터 그룹의 마지막 행 하단부에 `0.3px solid #64748b` 초슬림 구분선(`.aams-group-separator-row`)을 자동 생성**하여 데이터 그룹이 서로 다름을 시각적으로 명확하고 세련되게 구분합니다.
   - 합계 행(`isSummaryRow`) 직전의 마지막 데이터 행에도 동일하게 구분선이 적용됩니다.
3. **특정 그리드 비활성화 규격 (`suppressRepeating: false`)**:
   - 매 행마다 모든 값이 온전히 표출되어야 하는 특정 마스터 그리드의 경우, 초기화 옵션에 `suppressRepeating: false`를 선언하여 비활성화합니다:
     ```javascript
     gridMaster = new Tabulator(el, {
         height: "100%",
         suppressRepeating: false, // 해당 그리드만 중복 숨김 해제
         columns: [ ... ]
     });
     ```
4. **컬럼 단위 명시적 지정 표준 (`suppressRepeating: true`)**:
   - 3번째 이상의 컬럼에도 중복 숨김을 적용하거나 특정 컬럼에 명시할 경우 `suppressRepeating: true` 속성을 지정합니다:
     ```javascript
     { title: "Company", field: "company", width: 85, hozAlign: "center", suppressRepeating: true },
     { title: "자료유형", field: "snm", width: 200, hozAlign: "left", suppressRepeating: true },
     ```
5. **계층형(Hierarchy) 의존성 자동 연동**:
   - 복수 개의 컬럼에 `suppressRepeating`이 적용된 경우, N번째 컬럼은 앞선 상위 컬럼들의 값이 모두 일치할 때에만 숨김 처리됩니다.
   - 상위 컬럼(예: 회사명)이 변경되면 하위 컬럼(예: 자료유형)의 값이 우연히 같더라도 새로운 그룹의 시작이므로 정상 표출됩니다.
6. **원본 데이터 및 기존 formatter 보존**:
   - 화면에 표시되는 텍스트만 빈칸으로 처리될 뿐 `row.getData()` 원본 데이터는 온전히 보존되므로, 행 선택 및 상세 서브 그리드 연동이 완벽하게 유지됩니다.
   - 기존 사용자 정의 `formatter`가 설정된 경우에도 중복이 아닐 때 정상 실행되어 배지, 천단위 콤마 등의 스타일이 100% 보존됩니다.
   - 합계 행(`isSummaryRow: true`)이나 신규 행(`isNew: true`), 인라인 편집 셀은 숨김 대상에서 원천 배제됩니다.
