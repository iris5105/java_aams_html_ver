package com.kfp.aams.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.util.HashMap;
import java.util.Map;

/**
 * Global Exception Handler
 * Intercepts unhandled exceptions, logs full stack traces,
 * and handles REST API (JSON) vs View (HTML) error responses without media type mismatch errors.
 */
@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 정적 자원(예: favicon.ico, 누락된 정적 리소스 등) 미존재 시 404를 반환하고,
     * 불필요한 500 ERROR 풀 스택 트레이스 로그 발생을 방지합니다.
     */
    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<Void> handleNoResourceFound(NoResourceFoundException ex, HttpServletRequest request) {
        log.debug("Static resource not found at [{}]: {}", request.getRequestURI(), ex.getMessage());
        return ResponseEntity.notFound().build();
    }

    @ExceptionHandler(Exception.class)
    public Object handleAllExceptions(Exception ex, HttpServletRequest request, HttpServletResponse response) {
        log.error("Unhandled Exception at [{}] : {}", request.getRequestURI(), ex.getMessage(), ex);

        String uri = request.getRequestURI();
        boolean isApiRequest = uri.startsWith("/api/") ||
                               "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With")) ||
                               (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));

        if (isApiRequest) {
            Map<String, Object> body = new HashMap<>();
            body.put("success", false);
            body.put("status", 500);
            body.put("error", "Internal Server Error");
            body.put("message", ex.getMessage() != null ? ex.getMessage() : "서버 처리 중 오류가 발생했습니다.");
            body.put("path", uri);

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(body);
        } else {
            // HTML View Requests: Return error view cleanly
            if (!response.isCommitted()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            ModelAndView mav = new ModelAndView();
            mav.addObject("errorMessage", ex.getMessage());
            mav.addObject("path", uri);
            mav.setViewName("error");
            return mav;
        }
    }
}
