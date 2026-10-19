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
    private static final String ANSI_RED = "\u001B[1;31m";    // Bold Red for MyBatis Execution Failures

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        long startTime = System.currentTimeMillis();
        try {
            Object result = invocation.proceed();
            long elapsedTime = System.currentTimeMillis() - startTime;
            handleSuccessLog(invocation, elapsedTime);
            return result;
        } catch (Throwable t) {
            long elapsedTime = System.currentTimeMillis() - startTime;
            handleFailLog(invocation, elapsedTime, t);
            throw t;
        }
    }

    private void handleSuccessLog(Invocation invocation, long elapsedTime) {
        try {
            StatementHandler statementHandler = (StatementHandler) invocation.getTarget();
            BoundSql boundSql = statementHandler.getBoundSql();
            String sql = boundSql.getSql();

            if (sql != null && !sql.isBlank()) {
                MappedStatement ms = resolveMappedStatement(statementHandler);
                String mapperId = ms != null ? ms.getId() : null;
                Configuration configuration = ms != null ? ms.getConfiguration() : null;
                String serviceInfo = findCallerService();

                String executableSql = generateExecutableSql(configuration, boundSql);
                String formattedSql = formatSql(executableSql);
                Object paramObj = boundSql.getParameterObject();

                StringBuilder sb = new StringBuilder();
                sb.append(ANSI_YELLOW).append("---------------- [MyBatis SQL Execution (").append(elapsedTime).append(")ms] ----------------").append(ANSI_RESET).append("\n");
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
        } catch (Exception ignored) {
        }
    }

    private void handleFailLog(Invocation invocation, long elapsedTime, Throwable cause) {
        try {
            StatementHandler statementHandler = (StatementHandler) invocation.getTarget();
            BoundSql boundSql = statementHandler.getBoundSql();
            String sql = boundSql != null ? boundSql.getSql() : "";

            MappedStatement ms = resolveMappedStatement(statementHandler);
            String mapperId = ms != null ? ms.getId() : null;
            Configuration configuration = ms != null ? ms.getConfiguration() : null;
            String serviceInfo = findCallerService();

            String executableSql = (boundSql != null) ? generateExecutableSql(configuration, boundSql) : sql;
            String formattedSql = formatSql(executableSql);
            Object paramObj = boundSql != null ? boundSql.getParameterObject() : null;

            StringBuilder sb = new StringBuilder();
            sb.append(ANSI_RED).append("---------------- [MyBatis SQL Execution FAILED (").append(elapsedTime).append(")ms] ----------------").append(ANSI_RESET).append("\n");
            if (serviceInfo != null && !serviceInfo.equals("-")) {
                sb.append("Service   : ").append(serviceInfo).append("\n");
            }
            if (mapperId != null) {
                sb.append("Mapper ID : ").append(mapperId).append("\n");
            }
            if (cause != null) {
                Throwable root = cause;
                while (root.getCause() != null && root.getCause() != root) {
                    root = root.getCause();
                }
                sb.append("Error     : ").append(root.getClass().getSimpleName()).append(": ").append(root.getMessage() != null ? root.getMessage() : cause.getMessage()).append("\n");
            }
            sb.append(ANSI_RED).append("----------------------------------------------------------------").append(ANSI_RESET).append("\n");
            sb.append(formattedSql).append("\n");
            sb.append("Parameters: ").append(paramObj != null ? paramObj : "None").append("\n");
            sb.append(ANSI_RED).append("----------------------------------------------------------------").append(ANSI_RESET);

            log.error(sb.toString(), cause);
        } catch (Exception ignored) {
        }
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

        // 줄바꿈이 포함된 SQL인 경우 (MyBatis XML 템플릿)
        if (sql.contains("\n")) {
            // 1. 공통 태그 들여쓰기 제거
            String stripped = sql.stripIndent();
            String[] lines = stripped.split("\r?\n");

            int start = 0;
            while (start < lines.length && lines[start].isBlank()) {
                start++;
            }
            int end = lines.length - 1;
            while (end >= start && lines[end].isBlank()) {
                end--;
            }

            if (start > end) return "";

            // 첫 줄이 0칸인데 둘째 줄 이후가 여전히 XML 인덴트로 붕 떠있는 경우 보정
            int firstIndent = countLeadingSpaces(lines[start]);
            int minSubsequentIndent = Integer.MAX_VALUE;
            boolean hasSubsequent = false;
            for (int i = start + 1; i <= end; i++) {
                if (!lines[i].isBlank()) {
                    hasSubsequent = true;
                    minSubsequentIndent = Math.min(minSubsequentIndent, countLeadingSpaces(lines[i]));
                }
            }

            int excessIndent = 0;
            if (hasSubsequent && firstIndent == 0 && minSubsequentIndent >= 6) {
                // 오라클 정렬에서 WHERE는 1칸, FROM은 2칸, ','는 5칸이므로 6칸 이상 잔여 인덴트 보정
                excessIndent = minSubsequentIndent - 1;
            }

            StringBuilder result = new StringBuilder();
            for (int i = start; i <= end; i++) {
                String line = lines[i];
                if (line.isBlank()) {
                    result.append("\n");
                    continue;
                }

                if (i > start && excessIndent > 0) {
                    int curIndent = countLeadingSpaces(line);
                    int cut = Math.min(curIndent, excessIndent);
                    line = line.substring(cut);
                }

                // 1) 과도하게 깊은 서브쿼리 들여쓰기 압축 (터미널 폭 초과 줄 꺾임 방지)
                line = compressIndent(line);
                // 2) 줄 내부 4칸 이상 연속 공백 압축 (작은따옴표 내부 리터럴 안전 보존)
                line = collapseInnerWhitespace(line);

                if (result.length() > 0) {
                    result.append("\n");
                }
                result.append(line);
            }

            return result.toString();
        }

        return formatSingleLineSql(sql);
    }

    private String formatSingleLineSql(String sql) {
        return sql.trim()
                .replaceAll("(?i)\\s+SELECT\\s+", "\nSELECT ")
                .replaceAll("(?i)\\s+FROM\\s+", "\n  FROM ")
                .replaceAll("(?i)\\s+JOIN\\s+", "\n  JOIN ")
                .replaceAll("(?i)\\s+LEFT OUTER JOIN\\s+", "\n  LEFT OUTER JOIN ")
                .replaceAll("(?i)\\s+LEFT JOIN\\s+", "\n  LEFT JOIN ")
                .replaceAll("(?i)\\s+RIGHT JOIN\\s+", "\n  RIGHT JOIN ")
                .replaceAll("(?i)\\s+INNER JOIN\\s+", "\n  INNER JOIN ")
                .replaceAll("(?i)\\s+WHERE\\s+", "\n WHERE ")
                .replaceAll("(?i)\\s+AND\\s+", "\n   AND ")
                .replaceAll("(?i)\\s+OR\\s+", "\n    OR ")
                .replaceAll("(?i)\\s+UNION ALL\\s+", "\nUNION ALL\n")
                .replaceAll("(?i)\\s+UNION\\s+", "\nUNION\n")
                .replaceAll("(?i)\\s+ORDER BY\\s+", "\n ORDER BY ")
                .replaceAll("(?i)\\s+GROUP BY\\s+", "\n GROUP BY ");
    }

    private int countLeadingSpaces(String line) {
        int count = 0;
        while (count < line.length() && line.charAt(count) == ' ') {
            count++;
        }
        return count;
    }

    private String compressIndent(String line) {
        int leading = countLeadingSpaces(line);
        if (leading <= 12) return line;

        // 12칸 초과 들여쓰기는 터미널 너비(80~120) 초과로 인한 줄바꿈 꺾임 방지를 위해 3:1 비율로 압축
        int extra = leading - 12;
        int compressedExtra = Math.min(8, extra / 3);
        int finalIndent = 12 + compressedExtra;

        return " ".repeat(finalIndent) + line.substring(leading);
    }

    private String collapseInnerWhitespace(String line) {
        if (line == null || line.length() < 4) return line;

        int nonSpaceIdx = countLeadingSpaces(line);
        if (nonSpaceIdx == line.length()) return "";

        String leadingSpaces = line.substring(0, nonSpaceIdx);
        String content = line.substring(nonSpaceIdx);

        StringBuilder sb = new StringBuilder();
        boolean inQuote = false;
        int spaceCount = 0;

        for (int i = 0; i < content.length(); i++) {
            char c = content.charAt(i);

            if (c == '\'') {
                if (spaceCount > 0) {
                    sb.append(spaceCount >= 4 ? "  " : " ".repeat(spaceCount));
                    spaceCount = 0;
                }
                inQuote = !inQuote;
                sb.append(c);
            } else if (inQuote) {
                sb.append(c);
            } else if (c == ' ') {
                spaceCount++;
            } else {
                if (spaceCount > 0) {
                    sb.append(spaceCount >= 4 ? "  " : " ".repeat(spaceCount));
                    spaceCount = 0;
                }
                sb.append(c);
            }
        }

        return leadingSpaces + sb.toString();
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {
    }
}
