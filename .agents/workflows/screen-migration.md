---
description: PowerBuilder 화면(.srw/.srd)을 AAMS Spring Boot + Thymeleaf + Tabulator 웹 화면으로 전환하는 표준 작업 절차
---

# 화면 마이그레이션 표준 워크플로우 (Screen Migration)

PowerBuilder 레거시 화면을 AAMS 차세대 웹 화면으로 전환할 때 아래 단계를 순서대로 수행합니다.

## Phase 1. 레거시 분석 (Analysis)
`powerbuilder-analyzer` 관점 및 `datawindow-migration` 스킬을 참고하여 원본을 분석합니다.
1. 대상 `.srw`(창) 및 연결된 `.srd`(DataWindow) 파일을 확인합니다.
2. 상단 필터 조건, 초기 조회 여부(`open` / `ue_*`), 툴바 이벤트(`ue_retrieve`, `ue_insert`, `ue_save`, `ue_delete`, `ue_excel`)를 정리합니다.
3. 마스터-디테일 연동 키, Summary 밴드 집계식, DDDW/코드검색 팝업, MRD 리포트 여부를 파악합니다.

## Phase 2. 백엔드 및 SQL 구현 (Backend & SQL)
`01-backend-standard.md`, `02-dto-and-models.md`, `03-oracle-mybatis-sql.md` 및 `crud-generation` / `sql-conversion` 스킬을 적용합니다.
1. **DTO 작성**: 화면 전용 DTO 생성 (`xx_` 양방향 프로퍼티, CUD 상태 필드 포함).
2. **영속성 계층**:
   - 단일 테이블 단순 조회/CUD -> 기존 `@Entity`·`@Repository` 재사용 및 Dirty Checking 기반 서비스 구현 (레거시 테이블명 `@Table(name = "\"...\"")` 확인).
   - 복합 JOIN/함수/프로시저 -> MyBatis XML 매퍼 작성 (`NULLIF` 타입 일치, 제수 0 방어, 줄바꿈 표준 준수).
3. **Controller 작성**:
   - `GET /views/{domain}/{viewName}`: `WorkDateService.getWorkDateOrDefault(corpGr)`로 기준 작업일자 주입.
   - `GET /api/{domain}/{screenId}/...`, `POST /api/{domain}/{screenId}/save` 엔드포인트 구현.

## Phase 3. 프론트엔드 화면 구현 (Frontend)
`04~13` 규칙 및 `datawindow-migration` 스킬을 적용합니다.
1. **Thymeleaf (`templates/views/{domain}/w_*.html`)**:
   - 최상위 `.view-container.layout-mobile-stack-container` 구성.
   - 상단 필터는 `fragments/filter/*` 재사용, 필터 인접 버튼은 `.filter-left` 내 배치.
   - 리포트 뷰어 필요 시 `fragments/report/report_viewer` 사용.
   - 그리드 헤더에 건수 배지(`<span class="badge">0건</span>`) 추가 금지.
2. **JavaScript**:
   - `document.currentScript.closest('.tab-pane')`로 `pane` 획득.
   - `new Tabulator(...)`에 `layout: "fitDataFill"`, `editTriggerEvent: "click"`, `cellClick: aamsCellEdit` 적용.
   - `field: "fundCd"` 헤더 `title`은 `"펀드번호"`로 고정.
   - `pane.onSearch`, `pane.onInput`, `pane.onSave`, `pane.onRefresh` 등 표준 툴바 계약 바인딩 (`onRefresh` 시 상태 키 초기화).
   - 리포트가 있는 경우 모바일(`width <= 876px`)에서 자동 첫 행 선택을 방지하고 클릭 시 모달 오픈.

## Phase 4. 코드·보안 검증 및 빌드 확인 (Review & Verification)
1. `code-reviewer` 관점으로 PowerBuilder 원본과 비즈니스 로직·집계·NULL 처리·트랜잭션 일치 여부를 대조합니다.
2. `security-auditor` 관점으로 `corpGr` fallback 여부, 서버 인가 인터셉터/어노테이션, MyBatis `#{}` 바인딩을 점검합니다.
3. 컴파일 및 관련 테스트를 실행해 오류 없이 통과하는지 확인한 뒤 변경 파일과 검증 결과를 보고합니다.
