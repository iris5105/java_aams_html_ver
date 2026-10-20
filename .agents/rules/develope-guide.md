---
trigger: always_on
description: "AAMS 차세대 웹 시스템 화면 개발 프레임워크 표준 가이드 (Screen Development Framework & Master Blueprint)"
---

# AAMS 화면 개발 프레임워크 표준 가이드 (Screen Development Master Blueprint)

본 문서는 파워빌더 소스(`.srw`, `.srd`, `.srf`)를 기반으로 AAMS 화면을 신규 개발하거나 전환할 때 준수해야 하는 **실전 5단계 파이프라인(Pipeline)**, **컨트롤러 필수 모델 변수 규격**, **화면 표준 스켈레톤 템플릿(Master Boilerplate)**, 그리고 **세부 파트별 전문 기술 규정 색인(01~12)**을 정의한 최상위 프레임워크 개발 지침서입니다.

---

## 🚀 1. 표준 화면 개발 5단계 파이프라인 (Execution Pipeline)

### [Step 1] 파워빌더 소스 정밀 분석 (PB Source Analysis)
1. **부모 윈도우 클래스 확인 (`from ...`)**:
   - `from wt_vertdetail`: **좌우 수평 분할** (`.layout-split-h`, `.split-gutter-h`)
   - `from wt_sheet`, `from wt_maindetail`: **상하 수직 분할** (`.layout-split-v`, `.split-gutter-v`)
   - `from wt_dual`: **좌우 50:50 대등 비교**
   - `from wt_list`: **단일 그리드 목록** (`.layout-single`)
2. **스플릿바 컨트롤 및 드래그 대상 (`dragobject`) 확인**:
   - `pf_u_splitbar_vertical` (좌우) vs `pf_u_splitbar_horizontal` (상하)
   - 속성 중 `leftdragobject`, `rightdragobject`, `topdragobject`, `bottomdragobject`를 확인하여 3개 이상 그리드 중첩 분할(Nested Split: 좌측 1개 + 우측 상하 2개 등) 구조 파악
3. **상단 필터바(`dw_c`) dataobject 확인**:
   - `dc_ymd` (단일일자), `dc_ymd_dddw` (일자+구분), `dc_xx_ymd` (시작~종료), `dc_fund_ymd` (펀드+일자), `dc_ftymd_dddw` (기간+구분) 매핑
4. **그리드 DataWindow(`.srd`) 메타데이터 확인**:
   - 특수 컨트롤: `xx_btn_컬럼명` (돋보기 36px: 펀드검색 `xx_btn_fundCd`, 종목검색 `xx_btn_jmCd` ItemSearch 표준 기본 틀), `p_dd_` (달력 36px), `xx_` (명칭)
   - Summary 밴드: 집계식(`sum(...)`) 및 라벨 위치 확인

---

### [Step 2] 백엔드 계층 구현 (Backend Layer)
1. **DTO 작성 (srd 1:1 매핑)**:
   - srd SQL 쿼리 컬럼 및 데이터형 1:1 일치
   - `xx_` 명칭 컬럼 양방향 프로퍼티(`getXxFundCd`, `getFundNm`) 필수 구성
   - CUD 상태 관리 필드 포함 (`isNew`, `isUpdated`, `isDeleted`, `rowStatus`)
   - [세부 표준: 02-dto-and-models.md]
2. **영속성 계층 분기**:
   - 단일 테이블 CUD 및 단순 조회 ➔ **Spring Data JPA / EntityManager** (동일 테이블 엔티티 재사용, 더티 체킹 기반 부분 수정 필수)
   - 2개 이상 테이블 JOIN / 복합 함수 / 프로시저 ➔ **MyBatis XML 매퍼** (srd 원본 SQL 보존, `NULLIF` 타입 일치, 제수 0 방어)
   - [세부 표준: 01-backend-standard.md, 03-oracle-mybatis-sql.md]
3. **뷰 컨트롤러 구현 (`GET /views/...`)**:
   - `WorkDateService.getWorkDateOrDefault(corpGr)`를 반드시 호출하여 DB 영업일자(`SZX0AA.HYUN_YMD`) 주입 (Zero-LocalDate-Now 원칙)
   - 필수 모델 변수: `corpGr`, `workDate`, `initialYmd`, `ymd`, `fullpgm2` 주입
   - 명시적 생성자 주입 필수 (Zero-Lombok-ECJ-Conflict 원칙)

---

### [Step 3] HTML 레이아웃 및 템플릿 마크업 (HTML Layout)
1. **최상위 컨테이너 구성**:
   - `<div class="view-container layout-mobile-stack-container ...">` (모바일 290px 최소 높이 및 전체 세로 스크롤 보장)
2. **상단 공통 툴바 및 필터바**:
   - Row 1: `fragments/tab_header :: toolbarButtons`
   - Row 2: `fragments/filter/dc_...` 프래그먼트 연동
   - **UX 일체화 원칙**: 화면 전용 액션 버튼은 `.filter-left` 내에 하나의 div로 묶어 필터 바로 우측에 인접 배치 (오른쪽 끝 분리 금지)
   - [세부 표준: 08-toolbar-and-query-policy.md, 09-common-components-js.md, 11-responsive-mobile.md]
3. **분할 패널 레이아웃**:
   - Step 1 분석 결과에 따라 `.layout-split-h` 또는 `.layout-split-v` 마크업
   - [세부 표준: 10-layout-and-splitter.md]

---

### [Step 4] 프론트엔드 JS 초기화 및 툴바 계약 바인딩 (JS & Toolbar Binding)
1. **MDI 최상위 탭 컨테이너 획득 및 단일 진입점 (`startInit`)**:
   - `const pane = document.currentScript ? (document.currentScript.closest('.tab-pane') || document.currentScript.closest('.view-container')) : null;`
   - `isInitialized` 플래그로 중복 초기화 방지
2. **공통 컴포넌트 초기화**:
   - 기준일자 달력: `initFilterCalendar(pane, { onSelect: ... })` (수기 마크업 금지)
   - 드롭다운: `initFilterDddw(pane, config)` 또는 `f_dddwctl.get2ColItemFormatter` (2열 커스텀 드롭다운)
   - 스플리터: `AamsSplitter.init(pane)` (AamsSplitter.create 호출 절대 금지)
3. **Tabulator 그리드 빌드**:
   - 원클릭 편집 진입: `editTriggerEvent: "click"` 및 편집 셀 `cellClick: aamsCellEdit`
   - Zero-Inline-Style: `headerCssClass`, `cell-text-*`, 호가/시세 색상 동기화 (BID 빨강, ASK 파랑)
   - Zero-Count-Badge: 패널 헤더에 조회 건수 배지 절대 작성 금지
   - Zero-Row-Outline: 행 선택 시 커스텀 outline 금지
   - Summary 행: `{ isSummaryRow: true }` 데이터 행 패턴 (`.aams-summary-row` 연노랑)
   - [세부 표준: 04-tabulator-grid-basic.md, 05-tabulator-grid-events.md, 06-tabulator-grid-summary.md, 07-ui-styling-css.md]
4. **상단 공통 툴바 표준 계약 바인딩**:
   - `pane.onSearch`, `pane.onInput`, `pane.onSave`, `pane.onRefresh`, `pane.onCorpGrChange`, `pane.onExcel`
   - **수동 조회 단일 정책 (Always Enabled)**: 필터/회사 변경 시 자동 조회 금지, 기존 데이터 유지, 오직 상단 [조회] 클릭 시에만 단독 실행
   - **새로고침 시 완전 리셋 (Zero-Stale-Key)**: 가드 키 초기화(`lastLoadedMasterKey = null`), 자동 재조회 절대 금지, 안내 토스트 표출
   - **세션 기반 작업일자 관리 (Zero-Stale-LocalStorage-Date)**: `workDate`는 `sessionStorage`에서 관리
   - [세부 표준: 08-toolbar-and-query-policy.md, 09-common-components-js.md]

---

### [Step 5] 빌드 컴파일 및 무결성 검증 (Verification)
1. **자바스크립트 문법 검증**: Node 기반 스크립트 파싱 검증 (`node -c` 등)
2. **백엔드 빌드 검증**: `./mvnw.cmd compile` 실행하여 `BUILD SUCCESS` 확인

---

## 📦 2. 백엔드 컨트롤러 필수 모델 변수 스펙 (Controller Model Specification)

뷰 컨트롤러(`GET /views/...`)는 MDI 프레임워크 및 화면 컴포넌트와의 정상 연동을 위해 아래 4대 속성을 모델에 필수 주입해야 합니다:

| 모델 속성명 | 타입 | 권장 획득 방식 | 설명 |
| :--- | :--- | :--- | :--- |
| `corpGr` | `String` | `resolveCorpGr(paramCorpGr, cookieCorpGr, principal)` | 현재 세션/파라미터의 회사그룹 코드 (Fallback 하드코딩 절대 금지) |
| `workDate` | `String` | `workDateService.getWorkDateOrDefault(corpGr)` | DB 기준 작업일자 (`SZX0AA.HYUN_YMD`, `LocalDate.now()` 절대 금지) |
| `initialYmd` | `String` | `(paramYmd != null && !paramYmd.isBlank()) ? paramYmd : workDate` | 화면 초기 표출 기준일자 |
| `ymd` | `String` | `initialYmd`와 동일 값 매핑 | 하위 호환성용 날짜 변수 |
| `fullpgm2` | `String` | `menuService.getFullPgm2(pgmNo)` | 상단 네비게이션 브레드크럼 전체 경로 |

---

## 🏛️ 3. 화면 표준 스켈레톤 템플릿 (Master Boilerplate)

신규 화면 HTML 파일 작성 시 아래 스켈레톤 템플릿을 복사하여 기본 골격으로 사용합니다.

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<div class="view-container layout-split-h layout-mobile-stack-container" th:fragment="mainView"
     style="display: flex; flex-direction: column; height: 100%; width: 100%; overflow: hidden; background-color: #ffffff; position: relative;">

    <!-- 1. 상단 공통 툴바 (Row 1) -->
    <div class="view-toolbar">
        <div class="toolbar-left">
            <div th:replace="~{fragments/tab_header :: toolbarButtons}"></div>
        </div>
        <div th:replace="~{fragments/tab_header :: toolbarBreadcrumb}"></div>
    </div>

    <!-- 2. 상단 필터바 (Row 2: 필터 + 액션버튼 일체화) -->
    <div class="filter-bar">
        <div class="filter-left">
            <!-- dw_c dataobject에 맞는 프래그먼트 연동 -->
            <div th:replace="~{fragments/filter/dc_ymd :: filter(label='기준일자')}"></div>
            <!-- 화면 전용 액션 버튼은 filter-left 내부에 인접 배치 -->
            <!-- <button type="button" class="t-btn btn-action" id="btnAction1"><i class="fa-solid fa-play"></i> 실행</button> -->
        </div>
    </div>

    <!-- 3. 메인 콘텐츠 섹션 (분할 레이아웃) -->
    <div class="layout-split-h split-body layout-mobile-stack" data-split-key="PGM_H" data-default-ratio="50:50" style="flex: 1; min-height: 0;">
        <!-- 좌측/마스터 패널 -->
        <div class="split-pane split-left" style="width: 50%;">
            <div class="panel-header">
                <span class="panel-title">마스터 목록</span>
                <!-- 건수 배지 절대 작성 금지 (Zero-Count-Badge) -->
            </div>
            <div class="panel-body">
                <div id="gridMaster" class="tabulator-aams-grid"></div>
            </div>
        </div>

        <div class="split-gutter-h"></div>

        <!-- 우측/디테일 패널 -->
        <div class="split-pane split-right" style="width: 50%;">
            <div class="panel-header">
                <span class="panel-title">상세 내역</span>
            </div>
            <div class="panel-body">
                <div id="gridDetail" class="tabulator-aams-grid"></div>
            </div>
        </div>
    </div>

    <!-- 4. 화면 전용 스크립트 격리 블록 -->
    <script th:inline="javascript">
        (function () {
            // MDI 최상위 탭 컨테이너 획득 (Zero-Hardcoded-ID)
            const currentScript = document.currentScript;
            const pane = currentScript ? (currentScript.closest('.tab-pane') || currentScript.closest('.view-container')) : null;
            if (!pane) return;

            let gridMaster = null;
            let gridDetail = null;
            let isInitialized = false;
            let lastLoadedMasterKey = null;

            // [초기화 1] 달력 컴포넌트
            function initCalendar() {
                if (typeof window.initFilterCalendar === 'function') {
                    window.initFilterCalendar(pane, {
                        onSelect: function (selectedDate) {
                            // 필터 변경 시 자동 조회 금지 (규칙 08 준수)
                        }
                    });
                }
            }

            // [초기화 2] 그리드 빌드
            function initGrids() {
                const elMaster = pane.querySelector('#gridMaster');
                if (elMaster) {
                    gridMaster = new Tabulator(elMaster, {
                        height: "100%",
                        layout: "fitColumns",
                        selectableRows: 1,
                        editTriggerEvent: "click", // 원클릭 인라인 편집
                        columns: [
                            { title: "No.", formatter: "rownum", width: 50, hozAlign: "center", headerHozAlign: "center" }
                            // srd 메타데이터 기반 컬럼 구성
                        ]
                    });

                    // 행 선택 삼중 안전망
                    if (typeof setupTabulatorRowSelection === 'function') {
                        setupTabulatorRowSelection(gridMaster, function (row, data) {
                            syncDetail(row, data);
                        });
                    }
                    gridMaster.on("rowClick", function (e, row) {
                        syncDetail(row, row ? row.getData() : null);
                    });
                }

                const elDetail = pane.querySelector('#gridDetail');
                if (elDetail) {
                    gridDetail = new Tabulator(elDetail, {
                        height: "100%",
                        layout: "fitColumns",
                        selectableRows: 1,
                        columns: [
                            { title: "No.", formatter: "rownum", width: 50, hozAlign: "center", headerHozAlign: "center" }
                        ]
                    });
                }
            }

            // [연동] 마스터-디테일 동기화
            function syncDetail(row, masterRowData) {
                if (!row) return;
                const data = masterRowData || (row.getData ? row.getData() : null);
                if (!data || data.isSummaryRow) return;

                const currentKey = (data.corpGr || "") + "_" + (data.id || data.code || "");
                if (lastLoadedMasterKey === currentKey) return; // 중복 호출 방지 가드
                lastLoadedMasterKey = currentKey;

                loadDetailData(data);
            }

            // [조회] 마스터 데이터 로드
            function loadMasterData() {
                const corpGr = (typeof resolveCorpGr === 'function') ? resolveCorpGr(pane) : '';
                const ymd = (typeof getFilterYmd === 'function') ? getFilterYmd(pane, 'YYYYMMDD') : '';

                fetch(`/api/.../master?corpGr=${encodeURIComponent(corpGr)}&ymd=${encodeURIComponent(ymd)}`)
                    .then(res => res.json())
                    .then(data => {
                        lastLoadedMasterKey = null; // 재조회 시 첫 행 선택 보장
                        if (gridMaster) gridMaster.setData(data || []);
                    })
                    .catch(err => {
                        console.error("조회 실패:", err);
                        if (typeof showToast === 'function') showToast("조회 중 오류가 발생했습니다.", "error");
                    });
            }

            function loadDetailData(masterData) {
                // 서브 그리드 데이터 로드 로직
            }

            // [초기화 3] 스플리터
            function initSplitter() {
                if (window.AamsSplitter && typeof window.AamsSplitter.init === 'function') {
                    window.AamsSplitter.init(pane);
                }
            }

            // [초기화 4] 상단 공통 툴바 표준 계약 바인딩
            function initToolbar() {
                pane.onSearch = function () {
                    loadMasterData();
                };

                pane.onRefresh = function () {
                    if (gridMaster) gridMaster.clearData();
                    if (gridDetail) gridDetail.clearData();
                    lastLoadedMasterKey = null; // Zero-Stale-Key 리셋

                    // 자동 조회 절대 금지 (규칙 08 준수)
                    if (typeof showToast === 'function') showToast("화면이 초기화되었습니다.", "info");
                };

                pane.onCorpGrChange = function (newCorpGr) {
                    // 필터 변경 시 자동 조회 절대 금지 (규칙 08 준수)
                };

                pane.onExcel = function () {
                    if (gridMaster) {
                        gridMaster.download("xlsx", "목록.xlsx", { sheetName: "목록" });
                    }
                };
            }

            // [MDI 단일 진입점 실행]
            function startInit() {
                if (isInitialized) return;
                isInitialized = true;

                initCalendar();
                initGrids();
                initSplitter();
                initToolbar();
            }

            if (document.readyState === "loading") {
                document.addEventListener("DOMContentLoaded", startInit);
            } else {
                startInit();
            }
        })();
    </script>
</div>
</html>
```

---

## 📚 4. 파트별 세부 전문 기술 규정 색인 (Detailed Technical References)

각 파트별 상세 구현 규격, 오라클 특화 함수 및 안티패턴 방어 규칙은 아래 전문 문서를 참조합니다:

| 파트 번호 및 문서명 | 주요 다룸 내용 | 바로가기 |
| :--- | :--- | :--- |
| **01. 백엔드 아키텍처 및 영속성 표준** | Zero-Hardcoding, 단일 테이블(JPA/QueryDSL) vs 복합 조인(MyBatis), 동일 테이블 다화면 CUD 재사용(단일 Entity & 더티 체킹), REST API 규격, WorkDateService 연동 | [01-backend-standard.md](file:///d:/work/java_aams_html_ver/.agents/rules/01-backend-standard.md) |
| **02. DTO 및 데이터 모델링 규격** | srd 기반 1:1 DTO 매핑, `xx_` 명칭 컬럼 양방향 프로퍼티, CUD 상태 플래그(`isNew`, `isUpdated`, `isDeleted`), 화면별 전용 DTO 분리 | [02-dto-and-models.md](file:///d:/work/java_aams_html_ver/.agents/rules/02-dto-and-models.md) |
| **03. 오라클 SQL 및 MyBatis 매핑 표준** | srd 원본 SQL 조인 보존, `NULLIF` 타입 일치(ORA-00932 방어), 나눗셈 제수 0 방어(`NULLIF`), 오라클 프로시저(CallableStatement) 호출 규격 | [03-oracle-mybatis-sql.md](file:///d:/work/java_aams_html_ver/.agents/rules/03-oracle-mybatis-sql.md) |
| **04. Tabulator 그리드 기초 및 컬럼 구성** | srd 컬럼 매핑, 원클릭 인라인 편집(`editTriggerEvent: click`, `aamsCellEdit`), 신규 행 편집 예외, DDDW 드롭다운 값 유지, Zero-Count-Badge, Zero-Row-Outline | [04-tabulator-grid-basic.md](file:///d:/work/java_aams_html_ver/.agents/rules/04-tabulator-grid-basic.md) |
| **05. Tabulator 그리드 이벤트 및 인터랙션** | 특수 컨트롤 컬럼(`p_xx_` 돋보기 36px, `p_dd_` 달력 36px, `xx_` 수기입력), 3단계 날짜 검증, 행 선택 삼중 안전망, 서브그리드 포커스 탈취 방어, Row Focus 2대 정책 | [05-tabulator-grid-events.md](file:///d:/work/java_aams_html_ver/.agents/rules/05-tabulator-grid-events.md) |
| **06. Tabulator 그리드 Summary 합계 행** | Data Summary Row 패턴(연노랑 `#fbf2c4`, 클릭 차단), srd 집계식 매핑, 라이프사이클 4대 시점 동적 재계산(`recalcSummaryRow`), DB 저장 방어(Zero-Summary-Leakage) | [06-tabulator-grid-summary.md](file:///d:/work/java_aams_html_ver/.agents/rules/06-tabulator-grid-summary.md) |
| **07. UI 스타일링 및 그리드 CSS 표준** | Zero-Inline-Style 원칙, 컬럼 헤더 색상 클래스(`headerCssClass`), 호가/시세 색상 동기화(헤더-셀 일치: Zero-Color-Omission), 가격/등락률 및 거래구분 배지 | [07-ui-styling-css.md](file:///d:/work/java_aams_html_ver/.agents/rules/07-ui-styling-css.md) |
| **08. 상단 공통 툴바 및 웹 표준 수동 조회 정책** | 상단 공통 툴바 표준 계약, 최상위 MDI pane 획득, 새로고침 시 완전 리셋(Zero-Stale-Key), Always Enabled & 수동 조회 단일 정책, 필터 액션 버튼 인접 배치 | [08-toolbar-and-query-policy.md](file:///d:/work/java_aams_html_ver/.agents/rules/08-toolbar-and-query-policy.md) |
| **09. 공통 컴포넌트 & 프론트엔드 JS 표준** | dw_c 기반 필터 프래그먼트(`dc_ymd`), 달력(`initFilterCalendar`, 수기마크업 금지), DDDW 드롭다운(`initFilterDddw`, `f_dddwctl`), 세션 스토리지 기반 작업일자 관리(Zero-Stale-LocalStorage-Date) | [09-common-components-js.md](file:///d:/work/java_aams_html_ver/.agents/rules/09-common-components-js.md) |
| **10. MDI 탭 및 스플리터 분할 레이아웃** | MDI 단일 진입점 초기화(`startInit`), `AamsSplitter.init` 단일 진입점(`create` 호출 금지), srw 상속 및 중첩 분할(Nested Split), 컨테이너 높이 | [10-layout-and-splitter.md](file:///d:/work/java_aams_html_ver/.agents/rules/10-layout-and-splitter.md) |
| **11. 반응형 레이아웃 및 모바일 UX 표준** | 2대 브레이크포인트(1415px, 876px), 모바일 세로 순차 스택(`layout-mobile-stack`), 복합 그리드 최소 높이 290px(Zero-Squished-Grid), 모바일 탭 네비게이션 | [11-responsive-mobile.md](file:///d:/work/java_aams_html_ver/.agents/rules/11-responsive-mobile.md) |
| **12. MRD 리포트 뷰어 표준 가이드** | Crownix Report 아키텍처, 백엔드 공통 RD API, 공통 리포트 프래그먼트, `AamsReport.bindViewer` 일체형 엔진 바인딩, 5종 포맷 내보내기, 상단 공통 [엑셀] 연동 | [12-report-viewer.md](file:///d:/work/java_aams_html_ver/.agents/rules/12-report-viewer.md) |
| **📖 전체 화면 카탈로그 색인** | **대메뉴 > 소분류 > 화면번호(`PGM_NO`), 화면이름(`PGM_NM`), 파일명(`PGM_ID`), 파워빌더 소스(.srw) 및 웹 도메인/뷰 253개 전수 매핑** | [AAMS_SCREEN_CATALOG.md](file:///d:/work/java_aams_html_ver/AAMS_SCREEN_CATALOG.md) |
