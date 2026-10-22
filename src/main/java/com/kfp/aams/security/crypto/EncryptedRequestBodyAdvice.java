package com.kfp.aams.security.crypto;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.MethodParameter;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpInputMessage;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.RequestBodyAdviceAdapter;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Type;
import java.nio.charset.StandardCharsets;

/**
 * EncryptedRequestBodyAdvice
 * POST/PUT 요청 시 클라이언트가 {"encData": "..."} 형태로 전송한 암호화 본문을
 * 자동으로 복호화하여 컨트롤러 DTO에 매핑되도록 지원하는 ControllerAdvice
 */
@Slf4j
@ControllerAdvice
@RequiredArgsConstructor
public class EncryptedRequestBodyAdvice extends RequestBodyAdviceAdapter {

    private final CryptoUtil cryptoUtil;
    private final ObjectMapper objectMapper;

    @Override
    public boolean supports(MethodParameter methodParameter, Type targetType, Class<? extends HttpMessageConverter<?>> converterType) {
        return true;
    }

    @Override
    public HttpInputMessage beforeBodyRead(HttpInputMessage inputMessage, MethodParameter parameter, Type targetType, Class<? extends HttpMessageConverter<?>> converterType) throws IOException {
        byte[] body = inputMessage.getBody().readAllBytes();
        if (body.length == 0) {
            return inputMessage;
        }

        String bodyStr = new String(body, StandardCharsets.UTF_8).trim();
        if (bodyStr.startsWith("{") && bodyStr.contains("\"encData\"")) {
            try {
                JsonNode root = objectMapper.readTree(bodyStr);
                if (root.has("encData")) {
                    String encData = root.get("encData").asText();
                    String decryptedJson = cryptoUtil.decrypt(encData);
                    byte[] decryptedBytes = decryptedJson.getBytes(StandardCharsets.UTF_8);

                    return new HttpInputMessage() {
                        @Override
                        public InputStream getBody() {
                            return new ByteArrayInputStream(decryptedBytes);
                        }

                        @Override
                        public HttpHeaders getHeaders() {
                            return inputMessage.getHeaders();
                        }
                    };
                }
            } catch (Exception e) {
                log.error("[EncryptedRequestBodyAdvice] Failed to decrypt request body: {}", e.getMessage());
            }
        }

        // 평문 요청인 경우 원본 스트림 반환
        return new HttpInputMessage() {
            @Override
            public InputStream getBody() {
                return new ByteArrayInputStream(body);
            }

            @Override
            public HttpHeaders getHeaders() {
                return inputMessage.getHeaders();
            }
        };
    }
}
