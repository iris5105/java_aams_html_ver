---
trigger: always_on
---

# AAMS 프로젝트 핵심 개발 규칙 (AGENTS.md)

본 문서는 PowerBuilder 12.6 레거시 시스템을 **Spring Boot 4.0.7 + Thymeleaf + Tabulator + Oracle 19c** 웹 환경으로 마이그레이션하는 `java_aams_html_ver` 프로젝트의 최상위 핵심 규칙입니다.  
세부 영역별 상세 표준은 `.agents/rules/01-*.md` ~ `13-*.md` 및 `develope-guide.md`를 함께 준수합니다.

---

## 1. 프로젝트 구조 (Project Structure)

```text
src/main/
├── java/com/kfp/aams/
│   ├── auth/          # 로그인 및 인증 처리
│   ├── common/        # 공통 API/서비스 (WorkDateService, DddwService, DynamicCodeSearchService, ButtonAuthService, RdReportService, RunService)
│   ├── config/        # Spring/Security/MyBatis/JPA 설정
│   ├── domain/        # 업무 도메인별 패키지 ({domain}/controller, service, dto, entity, repository, mapper)
│   ├── home/          # 대시보드/홈 화면
│   ├── menu/          # 메뉴 및 MDI 탭 라우팅
│   ├── security/      # JWT, CSRF, 회사그룹/프로그램 액션 인가 인터셉터 및 필터
│   └── util/          # 공통 유틸리티
└── resources/
    ├── mapper/        # MyBatis XML 매퍼 (2개 이상 테이블 JOIN, 오라클 함수, 프로시저)
    ├── rd/            # Crownix MRD 리포트 서식 관련 리소스
    ├── static/js/     # 공통 및 화면별 JS (common.js, filter.js, f_dddwctl.js, aams_report.js 등)
    └── templates/
        ├── fragments/ # 공통 프래그먼트 (filter/, report/, layout/, common/, tab_header.html)
        └── views/     # 도메인별 Thymeleaf 화면 (views/{domain}/w_*.html)
```

---

## 2. 네이밍 규칙 (Naming Conventions)

1. **URI 및 엔드포인트**
   - 화면 뷰 렌더링: `GET /views/{domain}/{viewName}` (예: `/views/usportfoliomodel/w_ja032a`)
   - 데이터 조회 API: `GET /api/{domain}/{screenId}/{resource}` (예: `/api/usportfoliomodel/ja032a/master`)
   - 데이터 저장 API: `POST /api/{domain}/{screenId}/save`
2. **DTO 및 모델 (02-dto-and-models.md)**
   - **화면별 DTO 분리**: 동일 테이블을 참조하더라도 화면마다 전용 DTO(`{Screen}Dto`)로 분리한다.
   - **명칭 컬럼(`xx_`) 양방향 매핑**: `.srd`의 `xx_fund_cd` 등은 `xxFundCd`로 매핑하고, 레거시 필드(`fundNm` 등)와 양방향 getter/setter를 구성한다.
   - **CUD 상태 필드 필수**: 그리드 일괄 저장을 위해 `isNew`, `isUpdated`, `isDeleted`, `rowStatus` (`C`/`U`/`D`)를 포함한다.
3. **JPA 엔티티 및 테이블 (01-backend-standard.md)**
   - 단일 테이블은 하나의 `@Entity` 및 `@Repository`만 생성하여 재사용한다.
   - 밑줄 없는 레거시 Oracle 테이블명(예: `SJT5J1`, `SHT0HG`)은 Hibernate 물리 네이밍 변환을 막기 위해 반드시 `@Table(name = "\"SJT5J1\"")`처럼 큰따옴표로 감싼다.
4. **Tabulator 그리드 컬럼 (04-tabulator-grid-basic.md, 13-tabulator-layout.md)**
   - `field: "fundCd"` 컬럼의 헤더 `title`은 항상 **`"펀드번호"`**로 지정한다.
   - 모든 `new Tabulator(...)`는 반드시 `layout: "fitDataFill"`을 명시한다.

---

## 3. 공통 함수 및 모듈 사용 규칙 (Common Functions & Reuse)

1. **MDI `pane` 스코핑 (08-toolbar-and-query-policy.md)**
   - `document.getElementById(...)` 하드코딩 금지. 반드시 `document.currentScript` 기준으로 상위 탭 컨테이너를 획득한다:
     ```javascript
     const currentScript = document.currentScript;
     const pane = currentScript ? (currentScript.closest('.tab-pane') || currentScript.closest('.view-container')) : null;
     ```
2. **상단 공통 툴바 계약 (`pane.on*`)**
   - 화면 내부에 조회/입력/저장 버튼을 중복 생성하지 않고 `pane.onSearch`, `pane.onInput`, `pane.onSave`, `pane.onDelete`, `pane.onExcel`, `pane.onRefresh`, `pane.onCorpGrChange`에 바인딩한다.
   - `onRefresh` 시 그리드 데이터뿐만 아니라 중복 조회 가드 키(`lastLoadedMasterKey`)와 선택 행 캐시도 함께 초기화한다.
3. **프론트엔드 공통 JS 재사용**
   - `common.js`: `aamsCellEdit` (편집 셀 `cellClick` 핸들러), `showToast`, `formatNumber`, 공통 fetch 헬퍼
   - `filter.js` & `templates/fragments/filter/*`: 필터 프래그먼트(`dc_ymd.html`, `corp_filter.html` 등) 및 `getFilterYmd`, `resolveCorpGr`
   - `f_dddwctl.js` / `dynamic_code_search.js`: DDDW 드롭다운 및 동적 코드 검색 팝업
   - `aams_splitter.js`: 좌우/상하 분할 스플리터 및 모바일 스택(`.layout-mobile-stack-container`)
   - `aams_report.js`: MRD 리포트 뷰어 일체형 바인딩(`AamsReport.bindViewer`)
4. **백엔드 공통 서비스 재사용**
   - 초기 작업일자(영업일자): `LocalDate.now()` 임의 사용을 지양하고 `WorkDateService.getWorkDateOrDefault(corpGr)`로 `SZX0AA.HYUN_YMD`를 조회해 주입한다.
   - DDDW/코드검색/리포트: `DddwService`, `DynamicCodeSearchService`, `RdReportService`를 재사용하고 개별 컨트롤러에 중복 구현하지 않는다.

---

## 4. 보안 정책 (Security Policy)

1. **회사그룹(`corpGr`) 등 주요 파라미터 fallback 절대 금지 (Zero-Default)**
   - 백엔드/프론트엔드 코드 내에 `'2402'`, `'1'`, `''` 등 기본값 하드코딩이나 임의 fallback을 두지 않는다.
2. **서버 사이드 인증·인가 필수**
   - UI에서 버튼을 숨기는 것을 인가로 간주하지 않는다.
   - `JwtAuthenticationFilter`, `CsrfCookieFilter`, `CookieSecurityFilter`, `CompanyGroupAuthorizationInterceptor`, `ProgramActionAuthorizationInterceptor`가 적용된 서버 API 단에서 권한 및 회사그룹 접근 제어를 검증한다.
3. **SQL Injection 및 XSS 방어**
   - MyBatis에서 동적 바인딩은 반드시 `#{param}`을 사용하며 `${param}` 문자열 치환을 금지한다.
   - 사용자 입력값을 HTML 문자열로 직접 조합할 때 이스케이프 처리를 준수한다.
4. **민감정보 및 운영 DB 보호**
   - 로그에 비밀번호, 토큰, 개인정보를 출력하지 않으며 운영 DB에 임의 DML/DDL을 실행하지 않는다.

---

## 5. 세부 규칙 문서 인덱스

- 백엔드/영속성: [01-backend-standard.md](file:///d:/work/java_aams_html_ver/.agents/rules/01-backend-standard.md), [02-dto-and-models.md](file:///d:/work/java_aams_html_ver/.agents/rules/02-dto-and-models.md), [03-oracle-mybatis-sql.md](file:///d:/work/java_aams_html_ver/.agents/rules/03-oracle-mybatis-sql.md)
- Tabulator 그리드: [04-tabulator-grid-basic.md](file:///d:/work/java_aams_html_ver/.agents/rules/04-tabulator-grid-basic.md), [05-tabulator-grid-events.md](file:///d:/work/java_aams_html_ver/.agents/rules/05-tabulator-grid-events.md), [06-tabulator-grid-summary.md](file:///d:/work/java_aams_html_ver/.agents/rules/06-tabulator-grid-summary.md), [13-tabulator-layout.md](file:///d:/work/java_aams_html_ver/.agents/rules/13-tabulator-layout.md)
- UI/레이아웃/공통/리포트: [07-ui-styling-css.md](file:///d:/work/java_aams_html_ver/.agents/rules/07-ui-styling-css.md), [08-toolbar-and-query-policy.md](file:///d:/work/java_aams_html_ver/.agents/rules/08-toolbar-and-query-policy.md), [09-common-components-js.md](file:///d:/work/java_aams_html_ver/.agents/rules/09-common-components-js.md), [10-layout-and-splitter.md](file:///d:/work/java_aams_html_ver/.agents/rules/10-layout-and-splitter.md), [11-responsive-mobile.md](file:///d:/work/java_aams_html_ver/.agents/rules/11-responsive-mobile.md), [12-report-viewer.md](file:///d:/work/java_aams_html_ver/.agents/rules/12-report-viewer.md)
