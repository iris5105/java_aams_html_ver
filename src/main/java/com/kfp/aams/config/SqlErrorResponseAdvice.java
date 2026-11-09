package com.kfp.aams.config;

import org.springframework.core.MethodParameter;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

import java.util.Map;
import java.util.regex.Pattern;

/**
 * Marks SQL-failure API responses so the common browser fetch interceptor can
 * render a selectable error dialog without individual screen implementations.
 */
@ControllerAdvice
@Order(Ordered.HIGHEST_PRECEDENCE)
public class SqlErrorResponseAdvice implements ResponseBodyAdvice<Object> {

    public static final String SQL_ERROR_HEADER = "X-AAMS-Error-Type";
    public static final String SQL_ERROR_TYPE = "SQL";
    public static final String LOCAL_SQL_ERROR_HANDLING_HEADER = "X-AAMS-Local-Sql-Error-Handling";

    private static final Pattern SQL_ERROR_PATTERN = Pattern.compile(
            "(?is).*\\b(?:ORA-\\d+|SQL(?:Exception|State|SyntaxErrorException)|JDBC|MyBatis)\\b.*");

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return true;
    }

    @Override
    public Object beforeBodyWrite(Object body,
                                  MethodParameter returnType,
                                  MediaType selectedContentType,
                                  Class<? extends HttpMessageConverter<?>> selectedConverterType,
                                  ServerHttpRequest request,
                                  ServerHttpResponse response) {
        if (!isApiRequest(request) || hasLocalSqlErrorHandling(request) || !isSqlErrorBody(body)) {
            return body;
        }

        response.getHeaders().set(SQL_ERROR_HEADER, SQL_ERROR_TYPE);
        return body;
    }

    private boolean isApiRequest(ServerHttpRequest request) {
        return request != null
                && request.getURI() != null
                && request.getURI().getPath() != null
                && request.getURI().getPath().startsWith("/api/");
    }

    private boolean hasLocalSqlErrorHandling(ServerHttpRequest request) {
        String handling = request.getHeaders().getFirst(LOCAL_SQL_ERROR_HANDLING_HEADER);
        return Boolean.parseBoolean(handling);
    }

    private boolean isSqlErrorBody(Object body) {
        if (!(body instanceof Map<?, ?> map)) {
            return false;
        }

        if (SQL_ERROR_TYPE.equalsIgnoreCase(stringValue(map.get("errorType")))) {
            return true;
        }

        if (!Boolean.FALSE.equals(map.get("success"))) {
            return false;
        }

        return containsSqlError(stringValue(map.get("message")))
                || containsSqlError(stringValue(map.get("outMsg")))
                || containsSqlError(stringValue(map.get("error")));
    }

    private boolean containsSqlError(String value) {
        return value != null && SQL_ERROR_PATTERN.matcher(value).matches();
    }

    private String stringValue(Object value) {
        return value == null ? null : String.valueOf(value);
    }
}
