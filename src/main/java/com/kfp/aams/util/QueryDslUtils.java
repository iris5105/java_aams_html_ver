package com.kfp.aams.util;

import com.querydsl.core.types.Expression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.core.types.dsl.StringTemplate;

/**
 * QueryDSL 공통 DB 표현식 및 커스텀 함수 유틸리티 클래스
 */
public class QueryDslUtils {

    private QueryDslUtils() {
        // 유틸리티 클래스 인스턴스화 방지
    }

    /**
     * Oracle DB 커스텀 암호화 함수 KFP.TO_ENCRYPTS(input) 호출
     * 
     * @param value 암호화할 문자열 변수
     * @return Expressions.stringTemplate("function('TO_ENCRYPTS', {0})", value)
     */
    public static StringTemplate toEncrypts(String value) {
        if (value == null) {
            return null;
        }
        return Expressions.stringTemplate("function('TO_ENCRYPTS', {0})", value);
    }

    /**
     * Oracle DB 커스텀 암호화 함수 KFP.TO_ENCRYPTS(input) 호출 (Expression 타입용)
     */
    public static StringTemplate toEncrypts(Expression<String> expr) {
        if (expr == null) {
            return null;
        }
        return Expressions.stringTemplate("function('TO_ENCRYPTS', {0})", expr);
    }

    /**
     * Oracle DB 커스텀 복호화 함수 KFP.TO_DECRYPTS(input) 호출 (Expression 타입용)
     */
    public static StringTemplate toDecrypts(Expression<String> expr) {
        if (expr == null) {
            return null;
        }
        return Expressions.stringTemplate("function('TO_DECRYPTS', {0})", expr);
    }

    /**
     * Oracle NVL(TO_CHAR(expr, format), defaultValue) 템플릿
     */
    public static StringTemplate nvlToChar(Expression<?> expr, String format, String defaultValue) {
        return Expressions.stringTemplate("NVL(TO_CHAR({0}, '" + format + "'), '" + defaultValue + "')", expr);
    }

    /**
     * Oracle TO_CHAR(expr, format) 템플릿
     */
    public static StringTemplate toChar(Expression<?> expr, String format) {
        return Expressions.stringTemplate("TO_CHAR({0}, '" + format + "')", expr);
    }

    /**
     * Oracle NVL(expr, defaultValue) 템플릿
     */
    public static StringTemplate nvl(Expression<?> expr, String defaultValue) {
        return Expressions.stringTemplate("NVL({0}, '" + defaultValue + "')", expr);
    }

    /**
     * Oracle DB TRUNC(date, unit) + dayOffset 날짜 연산 템플릿
     * 
     * @param dateExpr  날짜 표현식 (Null 전달 시 sysdate 기본 적용)
     * @param unit      'mm' (월 단위 절삭 -> 해당 월 01일), 'dd' (일 단위 절삭 -> 해당 일자 자정)
     * @param dayOffset 일수 오프셋 (음수: 과거 일수 차감, 양수: 미래 일수 가산, 0: 기본)
     */
    public static StringTemplate truncDate(Expression<?> dateExpr, String unit, int dayOffset) {
        Expression<?> targetExpr = (dateExpr != null) ? dateExpr : Expressions.stringTemplate("sysdate");
        String cleanUnit = (unit != null) ? unit.trim().toLowerCase() : "";

        StringTemplate baseDate;
        if ("mm".equals(cleanUnit)) {
            // 'mm', 'MM' 등: trunc_month(?1) -> Oracle SQL: trunc(targetExpr, 'MM')
            baseDate = Expressions.stringTemplate("function('trunc_month', {0})", targetExpr);
        } else {
            // 'dd', 'DD', null 또는 기본값: trunc_day(?1) -> Oracle SQL: trunc(targetExpr)
            baseDate = Expressions.stringTemplate("function('trunc_day', {0})", targetExpr);
        }

        if (dayOffset == 0) {
            return baseDate;
        }

        // add_days(?1, ?2) -> Oracle SQL: (baseDate + dayOffset)
        return Expressions.stringTemplate("function('add_days', {0}, {1})", baseDate, dayOffset);
    }

    public static StringTemplate truncDate(Expression<?> dateExpr, String unit) {
        return truncDate(dateExpr, unit, 0);
    }

    public static StringTemplate truncDate(String unit) {
        return truncDate(null, unit, 0);
    }

    public static StringTemplate truncDate(String unit, int dayOffset) {
        return truncDate(null, unit, dayOffset);
    }

    /**
     * Oracle DB 커스텀 영업일 조회 함수 F_OPEN_YMD(TRUNC(SYSDATE, unit) + dayOffset, delimiter) 호출
     * 
     * @param unit      'mm' (해당 월의 01일 기준 영업일) 또는 'dd' (해당 일자 기준 영업일)
     * @param dayOffset 일수 오프셋 (-1: 어제/전일, +1: 내일/다음날)
     * @param delimiter 날짜 구분자 (기본값 '-')
     */
    public static StringTemplate fOpenYmd() {
        return fOpenYmd("dd", 0, "-");
    }

    public static StringTemplate fOpenYmd(String delimiter) {
        return fOpenYmd("dd", 0, delimiter);
    }

    public static StringTemplate fOpenYmd(String unit, String delimiter) {
        return fOpenYmd(null, unit, 0, delimiter);
    }

    public static StringTemplate fOpenYmd(String unit, int dayOffset, String delimiter) {
        return fOpenYmd(null, unit, dayOffset, delimiter);
    }

    public static StringTemplate fOpenYmd(Expression<?> dateExpr, String unit, String delimiter) {
        return fOpenYmd(dateExpr, unit, 0, delimiter);
    }

    public static StringTemplate fOpenYmd(Expression<?> dateExpr, String unit, int dayOffset, String delimiter) {
        StringTemplate dateTemplate = truncDate(dateExpr, unit, dayOffset);
        return Expressions.stringTemplate("function('f_open_ymd', {0}, {1})", dateTemplate, delimiter);
    }
}
