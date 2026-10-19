---
trigger: always_on
description: "AAMS 차세대 웹 시스템 개발 표준 종합 헌장 및 세부 개발 가이드 목차(Index)"
---

# AAMS 차세대 웹 시스템 개발 표준 가이드 (Comprehensive Master Index)

본 문서는 AAMS(자산관리시스템)의 파워빌더 레거시 소스(`.srw`, `.srd`, `.srf`)를 스프링 부트(Spring Boot) 백엔드와 HTML5 / Tabulator / Crownix Report 기반 모던 웹으로 전환하기 위한 **최상위 개발 헌장 및 파트별 세부 가이드 목차**입니다.

화면 개발 및 기능 구현 시, 본 문서의 10대 핵심 원칙을 필수로 준수하고 작업 영역에 따라 아래의 **파트별 세부 전문 가이드**를 참조하십시오.

---

## 📚 파트별 세부 전문 개발 가이드 (Detailed Specialized Guides)

| 파트 번호 및 문서명 | 주요 다룸 내용 | 바로가기 |
| :--- | :--- | :--- |
| **01. 백엔드 아키텍처 및 영속성 표준** | Zero-Hardcoding, 단일 테이블(JPA/QueryDSL) vs 복합 조인(MyBatis), 동일 테이블 다화면 CUD 재사용(단일 Entity & 더티 체킹), REST API 규격 | [01-backend-standard.md](file:///d:/work/java_aams_html_ver/.agents/rules/01-backend-standard.md) |
| **02. DTO 및 데이터 모델링 규격** | srd 기반 1:1 DTO 매핑, `xx_` 명칭 컬럼 양방향 프로퍼티, CUD 상태 플래그(`isNew`, `isUpdated`, `isDeleted`), 화면별 전용 DTO 분리 | [02-dto-and-models.md](file:///d:/work/java_aams_html_ver/.agents/rules/02-dto-and-models.md) |
| **03. 오라클 SQL 및 MyBatis 매핑 표준** | srd 원본 SQL 조인 보존, `NULLIF` 타입 일치(ORA-00932 방어), 나눗셈 제수 0 방어(`NULLIF`), 오라클 프로시저(CallableStatement) 호출 규격 | [03-oracle-mybatis-sql.md](file:///d:/work/java_aams_html_ver/.agents/rules/03-oracle-mybatis-sql.md) |
| **04. Tabulator 그리드 기초 및 컬럼 구성** | srd 컬럼 매핑, 원클릭 인라인 편집(`editTriggerEvent: click`, `aamsCellEdit`), 신규 행 편집 예외, DDDW 드롭다운 값 유지, Zero-Count-Badge, Zero-Row-Outline | [04-tabulator-grid-basic.md](file:///d:/work/java_aams_html_ver/.agents/rules/04-tabulator-grid-basic.md) |
| **05. Tabulator 그리드 이벤트 및 인터랙션** | 특수 컨트롤 컬럼(`p_xx_` 돋보기 36px, `p_dd_` 달력 36px, `xx_` 수기입력), 3단계 날짜 검증, 행 선택 삼중 안전망, 서브그리드 포커스 탈취 방어, Row Focus 2대 정책 | [05-tabulator-grid-events.md](file:///d:/work/java_aams_html_ver/.agents/rules/05-tabulator-grid-events.md) |
| **06. Tabulator 그리드 Summary 합계 행** | Data Summary Row 패턴(연노랑 `#fbf2c4`, 클릭 차단), srd 집계식 매핑, 라이프사이클 4대 시점 동적 재계산(`recalcSummaryRow`), DB 저장 방어(Zero-Summary-Leakage) | [06-tabulator-grid-summary.md](file:///d:/work/java_aams_html_ver/.agents/rules/06-tabulator-grid-summary.md) |
| **07. UI 스타일링 및 그리드 CSS 표준** | Zero-Inline-Style 원칙, 컬럼 헤더 색상 클래스(`headerCssClass`), 호가/시세 색상 동기화(헤더-셀 일치: Zero-Color-Omission), 가격/등락률 및 거래구분 배지 | [07-ui-styling-css.md](file:///d:/work/java_aams_html_ver/.agents/rules/07-ui-styling-css.md) |
| **08. 상단 공통 툴바 및 웹 표준 수동 조회 정책** | 상단 공통 툴바 표준 계약, 최상위 MDI pane 획득, 새로고침 시 완전 리셋(Zero-Stale-Key), Always Enabled & 수동 조회 단일 정책, 필터 액션 버튼 인접 배치 | [08-toolbar-and-query-policy.md](file:///d:/work/java_aams_html_ver/.agents/rules/08-toolbar-and-query-policy.md) |
| **09. 공통 컴포넌트 & 프론트엔드 JS 표준** | dw_c 기반 필터 프래그먼트(`dc_ymd`), 달력(`initFilterCalendar`, 수기마크업 금지), DDDW 드롭다운(`initFilterDddw`), 다이나믹 검색, JS 유틸 | [09-common-components-js.md](file:///d:/work/java_aams_html_ver/.agents/rules/09-common-components-js.md) |
| **10. MDI 탭 및 스플리터 분할 레이아웃** | MDI 단일 진입점 초기화(`startInit`), `AamsSplitter.init` 단일 진입점(`create` 호출 금지), srw 상속 및 중첩 분할(Nested Split), 컨테이너 높이 | [10-layout-and-splitter.md](file:///d:/work/java_aams_html_ver/.agents/rules/10-layout-and-splitter.md) |
| **11. 반응형 레이아웃 및 모바일 UX 표준** | 2대 브레이크포인트(1415px, 876px), 모바일 세로 순차 스택(`layout-mobile-stack`), 복합 그리드 최소 높이 290px(Zero-Squished-Grid), 모바일 탭 네비게이션 | [11-responsive-mobile.md](file:///d:/work/java_aams_html_ver/.agents/rules/11-responsive-mobile.md) |
| **12. MRD 리포트 뷰어 표준 가이드** | Crownix Report 아키텍처, 백엔드 공통 RD API, 공통 리포트 프래그먼트, `AamsReport.bindViewer` 일체형 엔진 바인딩, 5종 포맷 내보내기, 상단 공통 [엑셀] 연동 | [12-report-viewer.md](file:///d:/work/java_aams_html_ver/.agents/rules/12-report-viewer.md) |
| **📖 전체 화면 카탈로그 색인** | **대메뉴 > 소분류 > 화면번호(`PGM_NO`), 화면이름(`PGM_NM`), 파일명(`PGM_ID`), 파워빌더 소스(.srw) 및 웹 도메인/뷰 253개 전수 매핑** | [AAMS_SCREEN_CATALOG.md](file:///d:/work/java_aams_html_ver/AAMS_SCREEN_CATALOG.md) |

---

## 🏛️ AAMS 개발 불변 16대 핵심 헌장 (Core 16 Principles)

1. **회사그룹(`corp_gr`) 기본값 Fallback 절대 금지:**
   - 쿼리, 서비스, 프론트엔드 어디에서도 `corp_gr`에 임의의 기본값(예: `"000"`, `"2402"`)을 강제하지 않습니다. 항상 세션 및 상단 선택 컨텍스트에서 추출합니다.
2. **하드코딩 배제 및 srd 기반 1:1 DTO 매핑:**
   - `.srd` 파일의 쿼리문과 데이터 타입을 온전히 존중하여 DTO 필드를 구성하며, 파라미터 바인딩 부분만 변수화합니다.
   - 명칭 컬럼(`xx_` 또는 별칭)이 srd에 존재하는 경우 DTO에 반드시 양방향 getter/setter를 구성합니다.
3. **단일 테이블(JPA / QueryDSL) vs 복합 테이블(MyBatis) 기술 분기 및 단일 엔티티 재사용 원칙:**
   - 단일 테이블에 대한 기본 조회 및 CUD(등록/수정/삭제)는 **Spring Data JPA / EntityManager**(동적 검색 조건은 QueryDSL)를 사용하고, 2개 이상의 테이블 조인이나 복합 서브쿼리는 **MyBatis XML** 형식으로 작성합니다.
   - **동일 테이블 다화면 CUD 재사용 표준 (Single-Entity & Multi-Screen DTO)**: 여러 화면에서 동일한 단일 테이블을 조작할 때 Entity와 Repository는 중복 생성 없이 단 하나만 공통으로 재사용하며, 추가 컬럼은 기존 Entity에 누적 확장합니다. 화면 입출력은 화면별 DTO로 철저히 분리하고, 수정 시에는 `em.merge()` 대신 영속성 조회 후 **더티 체킹(Dirty Checking)**을 적용하여 타 화면 컬럼의 null 덮어쓰기를 원천 방지합니다.
4. **인라인 편집 그리드 원클릭 편집 진입 필수 옵션 (`editTriggerEvent: "click"`):**
   - 편집 가능한 셀이 포함된 그리드는 단일 행 선택(`selectableRows: 1`) 환경에서도 비선택 행의 셀 클릭 즉시 에디터가 열리도록 `editTriggerEvent: "click"`을 필수 지정하고 컬럼에 `cellClick: aamsCellEdit`를 부여합니다.
5. **마스터-디테일 행 선택 삼중 안전망 및 새로고침 시 완전 리셋 (Zero-Stale-Key 원칙):**
   - `setupTabulatorRowSelection(grid, syncDetail)`, `grid.on("rowClick")`, `grid.on("rowSelectionChanged")` 삼중 안전망을 적용하고, 동일 키값 재조회 방지 가드(`lastLoadedMasterKey === currentKey`)를 둡니다.
   - 상단 [새로고침](`pane.onRefresh`) 시에는 반드시 `lastLoadedMasterKey = null`로 초기화하여 재조회 시 첫 행 데이터 조회가 차단되지 않도록 보장합니다.
   - **새로고침 핸들러 내부에서 데이터를 자동으로 재조회(`loadData()`, `loadFundList()`)하는 것은 엄격히 금지**되며, 화면 초기화(`clearData`) 및 안내 토스트(`"화면이 초기화되었습니다."`) 표출만 수행합니다.
6. **데이터 조회 및 새로고침 시 행 포커스(Row Focus) 2대 표준 정책:**
   - **리포트 뷰어가 있는 경우:** 모바일(`width <= 876px`)에서는 첫 행 자동 선택 금지(deselect 유지), PC/태블릿(`width > 876px`)에서는 첫 번째 행 자동 선택(`rows[0].select()`).
   - **리포트 뷰어가 없는 경우:** 전 디바이스 환경에서 첫 번째 행을 자동 선택하여 상세 폼/그리드 즉시 바인딩.
7. **상단 필터 및 조회 버튼 상시 활성화 & 수동 조회 단일 정책 (MDI pane 툴바 표준 계약):**
   - 상단 필터바와 상단 툴바 [조회] 버튼은 항상 활성화(`enabled`) 상태를 유지합니다.
   - 화면 스크립트에서는 `document.currentScript.closest('.tab-pane')`으로 최상위 탭 `pane`을 획득하고 `pane.onSearch`, `pane.onRefresh` 등을 필수로 바인딩합니다 (하드코딩 ID 금지).
   - **필터 조건(날짜, DDDW, 코드검색, 회사그룹) 변경 시 자동 조회를 절대 실행하지 않습니다.**
   - 필터 조건이 변경되어도 테이블의 **기존 데이터는 그대로 유지하여 표출**하며, 오직 상단 [조회] 버튼(`pane.onSearch`) 클릭 시에만 단독 실행합니다.
   - **필터 관련 액션 버튼 인접 배치 (UX 일체화 원칙)**: 화면 전용 보조 버튼(변동성재계산, 평잔재계산 등)은 오른쪽 끝(`.filter-actions`)으로 분리하지 않고, 필터 컴포넌트와 함께 **동일한 `<div class="filter-left">` 내부에 하나의 div로 묶어** 필터 바로 우측에 나란히 배치합니다.
8. **그리드 인라인 스타일 작성 절대 금지 및 호가/시세 색상 동기화 (Zero-Inline-Style & Zero-Color-Omission):**
   - `style="color:..."` 등의 인라인 스타일을 금지하고, `tabulator-custom.css`의 표준 클래스(`headerCssClass`, `.cell-text-*`, `.cell-price-*`)를 사용합니다. 행 아웃라인 돌출도 엄격히 금지합니다 (Zero-Row-Outline).
   - 기본 식별자 컬럼(펀드코드, 펀드명, 종목명, 옵션종목)은 시스템 기본 검은색 텍스트를 유지하며, 호가/시세(BID/ASK) 컬럼처럼 헤더에 색상이 들어간 경우 데이터 셀 포매터(`cell-text-red`, `cell-text-blue`)에서도 동일 색상을 반드시 동기화 적용합니다.
9. **그리드 날짜 수기 입력 3단계 유효성 검증 체계:**
   - 1) 에디터 지정 (`aamsDateEditor`)
   - 2) 셀 편집 완료 시 검증 (`aamsValidateDateCell`)
   - 3) 상단 저장 버튼 시 전수 검증 (`aamsValidateGridDates`)
10. **공통 모듈 및 전역 자원 최대 재사용 (Zero-Garbage Code):**
    - MDI 부모에서 이미 로드된 JS/CSS를 화면 조각 HTML 내에서 중복 임포트하지 않으며, 공통 유틸리티 함수(`resolveCorpGr`, `getFilterYmd`, `initFilterDddw`, `showToast`, `formatNumber`, `AamsReport.bindViewer`)를 재정의하지 않고 즉시 호출합니다.
11. **파워빌더 DataWindow Summary 밴드 합계 행 표준 및 저장 방어 (Zero-Summary-Leakage):**
    - `.srd`의 `summary` 밴드(라벨 및 집계식)가 존재하는 경우 Tabulator 푸터 대신 데이터 마지막 행(`{ isSummaryRow: true, ... }`, `.aams-summary-row` 연노랑 배경)으로 구성합니다.
    - 데이터가 0건일 때는 표출하지 않으며, 행 추가/복사 시 항상 맨 마지막 위치를 유지하고, DB 저장 시에는 CUD 목록에서 원천 배제합니다.
12. **MyBatis SQL 오라클 데이터 타입 일치 표준 (Zero-Type-Mismatch & ORA-00932 방어):**
    - `NULLIF(expr1, expr2)` 함수 호출 시 두 인자의 데이터 타입이 완전히 일치해야 합니다. 문자열 연산 결과(`SUBSTR(...)`)와 숫자 리터럴(`0`)을 비교할 때에는 반드시 `TO_NUMBER(SUBSTR(...))`로 형변환을 통일하여 `ORA-00932` 에러를 원천 차단합니다.
    - 나눗셈 연산 시 제수(Divisor)가 0이 될 가능성이 있는 경우 반드시 `NULLIF(#{divisor}, 0)`로 제수 0 방어를 적용합니다.
13. **파워빌더 원본 소스(.srw) 상속 구조 및 스플릿바 정밀 분석 기반 레이아웃 무결성 원칙:**
    - 타 화면 마크업을 맹목적으로 복사(Blind-Copy)하여 화면 배치를 임의 결정하는 행위를 엄격히 금지합니다.
    - 반드시 원본 창(`.srw`)의 부모 클래스(`wt_vertdetail`: 좌우 분할 vs `wt_sheet`/`wt_maindetail`: 상하 분할)와 스플릿바 컨트롤(`pf_u_splitbar_vertical`, `pf_u_splitbar_horizontal`, `left/right/top/bottomdragobject`)의 방향 및 컨트롤 좌표(`x, y, width, height`)를 철저히 검증하여 중첩 분할(`layout-split-h` 내 `layout-split-v` 또는 그 반대)의 귀속 관계를 100% 무결하게 일치시킵니다.
14. **스플리터 초기화 API 단일 진입점 표준 (`AamsSplitter.init` 필수, `AamsSplitter.create` 절대 금지):**
    - `aams_splitter.js`에는 `create()` 함수가 존재하지 않으며, 임의의 `AamsSplitter.create(...)`를 호출하면 `Uncaught TypeError: window.AamsSplitter.create is not a function` 런타임 오류가 발생합니다.
    - 스플리터 초기화는 반드시 **`window.AamsSplitter.init(currentPane)`** 1줄 단일 진입점으로만 호출하며, 리사이즈 완료 시 그리드 재계산(`redrawGrids`)은 스플리터 내부 마우스업 핸들러에서 자동 처리됩니다.
15. **상단 기준일자 필터 마크업 및 달력 컴포넌트 연동 표준 (Zero-Manual-Date-Markup & `initFilterCalendar`):**
    - 상단 필터바의 날짜 입력창을 부트스트랩 `.input-group` 클래스나 임의의 `<input>` + `<button>`으로 수기 작성하는 행위를 엄격히 금지합니다. 수기 작성 시 필수 래퍼(`.aams-calendar-wrapper`)가 누락되어 달력 팝오버가 동작하지 않습니다.
    - 기준일자 필터는 반드시 타임리프 공통 프래그먼트인 **`th:replace="~{fragments/filter/dc_ymd :: filter(label='...')} "`**를 사용해야 하며, 스크립트에서는 **`initFilterCalendar(currentPane, options)`**로 초기화합니다. `AamsCalendar` 직접 호출 시에는 반드시 `AamsCalendar.init('filterYmd', options)`의 2인자 시그니처를 준수해야 합니다.
16. **모든 DDDW 드롭다운의 2열 커스텀 컴포넌트 필수 적용 표준 (Zero-Native-Select & `f_dddwctl.get2ColItemFormatter`):**
    - 상단 필터바 및 화면 내의 모든 DDDW/드롭다운(펀드, 포트, 매매처, 거래구분 등)은 브라우저 기본 `<select>` 태그에 `<option>`만 추가하여 방치하는 것을 엄격히 금지합니다.
    - 정적 및 동적 데이터 여부와 관계없이 반드시 `window.initFilterDddw` 또는 `window.f_dddwctl.get2ColItemFormatter(selectEl, options, config)`를 호출하여 파워빌더 DataWindow와 동일한 **[코드 | 명칭] 2열 테이블형 커스텀 드롭다운(`.dddw-select-custom`)으로 일관되게 변환**해야 합니다.

