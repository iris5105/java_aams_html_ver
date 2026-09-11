# AAMS 웹 시스템 인수인계 및 기술 레퍼런스 가이드

본 문서는 **AAMS(자산관리시스템)의 파워빌더 레거시 시스템을 Spring Boot 및 HTML5/JavaScript 기반 웹 표준 아키텍처로 전환한 프로젝트**의 시스템 유지보수 및 인수인계를 위한 통합 기술 문서입니다.

---

## 1. 시스템 아키텍처 개요

- **백엔드**: Java 21, Spring Boot 3.x, Spring Security (JWT 쿠키 인증), MyBatis 3.x, QueryDSL, Crownix Report Engine (독립 ClassLoader 격리 구동)
- **프론트엔드**: HTML5, Vanilla JavaScript, CSS3 (반응형 모바일 지원), Tabulator.js (데이터 그리드), AAMS Custom Calendar (순수 JS 달력), FontAwesome
- **화면 구조**: 다중 문서 인터페이스(MDI) 탭 컨테이너 구조 (`tab_manager.js`), 상단 공통 툴바 및 필터 프래그먼트

---

## 2. 인수인계 문서 목차

### Part 1. 공통 핵심 모듈 작동 방식 및 설정 가이드 (`docs/01_common_modules/`)

1. **[01. 공통 유틸리티 및 레포트 뷰어 규격 (`common.js`, `AamsReport`)](./01_common_modules/01_common_utility_and_report.md)**
   - `AamsReport` 유틸리티를 통한 기본 120% 확대 비율 제어 (`DEFAULT_ZOOM = 120`)
   - PDF Open Parameters (`#toolbar=1&navpanes=0&zoom=120`) 브라우저 연동
   - 그리드 행 선택 삼중 안전망 (`setupTabulatorRowSelection`, `rowClick`, `rowSelectionChanged`)
   - MDI 탭 다중 초기화 방지 패턴 (`startInit`, `isInitialized`)

2. **[02. 달력 컴포넌트 모듈 (`aams_calendar.js`)](./01_common_modules/02_calendar_module.md)**
   - 순수 바닐라 JS 달력 컴포넌트 아키텍처
   - 단일 날짜(Simple), 기간 선택(Range), 영업일 하이라이트(Highlight) 3대 동작 모드
   - MDI 탭 패널 격리(`options.pane`) 및 input 객체 자동 정규화, `input`/`change` 이벤트 디스패치
   - 회사별 기준일자(`SZX0AA.JUNYONG_YMD`, `HYUN_YMD`) 연동 및 변경 자동화

3. **[03. 드롭다운 선택 모듈 (`f_dddwctl.js`, `DddwService`)](./01_common_modules/03_dddw_dropdown_module.md)**
   - 파워빌더 `f_dddwctl` 완벽 호환 2칸 분할 드롭다운 (앞: 코드, 뒤: 코드명)
   - 선택 시 화면/버튼에는 코드명만 표출되는 표준 UX 규격
   - 코드 기준 자동 오름차순(ASC) 정렬 보장
   - HTML 네이티브 select와 커스텀 플로팅 드롭다운 간 양방향 동기화

4. **[04. 다이나믹 코드 검색 모달 (`dynamic_code_search.js`)](./01_common_modules/04_dynamic_code_search.md)**
   - 그리드 내 돋보기 버튼(`p_xx_` 컬럼) 다이나믹 검색 바인딩
   - 공통 검색 모달 팝업 및 키보드 네비게이션(Enter 선택, ESC 닫기)
   - 조회 데이터의 그리드 셀 자동 반영 및 변경 감지

5. **[05. Crownix RD 레포트 변환 엔진 (`RdReportService.java`)](./01_common_modules/05_rd_report_engine_backend.md)**
   - 프로젝트 내장 `lib/*.jar` 격리 구동을 위한 독립 `URLClassLoader` 아키텍처
   - 클래스패스 내장 MRD (`classpath:/rd/*.mrd`) 로컬 임시 캐싱
   - 5대 표준 포맷(PDF, Excel, Word, PPT, HWP) 바이너리 변환 및 브라우저 스트리밍
   - 회사코드(`corpGr`) 누락 방지를 위한 쿠키(`savedCorpGr`, `corpGr`) 및 SecurityContext 자동 추출 폴백 메커니즘

6. **[06. 인증 및 세션/쿠키 아키텍처 (`AuthController`, `JwtProvider`)](./01_common_modules/06_auth_and_session_cookie.md)**
   - JWT 기반 쿠키 인증 (`accessToken`, `refreshToken`)
   - 전역 회사 그룹(`savedCorpGr`) 및 기준 작업일자(`workDate`) 쿠키 관리
   - 관리자 전용 회사 전환 (`/api/auth/switch-company`) 및 즉각적인 토큰/쿠키 갱신

---

### Part 2. 화면별 데이터 조회 흐름 및 연동 아키텍처 (`docs/02_screens/`)

각 화면별로 **[HTML 화면 UI] → [클라이언트 JS] → [Spring Controller] → [Service] → [Mapper/QueryDSL] → [DB SQL]**로 이어지는 전체 데이터 흐름을 분석한 상세 명세서입니다:

1. **[w_ja020k : 일(종목)별 운용현황 (단일 리포트 뷰어 화면)](./02_screens/w_ja020k.md)**
   - 필터(기준일자, 자료구분 DDDW) 선택 → PDF 120% 줌 리포트 미리보기 및 멀티 포맷 내보내기
2. **[w_ja020k1 : 계좌별 주간 운용현황 (마스터 그리드 + 리포트 연동)](./02_screens/w_ja020k1.md)**
   - 계좌 목록 Tabulator 조회 → 행 선택 시 주간 운용현황 리포트 동적 로드
3. **[w_ja010h : 자산명세표 (마스터-디테일 분할 & 반응형 모바일 모달)](./02_screens/w_ja010h.md)**
   - 펀드 목록 조회 → 행 선택 삼중 안전망 → 우측 iframe 리포트 표출 (모바일 시 풀스크린 모달 팝업)
4. **[w_ja010h1 : 자산명세표 (펀드별 단일 리포트 연동)](./02_screens/w_ja010h1.md)**
   - 펀드 목록 그리드와 상세 리포트 뷰어 동기화 및 엑셀/PDF 내보내기
5. **[w_ja020n : 기준일자 공통 쿼리 연동 화면](./02_screens/w_ja020n.md)**
   - `CommonMapper.xml`의 `SZX0AA_YMD` 공통 쿼리 참조 구조 및 DTO 매핑
6. **[w_ja010g : 매매내역 조회 화면](./02_screens/w_ja010g.md)**
   - 매매일자 필터, 공통 쿼리 및 Tabulator 포맷터 연동
7. **[w_ja010q : 성과보수 상세내역 화면](./02_screens/w_ja010q.md)**
   - 해지일자/결산일자 조건 필터 및 성과보수 리포트 스트림 표출
8. **[w_ja010p1 : 채권/현금 만기현황 화면](./02_screens/w_ja010p1.md)**
   - 만기 기준일자 기반 만기현황 리포트 로드 및 뷰어 120% 줌 적용
9. **[w_ja010j : 공모청약 수요예측 참여표 화면](./02_screens/w_ja010j.md)**
   - 구간(시작일~종료일) 필터 및 펀드별 리포트 분기 생성
10. **[w_ja010m3 : 결산보고서 조회 및 미리보기 화면](./02_screens/w_ja010m3.md)**
    - 결산 목록 그리드와 하단 결산보고서 PDF iframe 연계 및 새 창 열기

---

## 3. 개발 및 유지보수 10대 핵심 규칙 (Cheat Sheet)

1. **회사코드(`corp_gr`) 하드코딩 금지**: 반드시 쿠키(`savedCorpGr`) 또는 세션에서 추출하여 사용.
2. **단일 테이블 단순 조회는 QueryDSL, 복수 테이블 조인은 MyBatis XML** 사용.
3. **그리드 행 선택 표준 규격**: `setupTabulatorRowSelection` + `rowClick` + `rowSelectionChanged` 삼중 안전망 필수 적용.
4. **중복 API 호출 방지**: 행 클릭 시 `lastLoadedMasterKey === currentKey` 검증 가드 필수.
5. **MDI 동적 로딩 중복 방지**: `isInitialized` 플래그 및 단일 진입점 `startInit` 함수 사용.
6. **DDDW 드롭다운 2칸 분할 규격**: `f_dddwctl`은 앞 코드, 뒤 코드명 분할 및 선택 시 코드명만 표출.
7. **달력 모드 자동 분기**: `dw_c`에 범위일자가 있으면 Range 모드, `ue_getdate`가 있으면 Highlight 모드.
8. **리포트 뷰어 확대 배율**: `AamsReport.formatPreviewUrl(url)`을 통해 기본 120% (`#zoom=120`) 강제 적용.
9. **반응형 브레이크포인트**: 1415px(태블릿-L), 876px(태블릿-S/모바일 - 리포트 패널 숨김 및 모달 전환).
10. **상단 툴바 표준 계약**: 개별 액션 버튼 대신 상단 툴바 프래그먼트와 `pane.onSearch`, `pane.onRefresh`, `pane.onCorpGrChange` 바인딩.
