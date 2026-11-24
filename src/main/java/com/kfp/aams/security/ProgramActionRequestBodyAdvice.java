package com.kfp.aams.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.core.MethodParameter;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.stereotype.ControllerAdvice;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.servlet.mvc.method.annotation.RequestBodyAdviceAdapter;

import java.lang.reflect.Type;

/**
 * Requires DELETE permission when a JSON mutation payload contains deleted rows.
 */
@ControllerAdvice
@RequiredArgsConstructor
public class ProgramActionRequestBodyAdvice extends RequestBodyAdviceAdapter {

    private final ObjectMapper objectMapper;
    private final ProgramActionAuthorizationService authorizationService;
    private final HttpServletRequest request;

    @Override
    public boolean supports(
            MethodParameter methodParameter,
            Type targetType,
            Class<? extends HttpMessageConverter<?>> converterType
    ) {
        return methodParameter.hasParameterAnnotation(RequestBody.class)
                && isProgramMutationRequest();
    }

    @Override
    public Object afterBodyRead(
            Object body,
            org.springframework.http.HttpInputMessage inputMessage,
            MethodParameter parameter,
            Type targetType,
            Class<? extends HttpMessageConverter<?>> converterType
    ) {
        authorizationService.assertPayloadAuthorized(
                SecurityPrincipalResolver.getPrincipal(),
                request.getRequestURI(),
                objectMapper.valueToTree(body));
        return body;
    }

    private boolean isProgramMutationRequest() {
        String uri = request.getRequestURI();
        if (uri == null || !uri.startsWith(request.getContextPath() + "/api/")) {
            return false;
        }
        if (uri.startsWith(request.getContextPath() + "/api/auth/")
                || uri.startsWith(request.getContextPath() + "/api/common/")) {
            return false;
        }
        String method = request.getMethod();
        boolean mutationMethod = "POST".equalsIgnoreCase(method)
                || "PUT".equalsIgnoreCase(method)
                || "PATCH".equalsIgnoreCase(method)
                || "DELETE".equalsIgnoreCase(method);
        return mutationMethod && authorizationService.supportsProgramUri(uri);
    }
}
