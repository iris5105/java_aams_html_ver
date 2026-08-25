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
            // HTML View Requests: Reset buffer & return error view cleanly
            if (!response.isCommitted()) {
                response.resetBuffer();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("text/html;charset=UTF-8");
            }
            ModelAndView mav = new ModelAndView();
            mav.addObject("errorMessage", ex.getMessage());
            mav.addObject("path", uri);
            mav.setViewName("error");
            return mav;
        }
    }
}
