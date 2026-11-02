---
trigger: always_on
description: "AAMS 차세대 웹 시스템 화면 개발 프레임워크 표준 가이드 (Screen Development Framework & Master Blueprint)"
---

## 0. 2026 기준 구현 패턴 및 우선순위

이 절은 Daily Advisory와 USPM 실구현을 기준으로 정리한 최신 기준이다. 아래 내용과 기존 절이 충돌하면 이 절을 우선한다.

### 0.1 대표 구현 화면

| 화면 | 기준으로 삼을 구조 |
| --- | --- |
| `views/dailyadvisory/w_ja030c.html` | 단일 그리드, `dc_ymd_dddw` 필터, `f_dddwctl.retrieveMultiple`, MyBatis 복합 조회 + JPA CUD |
| `views/dailyadvisory/w_ja010a.html` | 날짜 편집기, 코드검색 `p_xx_`, master-detail 선택 연동, 저장 payload |
| `views/usportfoliomodel/w_ja032a.html` | 상하 Split 안의 좌우 중첩 Split, master → port → detail, MyBatis 조회 + JPA 단일 테이블 CUD |
| `views/usportfoliomodel/w_ja032f.html` | 화면 전용 DTO/API, 기준일자 조회, 복수 데이터셋 분리 |

PB 원본의 `dw_c`, DataWindow, `ue_*` 이벤트와 위 구현 화면을 함께 비교한 뒤 개발한다. 화면별로 자동 조회·수동 조회, 입력 가능 여부, DETAIL 버튼 권한이 다르므로 공통 규칙을 임의로 덮어쓰지 않는다.

### 0.2 실제 프로젝트 경로

```text
src/main/java/com/kfp/aams/domain/{domain}/
├─ controller/{Pgm}Controller.java
├─ dto/{Pgm}...Dto.java
├─ entity/{Entity}.java, {Entity}Id.java
├─ mapper/{Pgm}Mapper.java
├─ mapper/querydsl/{Pgm}JpaRepository.java 또는 {Pgm}QueryDslRepository.java
├─ mapper/xml/{Pgm}Mapper.xml
└─ service/{Pgm}Service.java

src/main/resources/templates/views/{domain}/{view}.html
```

현재 `application.properties`의 MyBatis 경로는 다음과 같다.

```properties
mybatis.mapper-locations=classpath*:com/kfp/aams/**/*.xml
```

따라서 업무 XML은 `src/main/java/com/kfp/aams/**/mapper/xml`에 둔다. `src/main/resources/mapper`로 옮기려면 mapper-locations를 함께 변경하고 전체 매퍼를 같은 기준으로 검증해야 한다. XML namespace는 Mapper 인터페이스의 완전한 클래스명과 일치해야 한다.

### 0.3 데이터 접근 선택표

화면 단위가 아니라 SELECT/CUD 단위로 구현 방식을 선택한다. USPM처럼 한 화면에서 두 방식을 혼합할 수 있다.

| 대상 | 기본 방식 | 판단 기준 |
| --- | --- | --- |
| 단일 테이블 조회·입력·수정·삭제 | JPA EntityManager / Spring Data JPA / QueryDSL | 엔티티 PK가 명확하고 한 테이블만 사용하는 경우 |
| 2개 이상 테이블 JOIN, 뷰, 복합 함수 | MyBatis Mapper + XML | PB SQL의 JOIN·서브쿼리·Oracle 함수 결과를 보존해야 하는 경우 |
| 저장 프로시저 | MyBatis XML callable | PB의 `SR_...` 또는 프로시저 호출을 대체하는 경우 |
| 단일 테이블 bulk delete/조건 delete | QueryDSL/JPA bulk | 서비스에서 자식 삭제 순서와 트랜잭션을 보장하는 경우 |

서비스에 SQL을 작성하지 않는다. 복합 조회를 JPA 문자열로 억지 변환하지 않고, 단순 단일 테이블 조회를 화면마다 중복 MyBatis로 만들지 않는다.

### 0.4 Controller·Service·DTO 기준

- Controller는 렌더링·인증 사용자·파라미터 변환·HTTP 응답만 담당하고 업무 계산과 SQL은 Service/Repository/Mapper로 보낸다.
- 생성자 주입은 명시적 생성자 또는 `@RequiredArgsConstructor` 중 하나를 사용한다. `@RequiredArgsConstructor`를 금지하지 않으며, 같은 클래스에 중복 생성자를 두지 않는다.
- `corpGr`는 파라미터·권한 사용자·쿠키 등 기존 화면 정책을 따르고 임의 회사그룹을 하드코딩하지 않는다.
- 기준일자는 `WorkDateService.getWorkDateOrDefault(corpGr)`를 우선한다. `LocalDate.now()`는 기존 화면 호환상 명시적으로 필요한 fallback일 때만 사용한다.
- 날짜 RequestParam은 `LocalDate`와 `@DateTimeFormat(pattern="yyyy-MM-dd", fallbackPatterns={"yyyyMMdd","yyyy.MM.dd"})`를 사용한다.
- DTO의 날짜는 `LocalDate`/`LocalDateTime`, 금액·수량·비율은 `BigDecimal`을 우선한다. JSON 날짜가 필요한 DTO에는 `@JsonFormat(pattern="yyyy-MM-dd")`를 적용한다.
- master/detail/save DTO를 분리하고, 변경이 필요한 그리드 DTO에는 `isNew`, `isUpdated`, `isDeleted`, `rowStatus`를 둔다.
- `fundCd` 컬럼의 화면 헤더는 반드시 `펀드번호`로 표기한다. `fundNm`, `xxFundCd`에는 적용하지 않는다.

### 0.5 MyBatis XML 규칙

- XML은 `src/main/java/com/kfp/aams/domain/{domain}/mapper/xml`에 둔다.
- `@Param` 이름과 XML parameter 이름을 일치시킨다.
- XML escape(`&lt;`, `&gt;`, `&lt;=`, `&gt;=`) 또는 해당 비교식만 CDATA를 사용한다. SELECT 전체를 CDATA로 감싸지 않는다.
- Oracle 날짜 컬럼은 DTO의 `LocalDate`와 타입을 맞춘다. 문자열을 무분별하게 `TO_DATE`로 변환하지 않는다.
- 나눗셈은 `NULLIF(분모, 0)`로 보호하고, NULL 타입과 alias를 확인한다.
- 화면에 실제 필요한 조회만 작성한다. PB에 없는 검증용 SELECT를 임의로 추가하지 않는다.

### 0.6 HTML·JS 구조

- 최상위는 `view-container`이며 공통 toolbar는 `fragments/tab_header :: toolbarButtons`, breadcrumb는 `toolbarBreadcrumb`를 사용한다.
- 단일 목록은 `layout-single`, 좌우는 `layout-split-h`, 상하는 `layout-split-v`를 사용한다. USPM처럼 중첩 Split이 필요하면 하위 pane 안에 좌우 Split을 둔다.
- Split은 `window.AamsSplitter.init(pane)`만 호출한다. `AamsSplitter.create`는 사용하지 않는다.
- 화면 스크립트는 `document.currentScript`에서 pane을 찾고 `isInitialized`로 중복 실행을 막는다.
- 초기화 순서는 `pane 확보 → DDDW 옵션 준비 → Tabulator 생성 → Splitter 초기화 → PB 근거가 있는 초기 조회`를 기본으로 한다. DDDW가 컬럼 editor 생성에 필요하면 DDDW 완료 후 그리드를 만들고, 단순 formatter 옵션이면 그리드 생성 후 비동기 반영할 수 있다.
- Tabulator는 `tableBuilt` 이전에 `redraw()`하지 않는다. `f_dddwctl` 완료 콜백과 Splitter 리사이즈에서는 `tableBuilt` 완료 여부를 확인한 `safeRedraw(grid)`를 사용하고, 숨겨진 탭은 활성화 후 갱신한다.
- 모바일 단순 Master·Detail 상하 Split은 `layout-split-v layout-mobile-stack`을 유지하고 공통 `layout-split-v.css` 규칙으로 상단과 하단을 각각 최소 290px 확보한다. 하단에 중첩 Split·메모·입출금 패널이 있는 복합 화면은 전용 예외 규칙을 적용하며, 화면별 `height: ... !important`를 중복 작성하지 않는다.
- 모바일 Tabulator 컨테이너는 `height:100%`를 사용하고, pane의 `.pane-body`/`.grid-table-wrapper`는 `flex:1; min-height:0; overflow:hidden` 구조를 유지한다. 이를 깨뜨리는 고정 높이·중첩 스크롤을 추가하지 않는다.
- 좌측/상단 pane에 중첩 Split이 있는 USPM 화면은 부모 pane의 모바일 고정을 해제하고 내부 자식 pane을 공통 290px 규칙으로 세로 전개한다. 중첩 구조를 화면별 임시 CSS로 복제하지 않는다.
- 단일 화면의 모바일 하단 여백은 5px로 제한한다. 두 pane이 모두 Tabulator이면 50:50으로 배치하고, 한쪽만 Tabulator이면 그리드 pane은 약 10행 높이(360px), 반대 pane은 내용 기반 높이를 사용한다.
- Master 그리드와 입력 폼 DETAIL 조합은 모바일에서 DETAIL을 중앙 모달로 전환하고, 모달 내부에 새로고침·저장·닫기 액션을 제공한다. 데스크톱 Split은 그대로 유지한다.
- `formatDateVal`, `aamsDateEditor`, `aamsCellEdit`를 날짜 표준으로 사용한다. API는 `yyyy-MM-dd`를 기준으로 한다.
- `p_xx_` 검색 버튼과 `p_dd_` 달력 버튼은 별도 36px 컬럼으로 만들고, 기존 행 보호 조건과 버튼 disabled 상태를 함께 적용한다.
- DDDW는 `ue_dddw_retrieve`에서 관리한다. 단일 옵션은 `f_dddwctl(...)`, 복수 옵션은 `f_dddwctl.retrieveMultiple({...})`을 사용하고 결과는 `dddwOptionsMap`으로 정규화한다. 2열 옵션은 `get2ColItemFormatter`를 사용한다.
- PB `ue_retrieve`는 웹에서 `pane.onSearch`/`pane.onRetrieve`와 화면 조회 함수의 진입점으로 매핑한다. `ue_dddw_retrieve`와 업무 데이터 조회를 무조건 한 함수로 합치지 말고, PB 이벤트 순서와 탭 범위를 보존한다.

### 0.7 Master·Detail·탭 조회

- PB의 탭 선택 이벤트가 조회를 수행하면 `activate(tabId)`에서 해당 탭만 조회한다. PB가 조회 버튼을 기다리면 `pane.onSearch`에서 수동 조회한다.
- `eb_direct_retrieve = true` 또는 PB `open` 이벤트로 초기 조회가 근거화된 경우에도 DDDW·Tabulator·Splitter 초기화가 끝난 뒤 조회한다. `tableBuilt` 이전의 자동 조회와 숨겨진 탭의 즉시 redraw를 금지한다.
- master 선택 시 `corpGr + ymd + fundCd + portNum`처럼 실제 키를 조합해 detail API를 호출한다. 필수 키가 없으면 이전 detail을 지우고 빈 목록을 표시한다.
- 탭 화면의 공통 버튼은 활성 탭의 master/detail만 조작한다. 전체 탭을 일괄 삭제하거나 첫 번째 그리드를 자동 선택하지 않는다.
- 화면별 예외는 템플릿에서 `pane.onRefresh`, `pane.onInput`, `pane.onCopy`, `pane.onDelete`, `pane.onSave`, `pane.onExcel`로 처리한다. 화면 하나의 예외를 위해 공통 `button.js`를 수정하지 않는다.
- `detailNav` 버튼 조합은 PB detail의 `eb_new_false`, `eb_copy_false`, `eb_delete_false`, 권한 문자열을 그대로 반영한다. 버튼이 있다고 저장 API가 생기는 것은 아니다.

### 0.8 저장·삭제·프로시저

- 프론트는 변경 목록과 CUD 상태를 payload로 보낸다.
- 단일 테이블 CUD는 EntityManager `persist/find/remove`와 dirty checking을 사용한다.
- 복수 테이블 저장은 Service에서 부모·자식 처리 순서와 트랜잭션을 명시한다.
- 복합 테이블 update 또는 프로시저는 MyBatis XML을 사용한다.
- 저장 API가 없으면 저장 성공 메시지를 표시하지 않는다. 미지원 상태를 명확히 안내한다.

### 0.9 화면 예외와 공통 파일 변경 원칙

화면별 동작 차이는 먼저 화면 파일에서 해결한다. 공통 JS/CSS 수정은 다음 조건을 모두 만족할 때만 한다.

1. 동일 문제가 2개 이상의 화면에서 재현된다.
2. 기존 화면의 버튼·탭·조회 흐름에 대한 회귀 영향 검토가 끝났다.
3. 공통 변경 대신 화면 전용 계약으로 해결할 수 없다는 근거가 있다.

### 0.10 완료 검증

```powershell
# UTF-8 inline script 추출 후
node --check <script.js>

# 백엔드
./mvnw.cmd -DskipTests compile

# 충돌·공백 검사
git diff --check
rg -n "<<<<<<<|=======|>>>>>>>" src/main/java src/main/resources
```

브라우저에서 탭 진입·조회·행 선택·날짜 편집·저장/삭제·엑셀 다운로드까지 확인해야 완료로 본다.

---

## 공통 컬럼 헤더 명칭 규칙

- `field: "fundCd"`인 Tabulator 컬럼의 헤더는 항상 `title: "펀드번호"`로 작성한다.
- `펀드코드`, `펀드`, `관리번호` 등 다른 헤더명은 사용하지 않는다. `xxFundCd`와 `fundNm`에는 이 규칙을 적용하지 않는다.
- 상세 규격과 예시는 [04-tabulator-grid-basic.md](04-tabulator-grid-basic.md)의 `fundCd` 컬럼 헤더 표준을 따른다.

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
   - 명시적 생성자 또는 `@RequiredArgsConstructor` 기반 생성자 주입을 사용한다. 클래스 내부에서 두 방식을 중복 사용하지 않는다.

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
   - 좌우 분할은 `split-pane pane-left` / `split-pane pane-right`와 `split-gutter-h`, 상하 분할은 `split-pane pane-top` / `split-pane pane-bottom`과 `split-gutter-v`를 사용한다. `split-left/right`, `split-top/bottom`, `gutter-h/v`는 사용 금지
   - [세부 표준: 10-layout-and-splitter.md]

---

### [Step 4] 프론트엔드 JS 초기화 및 툴바 계약 바인딩 (JS & Toolbar Binding)
1. **MDI 최상위 탭 컨테이너 획득 및 단일 진입점 (`startInit`)**:
   - `const pane = document.currentScript ? (document.currentScript.closest('.tab-pane') || document.currentScript.closest('.view-container')) : null;`
   - `isInitialized` 플래그로 중복 초기화 방지
2. **공통 컴포넌트 초기화**:
   - 기준일자 달력: `initFilterCalendar(pane, { onSelect: ... })` (수기 마크업 금지)
   - 상단 필터바 드롭다운: `initFilterDddw(pane, config)` 또는 `f_dddwctl.get2ColItemFormatter` (2열 커스텀 드롭다운)
   - **그리드 DDDW 수신**: 파워빌더 `ue_dddw_retrieve`를 `ue_dddw_retrieve(corpGr)`로 감싸고, 단일 DDDW는 `f_dddwctl(...)`, 복수 DDDW는 `f_dddwctl.retrieveMultiple({...})`로 수신한 뒤 `dddwOptionsMap`에 정규화한다. 회사그룹 변경 시 PB 원본에 조회 근거가 있을 때만 다시 호출한다 (`09-common-components-js.md` 2.5절 참조).
   - 스플리터: Tabulator 생성 이후 `AamsSplitter.init(pane)`를 화면당 한 번 호출한다 (`AamsSplitter.create` 호출 금지).
3. **Tabulator 그리드 빌드**:
   - 원클릭 편집 진입: `editTriggerEvent: "click"` 및 편집 셀 `cellClick: aamsCellEdit`
   - Zero-Inline-Style: `headerCssClass`, `cell-text-*`, 호가/시세 색상 동기화 (BID 빨강, ASK 파랑)
   - Zero-Count-Badge: 패널 헤더에 조회 건수 배지 절대 작성 금지
   - Zero-Row-Outline: 행 선택 시 커스텀 outline 금지
   - Summary 행: `{ isSummaryRow: true }` 데이터 행 패턴 (`.aams-summary-row` 연노랑)
   - [세부 표준: 04-tabulator-grid-basic.md, 05-tabulator-grid-events.md, 06-tabulator-grid-summary.md, 07-ui-styling-css.md]
4. **상단 공통 툴바 표준 계약 바인딩**:
   - `pane.onSearch`, `pane.onInput`, `pane.onSave`, `pane.onRefresh`, `pane.onCorpGrChange`, `pane.onExcel`
   - **조회 정책은 PB 동작 기준**: 필터/회사 변경 시 자동 조회를 금지하는 화면과 탭 진입 시 자동 조회하는 화면을 구분한다. 자동 조회 화면도 조회 대상은 활성 탭으로 제한한다.
   - **새로고침 범위 명시**: 단일 화면은 전체 초기화, 다중 탭 화면은 PB 동작에 따라 활성 탭 또는 전체 탭을 초기화한다. 이전 detail·가드 키를 남기지 않는다.
   - **작업일자 기준**: 서버의 `WorkDateService`/DB 작업일자를 기준으로 하고, 클라이언트 저장소를 사용할 때는 세션 범위와 회사그룹 변경 시 동기화를 명시한다.
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
| `workDate` | `String` | `workDateService.getWorkDateOrDefault(corpGr)` | DB 기준 작업일자 (`SZX0AA.HYUN_YMD` 우선, fallback은 화면별 명시) |
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
        <div class="split-pane pane-left" style="width: 50%;">
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
        <div class="split-pane pane-right" style="width: 50%;">
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
                            // PB 원본이 수동 조회인 화면은 여기서 조회하지 않는다.
                            // 자동 조회 화면은 활성 탭의 조회 진입점을 연결한다.
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

                    // PB가 새로고침 후 재조회하는 화면이면 활성 탭 조회만 호출한다.
                    if (typeof showToast === 'function') showToast("화면이 초기화되었습니다.", "info");
                };

                pane.onCorpGrChange = function (newCorpGr) {
                    // PB 원본이 자동 조회하지 않는 화면은 메타데이터만 갱신한다.
                    // 자동 조회 화면은 활성 탭의 조회 진입점을 연결한다.
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
| **08. 상단 공통 툴바 및 조회 정책** | 상단 공통 툴바 표준 계약, 최상위 MDI pane 획득, PB 기준 자동/수동 조회, 활성 탭 범위, 새로고침 범위, 필터 액션 버튼 인접 배치 | [08-toolbar-and-query-policy.md](file:///d:/work/java_aams_html_ver/.agents/rules/08-toolbar-and-query-policy.md) |
| **09. 공통 컴포넌트 & 프론트엔드 JS 표준** | dw_c 기반 필터 프래그먼트(`dc_ymd`), 달력(`initFilterCalendar`, 수기마크업 금지), DDDW 드롭다운(`initFilterDddw`, `f_dddwctl`), 서버 작업일자와 세션 스토리지 동기화 | [09-common-components-js.md](file:///d:/work/java_aams_html_ver/.agents/rules/09-common-components-js.md) |
| **10. MDI 탭 및 스플리터 분할 레이아웃** | MDI 단일 진입점 초기화(`startInit`), `AamsSplitter.init` 단일 진입점(`create` 호출 금지), srw 상속 및 중첩 분할(Nested Split), 컨테이너 높이 | [10-layout-and-splitter.md](file:///d:/work/java_aams_html_ver/.agents/rules/10-layout-and-splitter.md) |
| **11. 반응형 레이아웃 및 모바일 UX 표준** | 2대 브레이크포인트(1415px, 876px), 모바일 세로 순차 스택(`layout-mobile-stack`), 복합 그리드 최소 높이 290px(Zero-Squished-Grid), 모바일 탭 네비게이션 | [11-responsive-mobile.md](file:///d:/work/java_aams_html_ver/.agents/rules/11-responsive-mobile.md) |
| **12. MRD 리포트 뷰어 표준 가이드** | Crownix Report 아키텍처, 백엔드 공통 RD API, 공통 리포트 프래그먼트, `AamsReport.bindViewer` 일체형 엔진 바인딩, 5종 포맷 내보내기, 상단 공통 [엑셀] 연동 | [12-report-viewer.md](file:///d:/work/java_aams_html_ver/.agents/rules/12-report-viewer.md) |
| **📖 전체 화면 카탈로그 색인** | **대메뉴 > 소분류 > 화면번호(`PGM_NO`), 화면이름(`PGM_NM`), 파일명(`PGM_ID`), 파워빌더 소스(.srw) 및 웹 도메인/뷰 253개 전수 매핑** | [AAMS_SCREEN_CATALOG.md](file:///d:/work/java_aams_html_ver/AAMS_SCREEN_CATALOG.md) |
