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
| **01. 백엔드 표준 가이드** | `corp_gr` 규격, srd 기반 DTO 매핑, `xx_` 컬럼 양방향 프로퍼티, JPA/QueryDSL(단일 테이블 조회/CUD) vs MyBatis(복합 조인) 기준, REST API 및 프로시저 호출 | [01-backend-standard.md](file:///d:/work/java_aams_html_ver/.agents/rules/01-backend-standard.md) |
| **02. Tabulator 그리드 표준** | srd 기반 컬럼 정의, 원클릭 인라인 편집, `p_xx_` 돋보기/`p_dd_` 달력 버튼(36px), 3단계 날짜 검증, 행 선택 삼중 안전망, **Rowfocus 2대 정책** | [02-tabulator-grid.md](file:///d:/work/java_aams_html_ver/.agents/rules/02-tabulator-grid.md) |
| **03. UI 스타일링 및 CSS 표준** | **Zero-Inline-Style 원칙**, 헤더 색상 클래스(`headerCssClass`), 데이터 셀 텍스트 색상, 가격/등락률 표준 클래스, 거래구분 및 상태 배지 | [03-ui-styling-css.md](file:///d:/work/java_aams_html_ver/.agents/rules/03-ui-styling-css.md) |
| **04. 공통 컴포넌트 & JS 유틸리티** | 상단 공통 툴바 표준 계약, dw_c 기반 필터 프래그먼트, **상시 활성화 & 수동 조회 단일 정책 (자동조회 금지/기존데이터 유지)**, DDDW 2칸 분할, 캘린더, 코드 검색, 재사용 JS 함수 | [04-common-components-js.md](file:///d:/work/java_aams_html_ver/.agents/rules/04-common-components-js.md) |
| **05. 레이아웃 & 반응형 표준** | MDI 단일 진입점 초기화(`startInit`), Zero-Garbage Code, `AamsSplitter` 드래그 리사이징, 권한별 폼 잠금 동기화, 반응형 브레이크포인트 (1415px, 876px), 모바일 세로 스택 | [05-layout-responsive.md](file:///d:/work/java_aams_html_ver/.agents/rules/05-layout-responsive.md) |
| **06. MRD 리포트 뷰어 표준** | Crownix Report 아키텍처, 백엔드 공통 RD API, 공통 리포트 프래그먼트, `AamsReport.bindViewer` 일체형 엔진 바인딩, 5종 포맷 내보내기, 상단 공통 [엑셀] 버튼 연동 | [06-report-viewer.md](file:///d:/work/java_aams_html_ver/.agents/rules/06-report-viewer.md) |

---

## 🏛️ AAMS 개발 불변 10대 핵심 헌장 (Core 10 Principles)

1. **회사그룹(`corp_gr`) 기본값 Fallback 절대 금지:**
   - 쿼리, 서비스, 프론트엔드 어디에서도 `corp_gr`에 임의의 기본값(예: `"000"`, `"2402"`)을 강제하지 않습니다. 항상 세션 및 상단 선택 컨텍스트에서 추출합니다.
2. **하드코딩 배제 및 srd 기반 1:1 DTO 매핑:**
   - `.srd` 파일의 쿼리문과 데이터 타입을 온전히 존중하여 DTO 필드를 구성하며, 파라미터 바인딩 부분만 변수화합니다.
   - 명칭 컬럼(`xx_` 또는 별칭)이 srd에 존재하는 경우 DTO에 반드시 양방향 getter/setter를 구성합니다.
3. **단일 테이블(JPA / QueryDSL) vs 복합 테이블(MyBatis) 기술 분기:**
   - 단일 테이블에 대한 기본 조회 및 CUD(등록/수정/삭제)는 **Spring Data JPA / EntityManager**(동적 검색 조건은 QueryDSL)를 사용하고, 2개 이상의 테이블 조인이나 복합 서브쿼리는 **MyBatis XML** 형식으로 작성합니다.
4. **인라인 편집 그리드 원클릭 편집 진입 필수 옵션 (`editTriggerEvent: "click"`):**
   - 편집 가능한 셀이 포함된 그리드는 단일 행 선택(`selectableRows: 1`) 환경에서도 비선택 행의 셀 클릭 즉시 에디터가 열리도록 `editTriggerEvent: "click"`을 필수 지정하고 컬럼에 `cellClick: aamsCellEdit`를 부여합니다.
5. **마스터-디테일 행 선택 삼중 안전망 및 중복 fetch 방지 가드:**
   - `setupTabulatorRowSelection(grid, syncDetail)`, `grid.on("rowClick")`, `grid.on("rowSelectionChanged")` 삼중 안전망을 적용하고, 동일 키값 재조회 방지 가드(`lastLoadedMasterKey === currentKey`)를 둡니다.
6. **데이터 조회 및 새로고침 시 행 포커스(Row Focus) 2대 표준 정책:**
   - **리포트 뷰어가 있는 경우:** 모바일(`width <= 876px`)에서는 첫 행 자동 선택 금지(deselect 유지), PC/태블릿(`width > 876px`)에서는 첫 번째 행 자동 선택(`rows[0].select()`).
   - **리포트 뷰어가 없는 경우:** 전 디바이스 환경에서 첫 번째 행을 자동 선택하여 상세 폼/그리드 즉시 바인딩.
7. **상단 필터 및 조회 버튼 상시 활성화 & 수동 조회 단일 정책 (웹 표준 UX 정책):**
   - 상단 필터바와 상단 툴바 [조회] 버튼은 항상 활성화(`enabled`) 상태를 유지합니다.
   - **필터 조건(날짜, DDDW, 코드검색, 회사그룹) 변경 시 자동 조회를 절대 실행하지 않습니다.**
   - 필터 조건이 변경되어도 테이블의 **기존 데이터는 그대로 유지하여 표출**하며, 오직 상단 [조회] 버튼(`pane.onSearch`) 클릭 시에만 단독 실행합니다.
8. **그리드 인라인 스타일 작성 절대 금지 (Zero-Inline-Style):**
   - `style="color:..."` 등의 인라인 스타일을 금지하고, `tabulator-custom.css`의 표준 클래스(`headerCssClass: "col-hdr-blue"`, `.cell-text-*`, `.cell-price-*`)를 사용합니다. 행 아웃라인 돌출도 엄격히 금지합니다 (Zero-Row-Outline).
9. **그리드 날짜 수기 입력 3단계 유효성 검증 체계:**
   - 1) 에디터 지정 (`aamsDateEditor`)
   - 2) 셀 편집 완료 시 검증 (`aamsValidateDateCell`)
   - 3) 상단 저장 버튼 시 전수 검증 (`aamsValidateGridDates`)
10. **공통 모듈 및 전역 자원 최대 재사용 (Zero-Garbage Code):**
    - MDI 부모에서 이미 로드된 JS/CSS를 화면 조각 HTML 내에서 중복 임포트하지 않으며, 공통 유틸리티 함수(`resolveCorpGr`, `getFilterYmd`, `showToast`, `formatNumber`, `AamsReport.bindViewer`)를 재정의하지 않고 즉시 호출합니다.
