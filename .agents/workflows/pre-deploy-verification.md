---
description: 변경된 화면 및 API를 배포하기 전 수행해야 하는 아키텍처, 보안, SQL, UI 정합성 최종 검증 절차
---

# 배포 전 검증 표준 워크플로우 (Pre-Deployment Verification)

기능 구현 또는 마이그레이션 완료 후 배포 전 품질과 보안을 보증하기 위한 필수 점검 절차입니다.

## Step 1. 빌드 및 테스트 실행
1. Maven 컴파일 및 테스트를 실행하여 문법·의존성·QueryDSL Q-class 생성·단위 테스트 오류가 없는지 확인합니다.
   ```powershell
   .\mvnw.cmd test-compile
   ```
   (필요 시 특정 테스트 클래스 또는 전체 테스트 실행)

## Step 2. 백엔드 및 보안 점검 (`security-auditor` 기준)
1. **Zero-Default / Zero-Hardcoding**: `corpGr`, `ymd` 등에 `'2402'`, `'1'`, `LocalDate.now()` 등의 임의 fallback이 없는지 확인합니다.
2. **서버 인가 검증**: 신규/수정된 API가 `CompanyGroupAuthorizationInterceptor`, `ProgramActionAuthorizationInterceptor` 등 서버 측 인가 흐름을 우회하지 않는지 확인합니다.
3. **JPA 엔티티 테이블명**: 축약 레거시 테이블명에 `@Table(name = "\"...\"")` 쌍따옴표 인용이 적용되어 있는지 확인합니다.
4. **SQL Injection & 민감정보**: MyBatis `${...}` 사용 여부 및 로그 내 토큰·비밀번호 노출 여부를 점검합니다.

## Step 3. Oracle 19c SQL 점검 (`oracle-sql-expert` 기준)
1. `NULLIF(SUBSTR(...), 0)` 등 `ORA-00932` 유발 가능 구문이 `TO_NUMBER(...)`로 타입 일치되었는지 확인합니다.
2. 나눗셈 연산 분모에 `NULLIF(..., 0)` (`ORA-01476` 방어)가 적용되었는지 확인합니다.
3. 프로시저 호출(`statementType="CALLABLE"`) 시 IN/OUT 파라미터 및 `jdbcType`이 정확한지 확인합니다.

## Step 4. UI / Tabulator / 반응형 점검 (`code-reviewer` 기준)
1. **Tabulator 표준**:
   - 모든 그리드에 `layout: "fitDataFill"`이 적용되었는지 확인합니다.
   - `fundCd` 컬럼 `title`이 `"펀드번호"`인지 확인합니다.
   - 조회 건수 배지 및 행 `outline`이 없는지 확인합니다.
   - Summary 행이 있는 경우 `isSummaryRow`가 저장 페이로드와 마스터-디테일 연동에서 제외되는지 확인합니다.
2. **MDI 툴바 및 상태 초기화**:
   - `document.currentScript.closest('.tab-pane')` 스코핑을 사용하는지 확인합니다.
   - `onRefresh` 시 `lastLoadedMasterKey` 등 가드 변수가 초기화되는지 확인합니다.
3. **반응형/모바일**:
   - `.layout-mobile-stack-container` 적용 여부 및 `width <= 876px` 환경에서 그리드 찌그러짐(최소 높이 290px)이나 자동 모달 팝업 오작동이 없는지 확인합니다.
