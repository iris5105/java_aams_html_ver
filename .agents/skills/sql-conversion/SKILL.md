---
name: sql-conversion
description: PowerBuilder DataWindow(.srd) 및 PowerScript 내 Embedded SQL / Stored Procedure를 Oracle 19c 호환 MyBatis XML 쿼리로 변환할 때 사용하는 기술 가이드
---

# SQL 변환 스킬 (PowerBuilder SQL -> Oracle 19c & MyBatis XML)

PowerBuilder `.srd` / `.srw`의 SQL 및 프로시저 호출을 `.agents/rules/03-oracle-mybatis-sql.md` 표준에 맞춰 안전하게 MyBatis XML로 변환하는 절차입니다.

---

## 1. 원본 SQL 보존 및 변수 바인딩

1. **원본 비즈니스 로직 100% 보존**
   - `.srd`의 `SELECT`, `FROM`, `JOIN`, `WHERE`, `GROUP BY`, `ORDER BY` 구조와 별칭을 임의로 축소/변경하지 않는다.
2. **PowerBuilder 바인드 변수 치환**
   - `:as_corp_gr`, `:adt_ymd`, `:as_fund_cd` 등 PowerBuilder 바인드 변수를 MyBatis `#{corpGr}`, `#{ymd}`, `#{fundCd}`로 치환한다.
   - SQL Injection 방지를 위해 `${...}` 문자열 치환은 절대 사용하지 않는다.
3. **명칭 컬럼(`xx_`) 별칭 매핑**
   - `SELECT` 절에서 `ia.FUND_NM AS xx_fund_cd`와 같이 `xx_` snake_case 별칭을 명시하여 DTO의 `xxFundCd`와 자동 매핑되게 한다.

---

## 2. Oracle 19c 필수 방어 패턴

1. **`NULLIF` 데이터 타입 일치 (`ORA-00932` 방어)**
   - `SUBSTR(...)` 등 문자열 결과를 숫자 `0`과 비교할 때는 반드시 `TO_NUMBER(...)`로 감싼다:
     ```sql
     -- 잘못된 예 (ORA-00932 발생)
     NULLIF(SUBSTR(t1.JM_CD, LENGTH(#{jmCd})), 0)

     -- 올바른 예
     NULLIF(TO_NUMBER(SUBSTR(t1.JM_CD, LENGTH(#{jmCd}))), 0)
     ```
2. **나눗셈 제수 0 방어 (`ORA-01476` 방어)**
   - 분모가 0이 될 가능성이 있는 나눗셈에는 반드시 `NULLIF(분모, 0)`를 적용한다:
     ```sql
     ROUND((t1.AMT / NULLIF(#{baseAmt}, 0)) * 100, 2) AS ratio
     ```
3. **날짜 형식 통일**
   - 화면 표시/DTO 전달용 날짜는 `TO_CHAR(t1.TR_YMD, 'YYYY-MM-DD')` 또는 원본 포맷을 유지하고, 비교 조건의 타입(`DATE` vs `VARCHAR2`)이 테이블 스키마와 일치하는지 확인한다.

---

## 3. MyBatis Result Mapping & XML 포맷팅

1. **기본은 `resultType` 사용**
   - `map-underscore-to-camel-case=true`가 활성화되어 있으므로 단순 1:1 플랫 DTO 조회에는 `resultMap` 대신 `resultType`을 사용한다.
   - `resultMap`은 `association`/`collection`, Oracle `REF_CURSOR` OUT 파라미터, 1컬럼 다중 프로퍼티 매핑, 중복 컬럼명 해소 등 예외적인 경우에만 사용한다.
2. **프로시저(`CALLABLE`) 호출 규격**
   ```xml
   <select id="callProcedure" statementType="CALLABLE">
       { CALL SP_NAME(
           #{corpGr, mode=IN, jdbcType=VARCHAR},
           #{ymd, mode=IN, jdbcType=VARCHAR},
           #{retCode, mode=OUT, jdbcType=VARCHAR},
           #{retMsg, mode=OUT, jdbcType=VARCHAR}
       ) }
   </select>
   ```
3. **줄바꿈 및 정렬 표준**
   - `<select>`, `<resultMap>`, `<result>`는 각각 한 줄에 작성한다.
   - `SELECT` 컬럼은 한 줄에 하나씩 작성하며 둘째 컬럼부터 쉼표(`,`)를 줄 앞에 정렬한다.
   - `FROM`, `JOIN`, `ON`, `WHERE`, `AND`, `ORDER BY`는 모두 줄을 분리한다.
