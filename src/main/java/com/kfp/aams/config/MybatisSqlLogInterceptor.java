package com.kfp.aams.config;

import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.reflection.SystemMetaObject;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.type.TypeHandlerRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.regex.Matcher;

@Component
@Intercepts({
    @Signature(type = StatementHandler.class, method = "query", args = {Statement.class, ResultHandler.class}),
    @Signature(type = StatementHandler.class, method = "update", args = {Statement.class})
})
public class MybatisSqlLogInterceptor implements Interceptor {

    private static final Logger log = LoggerFactory.getLogger("com.kfp.aams.sql");
    private static final String ANSI_RESET = "\u001B[0m";
    private static final String ANSI_YELLOW = "\u001B[1;33m"; // Bold Yellow for MyBatis visibility

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
                // 1. MappedStatement 및 Mapper ID 추출
                MappedStatement ms = resolveMappedStatement(statementHandler);
                String mapperId = ms != null ? ms.getId() : null;
                Configuration configuration = ms != null ? ms.getConfiguration() : null;

                // 2. 호출한 Service / Controller 정보 추출
                String serviceInfo = findCallerService();

                // 3. 파라미터가 물음표(?)에 대입된 완성형 SQL 생성
                String executableSql = generateExecutableSql(configuration, boundSql);
                String formattedSql = formatSql(executableSql);

                Object paramObj = boundSql.getParameterObject();

                StringBuilder sb = new StringBuilder();
                sb.append("\n").append(ANSI_YELLOW).append("---------------- [MyBatis SQL Execution (").append(elapsedTime).append(")ms] ----------------").append(ANSI_RESET).append("\n");
                if (serviceInfo != null && !serviceInfo.equals("-")) {
                    sb.append("Service   : ").append(serviceInfo).append("\n");
                }
                if (mapperId != null) {
                    sb.append("Mapper ID : ").append(mapperId).append("\n");
                }
                sb.append(ANSI_YELLOW).append("----------------------------------------------------------------").append(ANSI_RESET).append("\n");
                sb.append(formattedSql).append("\n");
                sb.append("Parameters: ").append(paramObj != null ? paramObj : "None").append("\n");
                sb.append(ANSI_YELLOW).append("----------------------------------------------------------------").append(ANSI_RESET);

                log.info(sb.toString());
            }
        } catch (Exception e) {
            // Logging failure should not break execution
        }

        return result;
    }

    /**
     * SQL 내의 ? 기호에 파라미터를 실제 값으로 치환하여 바로 실행 가능한 완성된 SQL 생성
     */
    private String generateExecutableSql(Configuration configuration, BoundSql boundSql) {
        String sql = boundSql.getSql();
        if (sql == null || sql.isBlank()) return sql;

        List<ParameterMapping> parameterMappings = boundSql.getParameterMappings();
        Object parameterObject = boundSql.getParameterObject();

        if (parameterMappings == null || parameterMappings.isEmpty() || parameterObject == null) {
            return sql;
        }

        try {
            TypeHandlerRegistry typeHandlerRegistry = configuration != null ? configuration.getTypeHandlerRegistry() : null;

            // 단일 기본 타입(String, Number, Date 등) 파라미터인 경우
            if (typeHandlerRegistry != null && typeHandlerRegistry.hasTypeHandler(parameterObject.getClass())) {
                String valueStr = formatParameterValue(parameterObject);
                return sql.replaceFirst("\\?", Matcher.quoteReplacement(valueStr));
            }

            MetaObject metaObject = configuration != null ? configuration.newMetaObject(parameterObject) : SystemMetaObject.forObject(parameterObject);

            for (ParameterMapping parameterMapping : parameterMappings) {
                String propertyName = parameterMapping.getProperty();
                Object value = null;

                if (boundSql.hasAdditionalParameter(propertyName)) {
                    value = boundSql.getAdditionalParameter(propertyName);
                } else if (metaObject.hasGetter(propertyName)) {
                    value = metaObject.getValue(propertyName);
                } else if (typeHandlerRegistry != null && typeHandlerRegistry.hasTypeHandler(parameterObject.getClass())) {
                    value = parameterObject;
                }

                String valueStr = formatParameterValue(value);
                sql = sql.replaceFirst("\\?", Matcher.quoteReplacement(valueStr));
            }
        } catch (Exception e) {
            // 치환 실패 시 원본 SQL 유지
            return boundSql.getSql();
        }

        return sql;
    }

    /**
     * 파라미터 값에 따른 SQL 리터럴 포맷팅 (문자열 따옴표 감싸기, NULL 처리 등)
     */
    private String formatParameterValue(Object value) {
        if (value == null) {
            return "NULL";
        }
        if (value instanceof Number || value instanceof Boolean) {
            return String.valueOf(value);
        }
        if (value instanceof String) {
            return "'" + value.toString().replace("'", "''") + "'";
        }
        if (value instanceof java.sql.Date || value instanceof java.sql.Time || value instanceof java.sql.Timestamp) {
            return "'" + value.toString() + "'";
        }
        if (value instanceof Date) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            return "'" + sdf.format((Date) value) + "'";
        }
        if (value instanceof LocalDateTime) {
            return "'" + ((LocalDateTime) value).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) + "'";
        }
        if (value instanceof LocalDate) {
            return "'" + ((LocalDate) value).format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + "'";
        }

        return "'" + value.toString().replace("'", "''") + "'";
    }

    /**
     * StatementHandler로부터 MappedStatement 추출
     */
    private MappedStatement resolveMappedStatement(StatementHandler statementHandler) {
        try {
            MetaObject metaObject = SystemMetaObject.forObject(statementHandler);
            while (metaObject.hasGetter("h")) {
                Object h = metaObject.getValue("h");
                metaObject = SystemMetaObject.forObject(h);
            }
            while (metaObject.hasGetter("target")) {
                Object target = metaObject.getValue("target");
                metaObject = SystemMetaObject.forObject(target);
            }
            if (metaObject.hasGetter("delegate.mappedStatement")) {
                return (MappedStatement) metaObject.getValue("delegate.mappedStatement");
            } else if (metaObject.hasGetter("mappedStatement")) {
                return (MappedStatement) metaObject.getValue("mappedStatement");
            }
        } catch (Exception ignored) {
        }
        return null;
    }

    /**
     * Call Stack에서 com.kfp.aams 패키지의 호출 Service(또는 Controller) 위치 추출
     */
    private String findCallerService() {
        StackTraceElement[] elements = Thread.currentThread().getStackTrace();
        String fallbackCaller = null;

        for (StackTraceElement el : elements) {
            String className = el.getClassName();
            if (!className.startsWith("com.kfp.aams")) continue;
            if (className.contains("MybatisSqlLogInterceptor") || className.contains(".mapper.") || className.contains("Mapper")) continue;

            // Spring CGLIB 프록시 클래스명 제거
            if (className.contains("$$")) {
                className = className.substring(0, className.indexOf("$$"));
            }

            String simpleName = className.substring(className.lastIndexOf('.') + 1);
            String callerInfo = simpleName + "." + el.getMethodName() + "() [line:" + el.getLineNumber() + "]";

            if (className.contains("Service") || className.contains(".service.")) {
                return callerInfo;
            }

            if (fallbackCaller == null && (className.contains("Controller") || className.contains(".controller."))) {
                fallbackCaller = callerInfo;
            }
        }

        return fallbackCaller != null ? fallbackCaller : "-";
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
