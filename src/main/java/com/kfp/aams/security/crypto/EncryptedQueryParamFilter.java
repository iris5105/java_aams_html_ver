package com.kfp.aams.security.crypto;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * EncryptedQueryParamFilter
 * URL 쿼리 파라미터에 '_enc' 암호화 매개변수가 포함된 경우,
 * 이를 복호화하여 원래 파라미터들(corpGr, ymd 등)로 복원하는 RequestWrapper 필터
 */
@Slf4j
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 5)
@RequiredArgsConstructor
public class EncryptedQueryParamFilter extends OncePerRequestFilter {

    private final CryptoUtil cryptoUtil;
    private static final String ENC_PARAM_NAME = "_enc";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String encParam = request.getParameter(ENC_PARAM_NAME);

        if (StringUtils.hasText(encParam)) {
            try {
                // _enc 복호화
                String decryptedQuery = cryptoUtil.decrypt(encParam);
                log.debug("[EncryptedQueryParamFilter] Decrypted '_enc' for URI [{}]: {}",
                        request.getRequestURI(), decryptedQuery);

                if (StringUtils.hasText(decryptedQuery)) {
                    Map<String, String[]> decryptedParams = parseQueryString(decryptedQuery);
                    // 기존 파라미터와 병합 (원래 있던 다른 파라미터 유지)
                    Map<String, String[]> mergedParams = new HashMap<>(request.getParameterMap());
                    mergedParams.remove(ENC_PARAM_NAME);
                    mergedParams.putAll(decryptedParams);

                    HttpServletRequest wrappedRequest = new DecryptedRequestWrapper(request, mergedParams, decryptedQuery);
                    filterChain.doFilter(wrappedRequest, response);
                    return;
                }
            } catch (Exception e) {
                log.error("[EncryptedQueryParamFilter] Failed to decrypt query param for [{}]: {}",
                        request.getRequestURI(), e.getMessage());
            }
        }

        filterChain.doFilter(request, response);
    }

    /**
     * "key1=val1&key2=val2" 형태의 쿼리스트링 파싱
     */
    private Map<String, String[]> parseQueryString(String queryString) {
        Map<String, List<String>> temp = new LinkedHashMap<>();
        String[] pairs = queryString.split("&");
        for (String pair : pairs) {
            if (pair.isBlank()) continue;
            int idx = pair.indexOf('=');
            String key;
            String val = "";
            if (idx > 0) {
                key = URLDecoder.decode(pair.substring(0, idx), StandardCharsets.UTF_8);
                val = URLDecoder.decode(pair.substring(idx + 1), StandardCharsets.UTF_8);
            } else {
                key = URLDecoder.decode(pair, StandardCharsets.UTF_8);
            }

            temp.computeIfAbsent(key, k -> new ArrayList<>()).add(val);
        }

        Map<String, String[]> result = new LinkedHashMap<>();
        temp.forEach((k, v) -> result.put(k, v.toArray(new String[0])));
        return result;
    }

    /**
     * 복호화된 파라미터들을 제공하는 HttpServletRequestWrapper
     */
    private static class DecryptedRequestWrapper extends HttpServletRequestWrapper {
        private final Map<String, String[]> parameterMap;
        private final String decryptedQueryString;

        public DecryptedRequestWrapper(HttpServletRequest request, Map<String, String[]> parameterMap, String decryptedQueryString) {
            super(request);
            this.parameterMap = Collections.unmodifiableMap(parameterMap);
            this.decryptedQueryString = decryptedQueryString;
        }

        @Override
        public String getParameter(String name) {
            String[] values = parameterMap.get(name);
            return (values != null && values.length > 0) ? values[0] : null;
        }

        @Override
        public Map<String, String[]> getParameterMap() {
            return parameterMap;
        }

        @Override
        public Enumeration<String> getParameterNames() {
            return Collections.enumeration(parameterMap.keySet());
        }

        @Override
        public String[] getParameterValues(String name) {
            return parameterMap.get(name);
        }

        @Override
        public String getQueryString() {
            return decryptedQueryString != null ? decryptedQueryString : super.getQueryString();
        }
    }
}
