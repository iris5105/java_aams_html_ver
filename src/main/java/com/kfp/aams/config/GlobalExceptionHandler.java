package com.kfp.aams.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.IdentityHashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Global Exception Handler
 * Intercepts unhandled exceptions, logs full stack traces,
 * and handles REST API (JSON) vs View (HTML) error responses without media type mismatch errors.
 */
@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Pattern ORA_NOT_NULL_PATTERN = Pattern.compile(
            "ORA-0140[07]:.*?\\((?:\"([^\"]+)\"\\.)?\"([^\"]+)\"\\.\"([^\"]+)\"\\)",
            Pattern.CASE_INSENSITIVE | Pattern.DOTALL
    );

    private static final Pattern ORA_TOO_LARGE_PATTERN = Pattern.compile(
            "ORA-12899:.*?(?:\"([^\"]+)\"\\.)?\"([^\"]+)\"\\.\"([^\"]+)\"",
            Pattern.CASE_INSENSITIVE | Pattern.DOTALL
    );

    private final Map<String, String> columnCommentCache = new ConcurrentHashMap<>();

    @Autowired(required = false)
    private JdbcTemplate jdbcTemplate;

    /**
     * Authorization denials raised by MVC interceptors or request-body advice must remain
     * authorization failures, not be converted into a generic server error response.
     */
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Map<String, Object>> handleAccessDenied(
            AccessDeniedException ex,
            HttpServletRequest request
    ) {
        log.warn("Access denied for [{}]: {}", request.getRequestURI(), ex.getMessage());

        Map<String, Object> body = new HashMap<>();
        body.put("success", false);
        body.put("status", HttpStatus.FORBIDDEN.value());
        body.put("error", "Forbidden");
        body.put("message", ex.getMessage());
        body.put("path", request.getRequestURI());
        body.put("screen", ErrorLogHelper.extractScreenInfo(request));

        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .contentType(MediaType.APPLICATION_JSON)
                .body(body);
    }

    /**
     * 정적 자원(예: favicon.ico, 누락된 정적 리소스 등) 미존재 시 404를 반환하고,
     * 불필요한 500 ERROR 풀 스택 트레이스 로그 발생을 방지합니다.
     */
    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<Void> handleNoResourceFound(NoResourceFoundException ex, HttpServletRequest request) {
        log.debug("Static resource not found at [{}]: {}", request.getRequestURI(), ex.getMessage());
        return ResponseEntity.notFound().build();
    }

    /**
     * 클라이언트(브라우저)가 PDF 스트림 로딩 도중 다른 행을 클릭하거나 창을 닫아
     * 연결을 먼저 끊었을 때(ClientAbortException) 불필요한 500 에러 스택트레이스를 억제합니다.
     */
    @ExceptionHandler(org.apache.catalina.connector.ClientAbortException.class)
    public void handleClientAbort(org.apache.catalina.connector.ClientAbortException ex, HttpServletRequest request) {
        log.debug("Client aborted connection at [{}]: {}", request.getRequestURI(), ex.getMessage());
    }

    /**
     * 서블릿 응답 스트림(Writer/OutputStream) 중복 호출 예외 발생 시(예: 템플릿 렌더링 중단 후 에러 페이지 전송 시도)
     * 2차 연쇄 예외로 인한 불필요한 500 풀 스택트레이스를 억제합니다.
     */
    @ExceptionHandler(IllegalStateException.class)
    public Object handleIllegalStateException(IllegalStateException ex, HttpServletRequest request, HttpServletResponse response) {
        String msg = ex.getMessage();
        if (msg != null && (msg.contains("getWriter()") || msg.contains("getOutputStream()"))) {
            log.warn("Response stream/writer state conflict at [{}]: {}", request.getRequestURI(), msg);
            return null;
        }
        return handleAllExceptions(ex, request, response);
    }

    private boolean isClientAbort(Throwable throwable) {
        return Boolean.TRUE.equals(findInCauseChain(throwable, t -> {
            if (t instanceof org.apache.catalina.connector.ClientAbortException) {
                return Boolean.TRUE;
            }
            String msg = t.getMessage();
            if (msg != null && (msg.contains("Broken pipe") ||
                                msg.contains("사용자의 호스트 시스템") ||
                                msg.contains("Connection reset") ||
                                msg.contains("현재 연결은"))) {
                return Boolean.TRUE;
            }
            return null;
        }));
    }

    @ExceptionHandler(Exception.class)
    public Object handleAllExceptions(Exception ex, HttpServletRequest request, HttpServletResponse response) {
        if (isClientAbort(ex)) {
            log.debug("Client aborted connection at [{}]: {}", request.getRequestURI(), ex.getMessage());
            return null;
        }

        // 화면 번호, 유저 ID, 오류 서비스/매퍼/SQL, 요청 파라미터 구조화 상세 로그 기록
        ErrorLogHelper.logDetailedError(request, ex);

        if (response.isCommitted()) {
            log.warn("Response already committed for [{}], skipping error response body.", request.getRequestURI());
            return null;
        }

        String uri = request.getRequestURI();
        boolean isViewRequest = uri.startsWith("/views/") || uri.endsWith(".html");
        boolean isApiRequest = !isViewRequest && (
                uri.startsWith("/api/") ||
                "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With")) ||
                (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"))
        );

        if (isApiRequest) {
            Map<String, Object> body = new HashMap<>();
            body.put("success", false);
            body.put("status", 500);
            body.put("error", "Internal Server Error");
            SqlErrorDetail sqlDetail = resolveSqlErrorDetail(ex);
            if (sqlDetail != null) {
                body.put("message", sqlDetail.message());
                body.put("errorCode", sqlDetail.errorCode());
                body.put("errorTable", sqlDetail.tableName());
                body.put("errorColumn", sqlDetail.columnName());
                body.put("errorField", sqlDetail.fieldName());
            } else {
                body.put("message", ex.getMessage() != null ? ex.getMessage() : "서버 처리 중 오류가 발생했습니다.");
            }
            body.put("path", uri);
            body.put("screen", ErrorLogHelper.extractScreenInfo(request));
            if (isSqlException(ex)) {
                body.put("errorType", "SQL");
            }

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(body);
        } else {
            // HTML View Requests: Return error view cleanly
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            ModelAndView mav = new ModelAndView();
            SqlErrorDetail sqlDetail = resolveSqlErrorDetail(ex);
            mav.addObject("errorMessage", sqlDetail != null ? sqlDetail.message() : ex.getMessage());
            mav.addObject("path", uri);
            mav.setViewName("error");
            return mav;
        }
    }

    private record SqlErrorDetail(
            String errorCode,
            String tableName,
            String columnName,
            String fieldName,
            String message
    ) {}

    /**
     * Oracle DB 저장/수정 시 발생하는 NOT NULL(ORA-01400, ORA-01407) 및 길이 초과(ORA-12899) 오류에서
     * 테이블명과 컬럼명을 추출하고, DB 코멘트(한글 컬럼명)를 조회하여 상세 정보를 생성합니다.
     */
    private SqlErrorDetail resolveSqlErrorDetail(Throwable throwable) {
        return findInCauseChain(throwable, current -> {
            String message = current.getMessage();
            if (message == null) {
                return null;
            }
            Matcher notNullMatcher = ORA_NOT_NULL_PATTERN.matcher(message);
            if (notNullMatcher.find()) {
                String errorCode = message.contains("ORA-01407") ? "ORA-01407" : "ORA-01400";
                return buildSqlErrorDetail(notNullMatcher, errorCode, "[%s] 값을 정확하게 입력해 주세요.");
            }
            Matcher tooLargeMatcher = ORA_TOO_LARGE_PATTERN.matcher(message);
            if (tooLargeMatcher.find()) {
                return buildSqlErrorDetail(tooLargeMatcher, "ORA-12899", "[%s] 입력 값이 허용 길이를 초과했습니다. 다시 확인해 주세요.");
            }
            return null;
        });
    }

    private SqlErrorDetail buildSqlErrorDetail(Matcher matcher, String errorCode, String messageFormat) {
        String owner = matcher.group(1);
        String table = matcher.group(2);
        String column = matcher.group(3);
        String label = resolveColumnDisplayName(owner, table, column);
        String normTable = table != null ? table.trim().toUpperCase() : "";
        String normColumn = column != null ? column.trim().toUpperCase() : "";
        return new SqlErrorDetail(
                errorCode,
                normTable,
                normColumn,
                toCamelCase(normColumn),
                String.format(messageFormat, label)
        );
    }

    private String toCamelCase(String columnName) {
        if (columnName == null || columnName.isBlank()) {
            return "";
        }
        String[] parts = columnName.toLowerCase().split("_");
        StringBuilder sb = new StringBuilder(parts[0]);
        for (int i = 1; i < parts.length; i++) {
            if (!parts[i].isEmpty()) {
                sb.append(Character.toUpperCase(parts[i].charAt(0)))
                  .append(parts[i].substring(1));
            }
        }
        return sb.toString();
    }

    private String resolveColumnDisplayName(String owner, String table, String column) {
        if (column == null || column.isBlank()) {
            return "";
        }
        String normOwner = owner != null ? owner.trim().toUpperCase() : "";
        String normTable = table != null ? table.trim().toUpperCase() : "";
        String normColumn = column.trim().toUpperCase();
        String cacheKey = normOwner + "." + normTable + "." + normColumn;

        String cached = columnCommentCache.get(cacheKey);
        if (cached != null) {
            return cached;
        }

        String comment = queryColumnComment(normOwner, normTable, normColumn);
        String displayName = (comment != null && !comment.isBlank())
                ? comment + "(" + normColumn + ")"
                : normColumn;

        if (comment != null && !comment.isBlank()) {
            columnCommentCache.put(cacheKey, displayName);
        }
        return displayName;
    }

    private String queryColumnComment(String owner, String table, String column) {
        if (jdbcTemplate == null || table.isEmpty() || column.isEmpty()) {
            return null;
        }
        try {
            if (!owner.isEmpty()) {
                var results = jdbcTemplate.queryForList(
                        "SELECT COMMENTS FROM ALL_COL_COMMENTS WHERE OWNER = ? AND TABLE_NAME = ? AND COLUMN_NAME = ? AND COMMENTS IS NOT NULL AND ROWNUM = 1",
                        String.class,
                        owner, table, column
                );
                if (!results.isEmpty() && results.get(0) != null && !results.get(0).isBlank()) {
                    return results.get(0).trim();
                }
            }
            var fallback = jdbcTemplate.queryForList(
                    "SELECT COMMENTS FROM ALL_COL_COMMENTS WHERE TABLE_NAME = ? AND COLUMN_NAME = ? AND COMMENTS IS NOT NULL AND ROWNUM = 1",
                    String.class,
                    table, column
            );
            if (!fallback.isEmpty() && fallback.get(0) != null && !fallback.get(0).isBlank()) {
                return fallback.get(0).trim();
            }
        } catch (Exception e) {
            log.debug("Failed to query ALL_COL_COMMENTS for {}.{}: {}", table, column, e.getMessage());
        }
        return null;
    }

    private boolean isSqlException(Throwable throwable) {
        return Boolean.TRUE.equals(findInCauseChain(throwable, current -> {
            if (current instanceof SQLException) {
                return Boolean.TRUE;
            }
            String message = current.getMessage();
            if (message != null && message.matches("(?is).*\\b(?:ORA-\\d+|SQL(?:Exception|State|SyntaxErrorException)|JDBC|MyBatis)\\b.*")) {
                return Boolean.TRUE;
            }
            return null;
        }));
    }

    private <T> T findInCauseChain(Throwable throwable, Function<Throwable, T> mapper) {
        Set<Throwable> visited = Collections.newSetFromMap(new IdentityHashMap<>());
        Throwable current = throwable;
        while (current != null && visited.add(current)) {
            T result = mapper.apply(current);
            if (result != null) {
                return result;
            }
            current = current.getCause();
        }
        return null;
    }
}
