package com.kfp.aams.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * Applies primary action authorization before a mutation controller executes.
 * Embedded deleted rows are checked by ProgramActionRequestBodyAdvice.
 */
@Component
@RequiredArgsConstructor
public class ProgramActionAuthorizationInterceptor implements HandlerInterceptor {

    private final ProgramActionAuthorizationService authorizationService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        if (!isProgramMutationRequest(request)) {
            return true;
        }

        authorizationService.assertMutationAuthorized(
                SecurityPrincipalResolver.getPrincipal(), request.getRequestURI());
        return true;
    }

    private boolean isProgramMutationRequest(HttpServletRequest request) {
        String uri = request.getRequestURI();
        if (uri == null || !uri.startsWith(request.getContextPath() + "/api/")) {
            return false;
        }
        if (uri.startsWith(request.getContextPath() + "/api/auth/")
                || uri.startsWith(request.getContextPath() + "/api/common/")) {
            return false;
        }
        String method = request.getMethod();
        boolean mutationMethod = HttpMethod.POST.matches(method)
                || HttpMethod.PUT.matches(method)
                || HttpMethod.PATCH.matches(method)
                || HttpMethod.DELETE.matches(method);
        return mutationMethod && authorizationService.supportsProgramUri(uri);
    }
}
