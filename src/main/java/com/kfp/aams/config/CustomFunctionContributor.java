package com.kfp.aams.config;

import org.hibernate.boot.model.FunctionContributions;
import org.hibernate.boot.model.FunctionContributor;
import org.hibernate.type.StandardBasicTypes;

/**
 * Register Oracle custom DB functions (e.g. f_open_ymd) in Hibernate 6 ORM function registry
 */
public class CustomFunctionContributor implements FunctionContributor {

    @Override
    public void contributeFunctions(FunctionContributions functionContributions) {
        var basicTypeRegistry = functionContributions.getTypeConfiguration().getBasicTypeRegistry();

        // 1. f_open_ymd 커스텀 PL/SQL 함수
        functionContributions.getFunctionRegistry().registerPattern(
                "f_open_ymd",
                "f_open_ymd(?1, ?2)",
                basicTypeRegistry.resolve(StandardBasicTypes.STRING)
        );

        // 2. trunc_month: Oracle TRUNC(?1, 'MM') 날짜 월 단위(01일) 절삭 함수
        functionContributions.getFunctionRegistry().registerPattern(
                "trunc_month",
                "trunc(?1, 'MM')",
                basicTypeRegistry.resolve(StandardBasicTypes.DATE)
        );

        // 3. trunc_day: Oracle TRUNC(?1) 날짜 일 단위(자정) 절삭 함수
        functionContributions.getFunctionRegistry().registerPattern(
                "trunc_day",
                "trunc(?1)",
                basicTypeRegistry.resolve(StandardBasicTypes.DATE)
        );

        // 4. add_days: Oracle (?1 + ?2) 날짜 연산 함수 (오프셋 일수 더하기/빼기)
        functionContributions.getFunctionRegistry().registerPattern(
                "add_days",
                "(?1 + ?2)",
                basicTypeRegistry.resolve(StandardBasicTypes.DATE)
        );
    }
}
