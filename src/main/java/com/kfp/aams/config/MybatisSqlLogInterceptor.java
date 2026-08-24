package com.kfp.aams.config;

import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.session.ResultHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.sql.Statement;
import java.util.Properties;

@Component
@Intercepts({
    @Signature(type = StatementHandler.class, method = "query", args = {Statement.class, ResultHandler.class}),
    @Signature(type = StatementHandler.class, method = "update", args = {Statement.class})
})
public class MybatisSqlLogInterceptor implements Interceptor {

    private static final Logger log = LoggerFactory.getLogger("com.kfp.aams.sql");

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        long startTime = System.currentTimeMillis();
        Object result = invocation.proceed();
        long elapsedTime = System.currentTimeMillis() - startTime;

        try {
            StatementHandler statementHandler = (StatementHandler) invocation.getTarget();
            BoundSql boundSql = statementHandler.getBoundSql();
            String sql = boundSql.getSql();

            if (sql != null && !sql.isBlank()) {
                String formattedSql = formatSql(sql);
                Object paramObj = boundSql.getParameterObject();
                log.info("\n---------------- [MyBatis SQL Execution ({})ms] ----------------\n{}\nParameters: {}\n------------------------------------------------------------",
                        elapsedTime, formattedSql, paramObj != null ? paramObj : "None");
            }
        } catch (Exception e) {
            // Logging failure should not break execution
        }

        return result;
    }

    private String formatSql(String sql) {
        if (sql == null || sql.isBlank()) return sql;

        // Preserve already formatted SQL lines if newline exists
        if (sql.contains("\n")) {
            return sql.trim();
        }

        return sql.trim()
                .replaceAll("(?i)\\s+SELECT\\s+", "\nSELECT ")
                .replaceAll("(?i)\\s+FROM\\s+", "\n  FROM ")
                .replaceAll("(?i)\\s+JOIN\\s+", "\n  JOIN ")
                .replaceAll("(?i)\\s+LEFT OUTER JOIN\\s+", "\n  LEFT OUTER JOIN ")
                .replaceAll("(?i)\\s+LEFT JOIN\\s+", "\n  LEFT JOIN ")
                .replaceAll("(?i)\\s+WHERE\\s+", "\n WHERE ")
                .replaceAll("(?i)\\s+AND\\s+", "\n   AND ")
                .replaceAll("(?i)\\s+OR\\s+", "\n    OR ")
                .replaceAll("(?i)\\s+UNION ALL\\s+", "\nUNION ALL\n")
                .replaceAll("(?i)\\s+UNION\\s+", "\nUNION\n")
                .replaceAll("(?i)\\s+ORDER BY\\s+", "\n ORDER BY ")
                .replaceAll("(?i)\\s+GROUP BY\\s+", "\n GROUP BY ");
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {
    }
}
