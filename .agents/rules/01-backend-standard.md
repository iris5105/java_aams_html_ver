---
trigger: always_on
---

# AAMS 백엔드 및 데이터 계층 개발 표준 가이드

본 문서는 Spring Boot, MyBatis, QueryDSL, JPA 기반 백엔드 아키텍처 및 데이터베이스 연동 개발 시 반드시 준수해야 하는 표준 규격입니다.

---

## 1. 전역 기본 원칙 (Zero-Hardcoding & Zero-Default)

1. **회사그룹(corp_gr) 및 주요 변수 기본값 fallback 절대 금지**:
   - `corp_gr`이나 다른 조회 조건 변수에 대해 코드 내에서 `'2402'`, `'1'`, `''` 등의 기본값(fallback)을 임의로 하드코딩하거나 삼항 연산자로 주지 않는다.
   - 요청 파라미터로 넘어온 값만을 신뢰하여 바인딩하며, 필수 파라미터 누락 시 명시적으로 예외를 던지거나 클라이언트에서 입력하도록 유도한다.
2. **하드코딩 배제**:
   - 업무 로직, 코드값, 경로, API URL 등은 하드코딩을 배제하고 설정 파일, 공통 코드 테이블, srd 메타데이터를 따른다.

---

## 2. DTO 및 데이터 모델링 규격

1. **srd 파일 기반 1:1 DTO 생성**:
   - 파워빌더 `.srd` 파일의 DataWindow SQL 쿼리문 및 컬럼 정의(`table(column=...)`)를 기준으로 DTO를 구성한다.
   - 컬럼 데이터형 매핑:
     - `char(N)`, `varchar(N)` -> `String`
     - `number`, `decimal` -> `BigDecimal` (정수형 명확한 경우 `Long` 또는 `Integer`)
     - `datetime`, `date` -> `String` (`YYYY-MM-DD` 문자열) 또는 `LocalDate`
   - **`xx_` 컬럼(코드명 컬럼) 명명 규칙**:
     - `.srd`의 `xx_fund_cd` -> DTO 필드명 `xxFundCd`
     - `.srd`의 `xx_yj_cd` -> DTO 필드명 `xxYjCd`
     - `.srd`의 `xx_koscom_cd` -> DTO 필드명 `xxKoscomCd`
     - 기존 명칭 프로퍼티(`fundNm`, `jmNm` 등)와의 호환성이 필요한 경우 양방향 getter/setter를 구성하여 직렬화/역직렬화 누락을 원천 방지한다:
       ```java
       private String xxFundCd;
       private String fundNm;

       public String getXxFundCd() {
           return xxFundCd != null ? xxFundCd : fundNm;
       }
       public void setXxFundCd(String xxFundCd) {
           this.xxFundCd = xxFundCd;
           if (this.fundNm == null) this.fundNm = xxFundCd;
       }
       public String getFundNm() {
           return fundNm != null ? fundNm : xxFundCd;
       }
       public void setFundNm(String fundNm) {
           this.fundNm = fundNm;
           if (this.xxFundCd == null) this.xxFundCd = fundNm;
       }
       ```
2. **CUD 상태 관리 필드 포함**:
   - 그리드 일괄 저장을 위한 CUD 플래그를 DTO에 포함한다:
     ```java
     private Boolean isNew;
     private Boolean isUpdated;
     private Boolean isDeleted;
     private String rowStatus; // C: 등록, U: 수정, D: 삭제
     ```

---

## 3. 영속성 계층 구현 표준 (JPA / QueryDSL vs MyBatis 분기)

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
   - srd 원본 SQL과 같이 2개 이상의 테이블 JOIN(`SZT0IA_V`, `SZM0IA`, `USPM_OPT` 등), 집계 서브쿼리, 오라클 특화 함수(`NVL`, `DECODE`, `TO_CHAR` 등)가 사용되는 경우 반드시 MyBatis XML 매퍼로 작성한다.
   - srd 파일의 쿼리문을 그대로 가져와서 변수 바인딩 부분만 `#{corpGr}`, `#{ymd}` 등으로 치환하여 원본 쿼리 로직을 100% 보존한다.
   - `SELECT` 절에서 `xx_` 컬럼 별칭을 명시적으로 매핑한다:
     ```xml
     SELECT t1.CORP_GR                       AS corp_gr
          , t1.FUND_CD                       AS fund_cd
          , ia.FUND_NM                       AS xx_fund_cd
          , ia.FUND_NM                       AS fund_nm
          , TO_CHAR(t1.TR_YMD, 'YYYY-MM-DD') AS tr_ymd
       FROM SZT0IA_V t1
          , SZM0IA   ia
      WHERE t1.CORP_GR = #{corpGr}
        AND t1.TR_YMD  = #{ymd}
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
3. **오라클 프로시저(SP) 호출 규격**:
   - MyBatis `statementType="CALLABLE"` 매핑 또는 JDBC CallableStatement를 사용하여 프로시저의 IN/OUT 파라미터를 정확히 바인딩한다.

---

## 5. MyBatis SQL 작성 시 오라클 데이터 타입 일치 표준 (Zero-Type-Mismatch & ORA-00932 방어)

1. **`NULLIF(expr1, expr2)` 두 인자의 데이터 타입 일치 보장 (ORA-00932 원천 방지)**:
   - 오라클의 `NULLIF(a, b)` 함수는 **두 인자의 데이터형이 완전히 동일**해야 한다.
   - `SUBSTR(...)` 등 문자열 연산 결과와 숫자 리터럴 `0`을 비교할 때 `NULLIF(SUBSTR(...), 0)` 형태로 작성하면 `ORA-00932: 일관성 없는 데이터 유형: CHAR이(가) 필요하지만 NUMBER임` 오류가 발생한다.
   - 분모 0 방어나 조건문에서 문자열 연산 결과를 비교할 때는 반드시 `TO_NUMBER()`로 형변환을 일치시킨다:
     ```xml
     <!-- 금지 (ORA-00932 발생): CHAR와 NUMBER 불일치 -->
     TRUNC(t1.BID / NULLIF(SUBSTR(t1.JM_CD, LENGTH(#{jmCd})), 0), 4) * 100

     <!-- 올바른 표준: TO_NUMBER로 둘 다 NUMBER 타입으로 일치 -->
     TRUNC(t1.BID / NULLIF(TO_NUMBER(SUBSTR(t1.JM_CD, LENGTH(#{jmCd}))), 0), 4) * 100
     ```
2. **나눗셈 연산 시 제수(Divisor) 0 방어 표준 패턴**:
   - 나눗셈 연산(`/`)의 분모 변수가 `0`일 가능성이 있는 경우 반드시 `NULLIF(#{divisor}, 0)`를 사용하여 `ORA-01476: 제수가 0입니다`를 사전에 차단한다:
     ```xml
     <!-- 안전한 나눗셈 및 퍼센트 계산 표준 -->
     ROUND((TO_NUMBER(SUBSTR(t1.JM_CD, LENGTH(#{jmCd}))) / NULLIF(#{jonga}, 0) - 1) * 100, 2) AS per
     ```

