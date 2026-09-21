package com.kfp.aams.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * QueryDSL / JPA SQL Logging Configuration
 * Intercepts JDBC PreparedStatement calls from QueryDSL and Hibernate
 * to display complete, executable SQL with parameters bound, along with caller Service & Repository info.
 */
@Configuration(proxyBeanMethods = false)
public class QueryDslSqlLogConfig implements BeanPostProcessor {

    private static final Logger log = LoggerFactory.getLogger("com.kfp.aams.sql");
    private static final String ANSI_RESET = "\u001B[0m";
    private static final String ANSI_BLUE = "\u001B[1;34m"; // Bold Blue for QueryDSL visibility

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        if (bean instanceof DataSource && !Proxy.isProxyClass(bean.getClass())) {
            return wrapDataSource((DataSource) bean);
        }
        return bean;
    }

    private DataSource wrapDataSource(DataSource targetDataSource) {
        return (DataSource) Proxy.newProxyInstance(
                targetDataSource.getClass().getClassLoader(),
                new Class<?>[]{DataSource.class},
                (proxy, method, args) -> {
                    String methodName = method.getName();
                    if ("getConnection".equals(methodName)) {
                        Connection conn = (Connection) method.invoke(targetDataSource, args);
                        return wrapConnection(conn);
                    }
                    if ("unwrap".equals(methodName) && args != null && args.length == 1) {
                        Class<?> iface = (Class<?>) args[0];
                        if (iface.isInstance(targetDataSource)) {
                            return targetDataSource;
                        }
                    } else if ("isWrapperFor".equals(methodName) && args != null && args.length == 1) {
                        Class<?> iface = (Class<?>) args[0];
                        if (iface.isInstance(targetDataSource)) {
                            return true;
                        }
                    }
                    return method.invoke(targetDataSource, args);
                }
        );
    }

    private Connection wrapConnection(Connection targetConnection) {
        return (Connection) Proxy.newProxyInstance(
                targetConnection.getClass().getClassLoader(),
                new Class<?>[]{Connection.class},
                (proxy, method, args) -> {
                    String methodName = method.getName();
                    if ("prepareStatement".equals(methodName) && args != null && args.length > 0 && args[0] instanceof String) {
                        String sql = (String) args[0];
                        PreparedStatement ps = (PreparedStatement) method.invoke(targetConnection, args);
                        return wrapPreparedStatement(ps, sql);
                    }
                    if ("unwrap".equals(methodName) && args != null && args.length == 1) {
                        Class<?> iface = (Class<?>) args[0];
                        if (iface.isInstance(targetConnection)) {
                            return targetConnection;
                        }
                    } else if ("isWrapperFor".equals(methodName) && args != null && args.length == 1) {
                        Class<?> iface = (Class<?>) args[0];
                        if (iface.isInstance(targetConnection)) {
                            return true;
                        }
                    }
                    return method.invoke(targetConnection, args);
                }
        );
    }

    private PreparedStatement wrapPreparedStatement(PreparedStatement targetPs, String sql) {
        Map<Integer, Object> params = new TreeMap<>();

        return (PreparedStatement) Proxy.newProxyInstance(
                targetPs.getClass().getClassLoader(),
                new Class<?>[]{PreparedStatement.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        String methodName = method.getName();

                        if (methodName.startsWith("set") && args != null && args.length >= 2 && args[0] instanceof Integer) {
                            int idx = (Integer) args[0];
                            if ("setNull".equals(methodName)) {
                                params.put(idx, null);
                            } else {
                                params.put(idx, args[1]);
                            }
                        } else if ("clearParameters".equals(methodName)) {
                            params.clear();
                        } else if ("executeQuery".equals(methodName) || "executeUpdate".equals(methodName) || "execute".equals(methodName) || "executeLargeUpdate".equals(methodName)) {
                            long start = System.currentTimeMillis();
                            Object result = method.invoke(targetPs, args);
                            long elapsed = System.currentTimeMillis() - start;

                            handleLog(sql, params, elapsed);
                            return result;
                        } else if ("unwrap".equals(methodName) && args != null && args.length == 1) {
                            Class<?> iface = (Class<?>) args[0];
                            if (iface.isInstance(targetPs)) {
                                return targetPs;
                            }
                        } else if ("isWrapperFor".equals(methodName) && args != null && args.length == 1) {
                            Class<?> iface = (Class<?>) args[0];
                            if (iface.isInstance(targetPs)) {
                                return true;
                            }
                        }

                        return method.invoke(targetPs, args);
                    }
                }
        );
    }

    private void handleLog(String sql, Map<Integer, Object> params, long elapsedTime) {
        try {
            // MyBatis 실행인 경우 MybatisSqlLogInterceptor가 처리하므로 중복 제외
            if (isMyBatisExecution()) {
                return;
            }

            // 호출자 정보 탐색
            CallerInfo caller = findCallerInfo();
            if (caller == null) {
                return;
            }

            String executableSql = formatExecutableSql(sql, params);
            String formattedSql = formatSql(executableSql);

            StringBuilder sb = new StringBuilder();
            sb.append("\n").append(ANSI_BLUE).append("---------------- [QueryDSL / JPA SQL Execution (").append(elapsedTime).append(")ms] ----------------").append(ANSI_RESET).append("\n");
            if (caller.service != null) {
                sb.append("Service    : ").append(caller.service).append("\n");
            }
            if (caller.repository != null) {
                sb.append("Repository : ").append(caller.repository).append("\n");
            }
            sb.append(ANSI_BLUE).append("-----------------------------------------------------------------------").append(ANSI_RESET).append("\n");
            sb.append(formattedSql).append("\n");
            sb.append("Parameters : ").append(formatParamsSummary(params)).append("\n");
            sb.append(ANSI_BLUE).append("-----------------------------------------------------------------------").append(ANSI_RESET);

            log.info(sb.toString());
        } catch (Exception ignored) {
        }
    }

    private boolean isMyBatisExecution() {
        for (StackTraceElement el : Thread.currentThread().getStackTrace()) {
            String cn = el.getClassName();
            if (cn.contains("org.apache.ibatis")) {
                return true;
            }
        }
        return false;
    }

    private static class CallerInfo {
        String service;
        String repository;
    }

    private CallerInfo findCallerInfo() {
        StackTraceElement[] elements = Thread.currentThread().getStackTrace();
        CallerInfo info = new CallerInfo();
        boolean foundAny = false;

        for (StackTraceElement el : elements) {
            String className = el.getClassName();
            if (!className.startsWith("com.kfp.aams")) continue;
            if (className.contains("QueryDslSqlLogConfig") || className.contains("MybatisSqlLogInterceptor")) continue;

            if (className.contains("$$")) {
                className = className.substring(0, className.indexOf("$$"));
            }

            String simpleName = className.substring(className.lastIndexOf('.') + 1);
            String location = simpleName + "." + el.getMethodName() + "() [line:" + el.getLineNumber() + "]";

            if (info.service == null && (className.contains("Service") || className.contains(".service."))) {
                info.service = location;
                foundAny = true;
            }

            if (info.repository == null && (className.contains("Repository") || className.contains("QueryDsl") || className.contains(".repository."))) {
                info.repository = location;
                foundAny = true;
            }

            if (info.service == null && (className.contains("Controller") || className.contains(".controller."))) {
                info.service = location;
                foundAny = true;
            }
        }

        return foundAny ? info : null;
    }

    private String formatExecutableSql(String sql, Map<Integer, Object> params) {
        if (sql == null || params == null || params.isEmpty()) {
            return sql;
        }

        StringBuilder sb = new StringBuilder();
        int paramIndex = 1;
        boolean inQuote = false;

        for (int i = 0; i < sql.length(); i++) {
            char c = sql.charAt(i);
            if (c == '\'') {
                // 연속된 ''(따옴표 이스케이프) 처리 또는 따옴표 토글
                inQuote = !inQuote;
                sb.append(c);
            } else if (c == '?' && !inQuote) {
                if (params.containsKey(paramIndex)) {
                    Object val = params.get(paramIndex);
                    sb.append(formatLiteral(val));
                } else {
                    sb.append('?');
                }
                paramIndex++;
            } else {
                sb.append(c);
            }
        }

        return sb.toString();
    }

    private String formatLiteral(Object value) {
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

    private String formatParamsSummary(Map<Integer, Object> params) {
        if (params == null || params.isEmpty()) return "None";
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<Integer, Object> entry : params.entrySet()) {
            if (!first) sb.append(", ");
            sb.append(entry.getKey()).append("=").append(formatLiteral(entry.getValue()));
            first = false;
        }
        sb.append("}");
        return sb.toString();
    }

    private String formatSql(String sql) {
        if (sql == null || sql.isBlank()) return sql;

        // 1. SELECT 절 컬럼 분리 (콤마 앞에 개행 추가)
        String formatted = formatSelectColumns(sql.trim());

        // 2. 주요 SQL 키워드 줄바꿈 및 인덴트 처리
        return formatted
                .replaceAll("(?i)\\s+FROM\\s+", "\n  FROM ")
                .replaceAll("(?i)\\s+WHERE\\s+", "\n WHERE ")
                .replaceAll("(?i)\\s+AND\\s+", "\n   AND ")
                .replaceAll("(?i)\\s+OR\\s+", "\n    OR ")
                .replaceAll("(?i)\\s+ORDER BY\\s+", "\n ORDER BY ")
                .replaceAll("(?i)\\s+GROUP BY\\s+", "\n GROUP BY ")
                .replaceAll("(?i)\\s+HAVING\\s+", "\n HAVING ")
                .replaceAll("(?i)\\s+LEFT OUTER JOIN\\s+", "\n  LEFT OUTER JOIN ")
                .replaceAll("(?i)\\s+LEFT JOIN\\s+", "\n  LEFT JOIN ")
                .replaceAll("(?i)\\s+RIGHT JOIN\\s+", "\n  RIGHT JOIN ")
                .replaceAll("(?i)\\s+INNER JOIN\\s+", "\n  INNER JOIN ")
                .replaceAll("(?i)\\s+JOIN\\s+", "\n  JOIN ");
    }

    private String formatSelectColumns(String sql) {
        // SELECT 키워드 찾기 (문자열 시작 또는 공백 뒤)
        Pattern selectPattern = Pattern.compile("(?i)(^|\\s)(SELECT)\\s+");
        Matcher selectMatcher = selectPattern.matcher(sql);
        if (!selectMatcher.find()) {
            return sql;
        }

        int selectStart = selectMatcher.start(2); // "SELECT" 시작 위치
        int selectEnd = selectMatcher.end();     // "SELECT " 끝 위치

        // 최상위 FROM 위치 탐색 (괄호 밖, 따옴표 밖)
        int fromIdx = -1;
        int depth = 0;
        boolean inQuote = false;

        for (int i = selectEnd; i < sql.length(); i++) {
            char c = sql.charAt(i);
            if (c == '\'') {
                inQuote = !inQuote;
            } else if (!inQuote) {
                if (c == '(') {
                    depth++;
                } else if (c == ')') {
                    depth--;
                } else if (depth == 0) {
                    // 단어 경계로 FROM 확인
                    if ((i == 0 || Character.isWhitespace(sql.charAt(i - 1)))
                            && i + 4 <= sql.length()
                            && sql.substring(i, i + 4).equalsIgnoreCase("FROM")
                            && (i + 4 == sql.length() || Character.isWhitespace(sql.charAt(i + 4)))) {
                        fromIdx = i;
                        break;
                    }
                }
            }
        }

        if (fromIdx <= selectEnd) {
            return sql;
        }

        String prefix = sql.substring(0, selectStart) + "SELECT ";
        String selectClause = sql.substring(selectEnd, fromIdx).trim();
        String suffix = sql.substring(fromIdx);

        // SELECT 절 내부 컬럼 분리 (콤마 앞에 개행과 인덴트 삽입)
        StringBuilder formattedCols = new StringBuilder();
        int colDepth = 0;
        boolean colInQuote = false;

        for (int j = 0; j < selectClause.length(); j++) {
            char sc = selectClause.charAt(j);
            if (sc == '\'') {
                colInQuote = !colInQuote;
                formattedCols.append(sc);
            } else if (sc == '(') {
                colDepth++;
                formattedCols.append(sc);
            } else if (sc == ')') {
                colDepth--;
                formattedCols.append(sc);
            } else if (sc == ',' && colDepth == 0 && !colInQuote) {
                formattedCols.append("\n     , ");
                // 쉼표 뒤 기존 공백 제거
                while (j + 1 < selectClause.length() && Character.isWhitespace(selectClause.charAt(j + 1))) {
                    j++;
                }
            } else {
                formattedCols.append(sc);
            }
        }

        return prefix + formattedCols.toString() + " " + suffix.trim();
    }
}
