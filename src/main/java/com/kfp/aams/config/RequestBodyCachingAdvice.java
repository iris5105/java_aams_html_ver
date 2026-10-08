package com.kfp.aams.config;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.core.MethodParameter;
import org.springframework.http.HttpInputMessage;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.mvc.method.annotation.RequestBodyAdviceAdapter;

import java.lang.reflect.Type;

/**
 * Controller로 전달되는 @RequestBody 파라미터 객체를 HttpServletRequest 속성에 캐싱하여,
 * 오류 발생 시 GlobalExceptionHandler에서 요청 파라미터를 상세 로그에 남길 수 있도록 지원합니다.
 */
@ControllerAdvice
public class RequestBodyCachingAdvice extends RequestBodyAdviceAdapter {

    public static final String CACHED_REQUEST_BODY_ATTR = "AAMS_CACHED_REQUEST_BODY";

    @Override
    public boolean supports(MethodParameter methodParameter, Type targetType,
                            Class<? extends HttpMessageConverter<?>> converterType) {
        return true;
    }

    @Override
    public Object afterBodyRead(Object body, HttpInputMessage inputMessage, MethodParameter parameter,
                                Type targetType, Class<? extends HttpMessageConverter<?>> converterType) {
        try {
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes != null) {
                HttpServletRequest request = attributes.getRequest();
                if (request != null) {
                    request.setAttribute(CACHED_REQUEST_BODY_ATTR, body);
                }
            }
        } catch (Exception ignored) {
            // 캐싱 실패 시 정상 비즈니스 로직에 영향 없도록 무시
        }
        return super.afterBodyRead(body, inputMessage, parameter, targetType, converterType);
    }
}
