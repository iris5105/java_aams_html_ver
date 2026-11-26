---
name: datawindow-migration
description: PowerBuilder DataWindow(.srd) 메타데이터를 분석하여 DTO, Thymeleaf 뷰, Tabulator 그리드 및 MRD 리포트로 전환할 때 사용하는 기술 가이드
---

# DataWindow 마이그레이션 스킬 (PowerBuilder `.srd` -> Tabulator & DTO)

PowerBuilder `.srd` 파일의 SQL, 컬럼 메타데이터, Summary 밴드, DDDW/버튼 속성을 AAMS 웹 표준(DTO + Tabulator + Thymeleaf)으로 1:1 전환하는 절차입니다.

---

## 1. `.srd` 메타데이터 추출 체크리스트

1. **SQL 및 파라미터 분석**
   - `retrieve="..."` 또는 `table(retrieve="...")` 내 SQL과 `arguments=(...)` 추출
   - 단일 테이블인지 2개 이상 JOIN/함수/서브쿼리인지 판별 (JPA vs MyBatis 분기 기준)
2. **컬럼 정의 매핑 (`table(column=...)` & `column(...)`)**
   - `text` 라벨 -> Tabulator `title` (단, `field: "fundCd"`는 항상 `"펀드번호"`)
   - `alignment` (`0`: left, `1`: right, `2`: center) -> `hozAlign`
   - `tabsequence` / `tab_order` (`0` 또는 `32766+`는 읽기 전용) -> `editor` 및 `editable` 여부
   - `format` -> 숫자 천단위 콤마(`formatNumber`), 날짜(`YYYY-MM-DD`), 퍼센트 등 `formatter` 매핑
3. **명칭 컬럼(`xx_`) 및 특수 버튼(`p_xx_`, `p_dd_`) 식별**
   - `xx_fund_cd`, `xx_yj_cd` 등 `xx_` 접두사 컬럼은 DTO에서 양방향 프로퍼티로 구성
   - 돋보기(`p_xx_`) -> `dynamic_code_search.js` 연동 버튼
   - 달력(`p_dd_`) -> 날짜 컬럼은 `editor: window.aamsDateEditor`, 버튼 클릭 시 `AamsCalendar.openDatePicker({ anchorEl: cell.getElement(), initialYmd, format: 'dash', onSelect })` 연동 (`cudManager.trackChange(row)` 포함)
4. **DDDW (DropDownDataWindow) 식별**
   - `dddw.name`, `dddw.displaycolumn`, `dddw.datacolumn` 확인 -> `DddwService` / `f_dddwctl.js` 및 Tabulator `editor: "list"` 매핑
5. **Summary 밴드 (`summary(height=...)`) 유무 확인**
   - `compute(band=summary expression="sum(...)")` 및 `text(band=summary ...)` 확인

---

## 2. Java DTO 생성 규칙

- `.agents/rules/02-dto-and-models.md` 준수:
  - 화면 전용 DTO 생성 (`{Screen}Dto`)
  - 데이터형 매핑: `char/varchar` -> `String`, `number/decimal` -> `BigDecimal` (또는 `Long`/`Integer`), `date/datetime` -> `String` (`YYYY-MM-DD`) 또는 `LocalDate`
  - `xx_` 명칭 컬럼 양방향 getter/setter 구현
  - CUD 상태 필드 포함: `isNew`, `isUpdated`, `isDeleted`, `rowStatus`

---

## 3. Tabulator 그리드 구현 규칙

- **필수 기본 옵션**:
  - `layout: "fitDataFill"` (13-tabulator-layout.md)
  - `height: "100%"`
  - 편집 컬럼 존재 시 `editTriggerEvent: "click"` 및 컬럼에 `cellClick: aamsCellEdit`
- **금지 사항**:
  - 그리드 상단/헤더에 조회 건수 배지(`<span class="badge">0건</span>`) 추가 금지
  - 행 선택 시 `outline` 스타일 사용 금지
- **Summary 행 구현 (06-tabulator-grid-summary.md)**:
  - `bottomCalc` 대신 데이터 끝 `{ isSummaryRow: true, ... }` 패턴 사용
  - `rowFormatter`에서 `aams-summary-row` 클래스 부여
  - 데이터 로드, 셀 편집(`cellEdited`), 행 추가/삭제 시 `recalcSummaryRow()` 호출
  - 저장(`saveData`) 및 마스터-디테일 연동(`syncDetail`) 시 `isSummaryRow` 제외 가드 필수
- **중복값 숨김 (04-tabulator-grid-basic.md)**:
  - 지정된 21개 마스터 그리드 화이트리스트 여부 및 `suppressRepeating` 옵션 확인

---

## 4. Thymeleaf 뷰 및 레이아웃 연결

- 최상위 `.view-container`에 `.layout-mobile-stack-container` 적용
- 상단 필터는 `templates/fragments/filter/*` 재사용 (필터 인접 액션 버튼은 동일 `.filter-left` 내 배치)
- 리포트 뷰어 동반 시 `templates/fragments/report/report_viewer :: reportViewer` + `AamsReport.bindViewer(...)` 사용
- `document.currentScript.closest('.tab-pane')`로 `pane`을 획득하고 `pane.onSearch`, `pane.onInput`, `pane.onSave`, `pane.onExcel`, `pane.onRefresh` 바인딩
- 파워빌더 `ib_managedata = false` 또는 `dw_list`의 `eb_new_false`/`eb_copy_false`/`eb_delete_false`가 `true`인 경우 `start()`에서 `pane.ibManageData = false`, `pane.ebNewFalse`, `pane.ebCopyFalse`, `pane.ebDeleteFalse`를 설정해 `ButtonRole.setSearchState`와 연동한다 (`ib_managedata = false`이면 입력/복사/삭제가 모두 비활성화됨).
