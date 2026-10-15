---
trigger: always_on
---

# 01. 백엔드 아키텍처 및 영속성 계층 개발 표준 가이드

본 문서는 Spring Boot, Spring Data JPA, QueryDSL, MyBatis 기반 백엔드 아키텍처 및 데이터베이스 영속성 계층 개발 시 반드시 준수해야 하는 표준 규격입니다.

---

## 1. 전역 기본 원칙 (Zero-Hardcoding & Zero-Default)

1. **회사그룹(corp_gr) 및 주요 변수 기본값 fallback 절대 금지**:
   - `corp_gr`이나 다른 조회 조건 변수에 대해 코드 내에서 `'2402'`, `'1'`, `''` 등의 기본값(fallback)을 임의로 하드코딩하거나 삼항 연산자로 주지 않는다.
   - 요청 파라미터로 넘어온 값만을 신뢰하여 바인딩하며, 필수 파라미터 누락 시 명시적으로 예외를 던지거나 클라이언트에서 입력하도록 유도한다.
2. **하드코딩 배제**:
   - 업무 로직, 코드값, 경로, API URL 등은 하드코딩을 배제하고 설정 파일, 공통 코드 테이블, srd 메타데이터를 따른다.

---

## 2. 영속성 계층 구현 표준 (단일 테이블 JPA vs 복합 테이블 MyBatis 분기)

1. **단일 테이블 단순 조회 및 CUD(등록/수정/삭제) -> Spring Data JPA / EntityManager**:
   - **엔티티 구성**: 단일 테이블은 `@Entity` 클래스로 정의하며, 복합 기본키 테이블은 `@IdClass` 또는 `@EmbeddedId`를 적용한다.
   - **단일 테이블 단순 조회**: Spring Data JPA의 리포지토리 메서드(`findById`, `findByCorpGrAndYmd` 등) 또는 JPA `em.find(Entity.class, id)`를 사용한다. 동적 검색 조건이 필요한 경우 `JPAQueryFactory` (QueryDSL)를 활용한다.
   - **CUD(등록/수정/삭제) 표준 패턴**:
     - **등록 (Create)**: 엔티티 객체 생성 후 `em.persist(entity)` 또는 `repository.save(entity)` 호출.
     - **수정 (Update)**: `@Transactional` 컨텍스트 내에서 `em.find(Entity.class, id)`로 조회 후 필드 수정에 의한 Dirty Checking(더티 체킹) 자동 반영, 또는 `em.merge(entity)`.
     - **삭제 (Delete)**: `em.find(Entity.class, id)` 후 `em.remove(entity)` 호출, 또는 `repository.deleteById(id)`. 조건 기반 벌크 삭제가 필요한 경우 QueryDSL `delete(q).where(...).execute()`를 사용한다.
   - **구현 예시**:
     ```java
     // 1) 등록 (Create)
     public void insertDetail(Scm1pgDetailDto dto) {
         Scm1pg entity = Scm1pg.builder()
                 .corpGr(dto.getCorpGr())
                 .ymd(dto.getYmd())
                 .jmCd(dto.getJmCd())
                 .pgCd(dto.getPgCd())
                 .build();
         em.persist(entity);
     }

     // 2) 수정 (Update - Dirty Checking)
     public int updateDetail(Scm1pgDetailDto dto) {
         Scm1pgId id = new Scm1pgId(dto.getCorpGr(), dto.getYmd(), dto.getJmCd());
         Scm1pg entity = em.find(Scm1pg.class, id);
         if (entity != null) {
             entity.setPgCd(dto.getPgCd()); // 변경 감지(Dirty Checking)로 커밋 시 자동 UPDATE
             return 1;
         }
         return 0;
     }

     // 3) 삭제 (Delete)
     public void deleteDetail(String corpGr, String jmCd, LocalDate ymd) {
         Scm1pgId id = new Scm1pgId(corpGr, ymd, jmCd);
         Scm1pg entity = em.find(Scm1pg.class, id);
         if (entity != null) {
             em.remove(entity);
         }
     }
     ```
2. **2개 이상의 테이블 조인, 복합 함수, 프로시저 -> MyBatis**:
   - 2개 이상의 테이블 JOIN(`SZT0IA_V`, `SZM0IA`, `USPM_OPT` 등), 집계 서브쿼리, 오라클 특화 함수가 사용되는 경우 반드시 MyBatis XML 매퍼로 작성한다. (상세는 [03-oracle-mybatis-sql.md](file:///d:/work/java_aams_html_ver/.agents/rules/03-oracle-mybatis-sql.md) 참조)

---

## 3. 동일 테이블 다화면 CUD 재사용 및 점진적 엔티티 확장 표준 (Single-Entity & Multi-Screen DTO)

1. **엔티티 및 리포지토리 단일화 원칙 (Single Entity & Single Repository)**:
   - 동일한 단일 테이블 `B`에 대해 A화면에서 먼저 Entity/Repository를 생성하고, 이후 C화면에서 B테이블의 일부 또는 추가 컬럼을 CRUD해야 하는 경우, **B 테이블에 대한 Entity와 Repository는 중복 생성하지 않고 단 하나만 공통으로 재사용**한다.
   - C화면에서 새롭게 필요로 하는 컬럼은 기존 `B` 엔티티 클래스에 누적하여 추가 정의한다.
2. **화면별 DTO 분리 원칙 (Screen-Scoped DTOs)**:
   - 엔티티는 모든 컬럼을 수용하는 단일 테이블 완전체 모델로 유지하되, 클라이언트와의 입출력은 각 화면별 전용 DTO(`AScreenDto`, `CScreenDto` 등)로 철저히 분리한다. (상세는 [02-dto-and-models.md](file:///d:/work/java_aams_html_ver/.agents/rules/02-dto-and-models.md) 참조)
3. **더티 체킹(Dirty Checking) 기반 부분 수정 필수 (Zero-Null-Overwrite)**:
   - C화면에서 수정(Update) 시 엔티티를 임의로 새로 생성하여 `em.merge()`나 `save()`를 호출하면 C화면에서 다루지 않는 A화면 전용 컬럼들이 `null`로 덮어씌워지는 치명적 데이터 왜곡이 발생할 수 있다.
   - 따라서 반드시 `@Transactional` 컨텍스트 내에서 `em.find(Entity.class, id)` 또는 `repository.findById(id)`로 영속성 컨텍스트에 엔티티를 로드한 후, **해당 화면에서 수정한 필드만 setter(또는 비즈니스 변경 메서드)로 변경하여 더티 체킹에 의해 변경 필드만 안전하게 자동 UPDATE**되도록 구현한다:
     ```java
     @Transactional
     public int updateFromScreenC(CScreenDto dto) {
         B entity = em.find(B.class, dto.getId());
         if (entity != null) {
             // C 화면에서 다루는 컬럼만 선택적으로 변경 (기존 A화면 컬럼값 온전 보존)
             entity.setColForC1(dto.getColForC1());
             entity.setColForC2(dto.getColForC2());
             return 1;
         }
         return 0;
     }
     ```

---

## 4. 컨트롤러 및 REST API 표준

1. **URI 설계 규칙**:
   - 뷰 렌더링: `GET /views/{domain}/{viewName}` (예: `/views/usportfoliomodel/w_ja032a`)
   - API 데이터 조회: `GET /api/{domain}/{screenId}/{resource}` (예: `/api/usportfoliomodel/ja032a/master`)
   - API 데이터 저장: `POST /api/{domain}/{screenId}/save`
2. **응답 규격 (JSON)**:
   - 목록 조회: `List<T>` JSON 배열 직접 반환
   - 단일 CUD 처리: 표준 Response Map 반환:
     ```java
     Map<String, Object> result = new HashMap<>();
     result.put("success", true);
     result.put("message", "정상적으로 저장되었습니다.");
     return ResponseEntity.ok(result);
     ```
