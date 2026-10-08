package com.kfp.aams.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * AAMS 예외 발생 시 화면 번호, 유저 아이디, 오류 서비스/매퍼/SQL, 요청 파라미터를 구조화하여
 * 로그 파일에 명확하게 남기는 공통 헬퍼 클래스.
 */
@Slf4j
public class ErrorLogHelper {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper()
            .disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");

    private static final Set<String> SENSITIVE_KEYS = Set.of(
            "password", "passwd", "pwd", "secret", "token", "accesstoken", "refreshtoken",
            "credential", "credentials", "authorization"
    );

    // URI에서 화면 ID/프로그램 번호 패턴 추출 (예: w_ja010h1, ja010h1, ja020k, 00804 등)
    private static final Pattern SCREEN_ID_PATTERN = Pattern.compile(
            "/(?:api/(?:[a-zA-Z0-9_-]+/)?|views/(?:[a-zA-Z0-9_-]+/)?)(w_[a-zA-Z0-9_]+|[a-zA-Z]{1,3}\\d{3,4}[a-zA-Z0-9_]*)"
    );

    // MyBatis 에러 메시지 파싱 패턴
    private static final Pattern MYBATIS_XML_PATTERN = Pattern.compile("### The error may exist in ([^\\r\\n]+)");
    private static final Pattern MYBATIS_STATEMENT_PATTERN = Pattern.compile("### The error may involve ([^\\r\\n]+)");
    private static final Pattern MYBATIS_SQL_PATTERN = Pattern.compile("### SQL:\\s*([^\\r\\n]+)");
    private static final Pattern MYBATIS_CAUSE_PATTERN = Pattern.compile("### Cause:\\s*([^\\r\\n]+)");

    /**
     * 오류 상세 정보 블록 로그 출력
     */
    public static void logDetailedError(HttpServletRequest request, Throwable ex) {
        try {
            String now = LocalDateTime.now().format(DATE_FORMATTER);
            String screenInfo = extractScreenInfo(request);
            String userInfo = extractUserInfo(request);
            String errorLocation = extractErrorLocation(ex);
            String parametersInfo = extractParametersInfo(request);
            String myBatisInfo = extractMyBatisInfo(ex);

            StringBuilder sb = new StringBuilder();
            sb.append("\n============================== [AAMS ERROR REPORT] ==============================\n");
            sb.append(String.format(" * 발생 일시     : %s%n", now));
            sb.append(String.format(" * 요청 URI      : [%s] %s%n", request.getMethod(), request.getRequestURI()));
            sb.append(String.format(" * 화면 번호(ID) : %s%n", screenInfo));
            sb.append(String.format(" * 요청 사용자   : %s%n", userInfo));
            sb.append(String.format(" * 오류 서비스   : %s%n", errorLocation));

            if (!myBatisInfo.isBlank()) {
                sb.append(String.format(" * 오류 매퍼(SQL): %s%n", myBatisInfo));
            }

            sb.append(String.format(" * 요청 파라미터 : %s%n", parametersInfo));
            sb.append(String.format(" * 예외 클래스   : %s%n", ex.getClass().getName()));
            sb.append(String.format(" * 예외 메시지   : %s%n", ex.getMessage()));

            Throwable rootCause = getRootCause(ex);
            if (rootCause != null && rootCause != ex) {
                sb.append(String.format(" * 근본 원인(Root): [%s] %s%n", rootCause.getClass().getName(), rootCause.getMessage()));
            }

            sb.append("==================================================================================");

            // ERROR 레벨로 출력 -> logback-spring.xml 설정에 의해 aams.log 및 aams-error.log에 동시 기록됨
            log.error(sb.toString(), ex);

        } catch (Exception loggingError) {
            // 로깅 도중 부가 예외가 발생하더라도 최소한의 원본 예외는 반드시 출력
            log.error("Failed to format detailed error report. Original exception: {}", ex.getMessage(), ex);
        }
    }

    /**
     * 1. 화면 번호 및 화면 ID 추출 (다계층 Fallback 전략)
     */
    public static String extractScreenInfo(HttpServletRequest request) {
        if (request == null) return "알 수 없음";

        // 1-1. 커스텀 요청 헤더 확인
        String pgmNoHeader = request.getHeader("X-Pgm-No");
        String pgmIdHeader = request.getHeader("X-Pgm-Id");
        String screenIdHeader = request.getHeader("X-Screen-Id");

        String pgmNo = (pgmNoHeader != null && !pgmNoHeader.isBlank()) ? pgmNoHeader.trim() : null;
        String pgmId = (pgmIdHeader != null && !pgmIdHeader.isBlank()) ? pgmIdHeader.trim() :
                       ((screenIdHeader != null && !screenIdHeader.isBlank()) ? screenIdHeader.trim() : null);

        // 1-2. 요청 파라미터 확인 (pgmNo, screenId 등)
        if (pgmNo == null) {
            String p = request.getParameter("pgmNo");
            if (p != null && !p.isBlank()) pgmNo = p.trim();
        }
        if (pgmId == null) {
            String s = request.getParameter("screenId");
            if (s != null && !s.isBlank()) pgmId = s.trim();
            else {
                String m = request.getParameter("menuId");
                if (m != null && !m.isBlank()) pgmId = m.trim();
            }
        }

        // 1-3. Referer 헤더에서 화면 식별자 파싱
        String referer = request.getHeader("Referer");
        String refererScreen = extractScreenFromUri(referer);

        // 1-4. 현재 요청 URI에서 화면 식별자 파싱
        String uriScreen = extractScreenFromUri(request.getRequestURI());

        if (pgmId == null) {
            pgmId = (refererScreen != null) ? refererScreen : uriScreen;
        }

        // 결과 포맷팅
        if (pgmNo != null && pgmId != null) {
            return String.format("%s (ID: %s)", pgmNo, pgmId);
        } else if (pgmNo != null) {
            return String.format("%s", pgmNo);
        } else if (pgmId != null) {
            return String.format("%s", pgmId);
        }

        return (request.getRequestURI() != null) ? request.getRequestURI() : "알 수 없음";
    }

    private static String extractScreenFromUri(String uri) {
        if (uri == null || uri.isBlank()) return null;
        try {
            Matcher matcher = SCREEN_ID_PATTERN.matcher(uri);
            if (matcher.find()) {
                return matcher.group(1);
            }
        } catch (Exception ignored) {
        }
        return null;
    }

    /**
     * 2. 요청 유저 아이디 및 정보 추출
     */
    public static String extractUserInfo(HttpServletRequest request) {
        String clientIp = extractClientIp(request);
        String userInfo = "ANONYMOUS";

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
                Object principal = auth.getPrincipal();
                if (principal instanceof UserPrincipal up) {
                    String userNm = (up.getUserNm() != null) ? up.getUserNm() : "";
                    String dept = (up.getDeptNm() != null) ? " / " + up.getDeptNm() : "";
                    userInfo = String.format("%s(%s%s)", up.getUserId(), userNm, dept);
                } else if (principal instanceof UserDetails ud) {
                    userInfo = ud.getUsername();
                } else if (auth.getName() != null && !auth.getName().isBlank()) {
                    userInfo = auth.getName();
                }
            }
        } catch (Exception ignored) {
        }

        return String.format("%s [IP: %s]", userInfo, clientIp);
    }

    private static String extractClientIp(HttpServletRequest request) {
        if (request == null) return "UNKNOWN";
        String[] headers = {"X-Forwarded-For", "Proxy-Client-IP", "WL-Proxy-Client-IP", "HTTP_CLIENT_IP", "HTTP_X_FORWARDED_FOR"};
        for (String header : headers) {
            String ip = request.getHeader(header);
            if (ip != null && !ip.isBlank() && !"unknown".equalsIgnoreCase(ip)) {
                return ip.split(",")[0].trim();
            }
        }
        return request.getRemoteAddr();
    }

    /**
     * 3. 오류가 발생한 서비스(Service) 및 발생 위치 추출
     */
    public static String extractErrorLocation(Throwable ex) {
        if (ex == null) return "위치 불명";

        String serviceLocation = null;
        String mapperLocation = null;
        String controllerLocation = null;
        String firstAamsLocation = null;

        Throwable current = ex;
        while (current != null) {
            for (StackTraceElement elem : current.getStackTrace()) {
                String className = elem.getClassName();
                if (className.startsWith("com.kfp.aams")) {
                    String loc = String.format("%s.%s (%s:%d)",
                            elem.getClassName(), elem.getMethodName(), elem.getFileName(), elem.getLineNumber());

                    if (firstAamsLocation == null) {
                        firstAamsLocation = loc;
                    }
                    if (className.contains("Service") && serviceLocation == null) {
                        serviceLocation = loc;
                    }
                    if (className.contains("Mapper") && mapperLocation == null) {
                        mapperLocation = loc;
                    }
                    if (className.contains("Controller") && controllerLocation == null) {
                        controllerLocation = loc;
                    }
                }
            }
            current = current.getCause();
        }

        // 우선순위: Service -> Mapper -> Controller -> 기타 AAMS 클래스 -> 최초 스택
        if (serviceLocation != null) return serviceLocation;
        if (mapperLocation != null) return mapperLocation;
        if (controllerLocation != null) return controllerLocation;
        if (firstAamsLocation != null) return firstAamsLocation;

        StackTraceElement[] st = ex.getStackTrace();
        if (st != null && st.length > 0) {
            return String.format("%s.%s (%s:%d)", st[0].getClassName(), st[0].getMethodName(), st[0].getFileName(), st[0].getLineNumber());
        }

        return "스택 추적 불가";
    }

    /**
     * 4. MyBatis 매퍼 및 SQL 오류 정보 추출
     */
    public static String extractMyBatisInfo(Throwable ex) {
        if (ex == null) return "";

        StringBuilder result = new StringBuilder();
        Throwable current = ex;

        while (current != null) {
            String msg = current.getMessage();
            if (msg != null && msg.contains("###")) {
                Matcher statementMatcher = MYBATIS_STATEMENT_PATTERN.matcher(msg);
                if (statementMatcher.find()) {
                    result.append("Statement: ").append(statementMatcher.group(1).trim()).append(" | ");
                }

                Matcher xmlMatcher = MYBATIS_XML_PATTERN.matcher(msg);
                if (xmlMatcher.find()) {
                    result.append("XML: ").append(xmlMatcher.group(1).trim()).append(" | ");
                }

                Matcher sqlMatcher = MYBATIS_SQL_PATTERN.matcher(msg);
                if (sqlMatcher.find()) {
                    String sql = sqlMatcher.group(1).trim();
                    if (sql.length() > 200) sql = sql.substring(0, 200) + "... (생략)";
                    result.append("SQL: [").append(sql).append("] | ");
                }

                Matcher causeMatcher = MYBATIS_CAUSE_PATTERN.matcher(msg);
                if (causeMatcher.find()) {
                    result.append("Cause: ").append(causeMatcher.group(1).trim());
                }
                break;
            }
            current = current.getCause();
        }

        return result.toString().trim();
    }

    /**
     * 5. 요청 파라미터 (Query/Form 파라미터 및 @RequestBody JSON) 추출 및 민감정보 마스킹
     */
    public static String extractParametersInfo(HttpServletRequest request) {
        if (request == null) return "None";

        Map<String, Object> allParams = new LinkedHashMap<>();

        // 5-1. Query String / Form Parameters
        Map<String, String[]> paramMap = request.getParameterMap();
        if (paramMap != null && !paramMap.isEmpty()) {
            Map<String, Object> queryParams = new LinkedHashMap<>();
            for (Map.Entry<String, String[]> entry : paramMap.entrySet()) {
                String key = entry.getKey();
                String[] values = entry.getValue();

                if (isSensitiveKey(key)) {
                    queryParams.put(key, "******");
                } else if (values != null && values.length == 1) {
                    queryParams.put(key, values[0]);
                } else {
                    queryParams.put(key, Arrays.toString(values));
                }
            }
            allParams.put("QueryParams", queryParams);
        }

        // 5-2. Cached @RequestBody Parameter
        Object cachedBody = request.getAttribute(RequestBodyCachingAdvice.CACHED_REQUEST_BODY_ATTR);
        if (cachedBody != null) {
            try {
                String bodyJson = OBJECT_MAPPER.writeValueAsString(cachedBody);
                bodyJson = maskSensitiveJson(bodyJson);
                allParams.put("RequestBody", bodyJson);
            } catch (Exception e) {
                allParams.put("RequestBody", String.valueOf(cachedBody));
            }
        }

        if (allParams.isEmpty()) {
            return "(전달된 파라미터 없음)";
        }

        try {
            return OBJECT_MAPPER.writeValueAsString(allParams);
        } catch (Exception e) {
            return allParams.toString();
        }
    }

    private static boolean isSensitiveKey(String key) {
        if (key == null) return false;
        String lower = key.toLowerCase().replaceAll("[^a-z]", "");
        for (String sensitive : SENSITIVE_KEYS) {
            if (lower.contains(sensitive)) return true;
        }
        return false;
    }

    private static String maskSensitiveJson(String json) {
        if (json == null) return null;
        for (String sensitive : SENSITIVE_KEYS) {
            json = json.replaceAll("(?i)(\"" + sensitive + "\"[\\s]*:[\\s]*\")([^\"]*)(\")", "$1******$3");
        }
        return json;
    }

    private static Throwable getRootCause(Throwable t) {
        Throwable root = t;
        while (root.getCause() != null && root.getCause() != root) {
            root = root.getCause();
        }
        return root;
    }
}
