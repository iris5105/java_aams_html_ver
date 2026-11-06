package com.kfp.aams.security;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.core.MethodParameter;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.RequestBodyAdviceAdapter;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Verifies every {@code corpGr}/{@code corp_gr} value contained in a JSON request body.
 */
@ControllerAdvice
@RequiredArgsConstructor
public class CompanyGroupRequestBodyAdvice extends RequestBodyAdviceAdapter {

    private final ObjectMapper objectMapper;
    private final CompanyGroupAuthorizationService companyGroupAuthorizationService;

    @Override
    public boolean supports(
            MethodParameter methodParameter,
            Type targetType,
            Class<? extends HttpMessageConverter<?>> converterType
    ) {
        return true;
    }

    @Override
    public Object afterBodyRead(
            Object body,
            org.springframework.http.HttpInputMessage inputMessage,
            MethodParameter parameter,
            Type targetType,
            Class<? extends HttpMessageConverter<?>> converterType
    ) {
        UserPrincipal principal = getPrincipal();
        if (principal == null || body == null) {
            return body;
        }

        List<String> requestedCorpGrs = new ArrayList<>();
        collectCorpGrValues(objectMapper.valueToTree(body), requestedCorpGrs);
        companyGroupAuthorizationService.assertAuthorized(principal, requestedCorpGrs);
        return body;
    }

    private void collectCorpGrValues(JsonNode node, List<String> values) {
        if (node == null || node.isNull()) {
            return;
        }
        if (node.isArray()) {
            for (JsonNode element : node) {
                collectCorpGrValues(element, values);
            }
            return;
        }
        if (!node.isObject()) {
            return;
        }

        Iterator<Map.Entry<String, JsonNode>> fields = node.fields();
        while (fields.hasNext()) {
            Map.Entry<String, JsonNode> field = fields.next();
            if (isCorpGrName(field.getKey()) && field.getValue().isValueNode()) {
                values.add(field.getValue().asText());
            }
            collectCorpGrValues(field.getValue(), values);
        }
    }

    private UserPrincipal getPrincipal() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UserPrincipal principal) {
            return principal;
        }
        return null;
    }

    private boolean isCorpGrName(String name) {
        String normalized = name == null ? "" : name.replace("_", "").toLowerCase(Locale.ROOT);
        return "corpgr".equals(normalized);
    }
}
