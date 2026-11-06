package com.kfp.aams.security;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Verifies company-group values supplied in API query/form parameters and relevant cookies.
 * JSON request bodies are checked by {@link CompanyGroupRequestBodyAdvice} after deserialization.
 */
@Component
@RequiredArgsConstructor
public class CompanyGroupAuthorizationInterceptor implements HandlerInterceptor {

    private final CompanyGroupAuthorizationService companyGroupAuthorizationService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        if (!request.getRequestURI().startsWith(request.getContextPath() + "/api/")) {
            return true;
        }

        UserPrincipal principal = getPrincipal();
        if (principal == null) {
            // Authentication exceptions are handled by Spring Security. This also keeps the
            // explicitly public login endpoints usable before a principal exists.
            return true;
        }

        List<String> requestedCorpGrs = new ArrayList<>();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            if (isCorpGrName(entry.getKey()) && entry.getValue() != null) {
                for (String value : entry.getValue()) {
                    requestedCorpGrs.add(value);
                }
            }
        }

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (isCorpGrName(cookie.getName())) {
                    requestedCorpGrs.add(cookie.getValue());
                }
            }
        }

        companyGroupAuthorizationService.assertAuthorized(principal, requestedCorpGrs);
        return true;
    }

    private UserPrincipal getPrincipal() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UserPrincipal principal) {
            return principal;
        }
        return null;
    }

    private boolean isCorpGrName(String name) {
        if (name == null) {
            return false;
        }
        String normalized = name.replace("_", "").toLowerCase(Locale.ROOT);
        return "corpgr".equals(normalized)
                || "savedcorpgr".equals(normalized)
                || "usercorpgr".equals(normalized);
    }
}
