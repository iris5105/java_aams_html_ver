package com.kfp.aams.security.crypto;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.MethodParameter;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

import java.util.Collections;
import java.util.Map;

/**
 * EncryptedResponseBodyAdvice
 * REST API(/api/**) 응답 본문을 AES-256으로 자동 암호화하여
 * {"encData": "..."} 형태로 반환하는 ResponseBodyAdvice
 */
@Slf4j
@ControllerAdvice
@RequiredArgsConstructor
public class EncryptedResponseBodyAdvice implements ResponseBodyAdvice<Object> {

    private final CryptoProperties cryptoProperties;
    private final CryptoUtil cryptoUtil;
    private final ObjectMapper objectMapper;

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        // 암호화 기능이 활성화된 경우에만 동작 (운영 또는 Linux 환경)
        if (!cryptoProperties.isEncryptionEnabled()) {
            return false;
        }

        // Jackson JSON 변환기 대상만 지원
        if (!MappingJackson2HttpMessageConverter.class.isAssignableFrom(converterType)) {
            return false;
        }

        // 바이너리/파일 리소스 제외
        Class<?> paramType = returnType.getParameterType();
        if (byte[].class.isAssignableFrom(paramType) || Resource.class.isAssignableFrom(paramType)) {
            return false;
        }

        return true;
    }

    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType selectedContentType,
                                  Class<? extends HttpMessageConverter<?>> selectedConverterType,
                                  ServerHttpRequest request, ServerHttpResponse response) {

        if (body == null) {
            return null;
        }

        // 이미 암호화 래핑된 경우 건너뜀
        if (body instanceof Map<?, ?> map && map.containsKey("encData")) {
            return body;
        }

        String uri = request.getURI().getPath();
        // /api/** 엔드포인트만 암호화 대상
        if (uri == null || !uri.startsWith("/api/")) {
            return body;
        }

        // 제외 대상 확인 (보안설정 조회, RD 리포트 내보내기 바이너리 등)
        if (uri.contains("/security-config") || uri.contains("/export") || uri.contains("/download")) {
            return body;
        }

        try {
            String json = objectMapper.writeValueAsString(body);
            String encrypted = cryptoUtil.encrypt(json);

            response.getHeaders().add("X-AAMS-Encrypted", "true");
            return Collections.singletonMap("encData", encrypted);
        } catch (Exception e) {
            log.error("[EncryptedResponseBodyAdvice] Failed to encrypt response for URI [{}]: {}", uri, e.getMessage());
            return body;
        }
    }
}
