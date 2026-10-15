---
trigger: always_on
---

# 03. Oracle & MyBatis SQL 개발 표준 가이드

본 문서는 AAMS 시스템의 복합 조인 쿼리, 오라클 특화 함수 및 프로시저(Stored Procedure) 개발 시 MyBatis XML 매퍼에서 반드시 준수해야 하는 표준 규격입니다.

---

## 1. MyBatis 적용 기준 및 복합 조인 보존

1. **적용 대상**:
   - 2개 이상의 테이블 JOIN(`SZT0IA_V`, `SZM0IA`, `USPM_OPT` 등), 집계 서브쿼리, 오라클 특화 함수(`NVL`, `DECODE`, `TO_CHAR` 등)가 사용되는 경우 반드시 MyBatis XML 매퍼로 작성한다.
2. **원본 로직 100% 보존**:
   - 파워빌더 `.srd` 파일의 DataWindow SQL 쿼리문을 그대로 가져와서 변수 바인딩 부분만 `#{corpGr}`, `#{ymd}` 등으로 치환하여 비즈니스 로직을 온전히 유지한다.
3. **명칭 컬럼 별칭 매핑**:
   - `SELECT` 절에서 `xx_` 컬럼 별칭을 명시적으로 매핑하여 DTO와 1:1 일치시킨다:
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

## 2. 오라클 데이터 타입 일치 표준 (Zero-Type-Mismatch & ORA-00932 방어)

1. **`NULLIF(expr1, expr2)` 두 인자의 데이터 타입 일치 보장**:
   - 오라클의 `NULLIF(a, b)` 함수는 **두 인자의 데이터형이 완전히 동일**해야 한다.
   - `SUBSTR(...)` 등 문자열 연산 결과와 숫자 리터럴 `0`을 비교할 때 `NULLIF(SUBSTR(...), 0)` 형태로 작성하면 `ORA-00932: 일관성 없는 데이터 유형: CHAR이(가) 필요하지만 NUMBER임` 오류가 발생한다.
   - 분모 0 방어나 조건문에서 문자열 연산 결과를 비교할 때는 반드시 `TO_NUMBER()`로 형변환을 일치시킨다:
     ```xml
     <!-- 금지 (ORA-00932 발생): CHAR와 NUMBER 불일치 -->
     TRUNC(t1.BID / NULLIF(SUBSTR(t1.JM_CD, LENGTH(#{jmCd})), 0), 4) * 100

     <!-- 올바른 표준: TO_NUMBER로 둘 다 NUMBER 타입으로 일치 -->
     TRUNC(t1.BID / NULLIF(TO_NUMBER(SUBSTR(t1.JM_CD, LENGTH(#{jmCd}))), 0), 4) * 100
     ```

---

## 3. 나눗셈 연산 시 제수(Divisor) 0 방어 표준 (ORA-01476 방어)

나눗셈 연산(`/`)의 분모 변수가 `0`일 가능성이 있는 경우 반드시 `NULLIF(#{divisor}, 0)`를 사용하여 `ORA-01476: 제수가 0입니다`를 사전에 차단한다:

```xml
<!-- 안전한 나눗셈 및 퍼센트 계산 표준 -->
ROUND((TO_NUMBER(SUBSTR(t1.JM_CD, LENGTH(#{jmCd}))) / NULLIF(#{jonga}, 0) - 1) * 100, 2) AS per
```

---

## 4. 오라클 프로시저(SP) 호출 규격

MyBatis `statementType="CALLABLE"` 매핑 또는 JDBC CallableStatement를 사용하여 프로시저의 IN/OUT 파라미터를 정확히 바인딩한다:

```xml
<select id="callCalcProcedure" statementType="CALLABLE">
    { CALL SP_CALC_DAILY_DATA(
        #{corpGr, mode=IN, jdbcType=VARCHAR},
        #{ymd, mode=IN, jdbcType=VARCHAR},
        #{retCode, mode=OUT, jdbcType=VARCHAR},
        #{retMsg, mode=OUT, jdbcType=VARCHAR}
    ) }
</select>
```
