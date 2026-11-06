package com.kfp.aams.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * Routes browser data-read POST requests to the existing GET query handlers.
 *
 * <p>The client sends query conditions as an application/x-www-form-urlencoded POST body
 * with {@value #READ_POST_HEADER}. The wrapper keeps the established {@code @GetMapping}
 * controller contracts and {@code @RequestParam} binding intact while the network request
 * itself is POST and contains no URL query string.</p>
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 6)
public class PostReadApiRequestFilter extends OncePerRequestFilter {

    public static final String READ_POST_HEADER = "X-Aams-Read-Post";

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        return !"POST".equalsIgnoreCase(request.getMethod())
                || !request.getRequestURI().startsWith(request.getContextPath() + "/api/")
                || !"true".equalsIgnoreCase(request.getHeader(READ_POST_HEADER));
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {
        filterChain.doFilter(new ReadPostRequestWrapper(request), response);
    }

    private static final class ReadPostRequestWrapper extends HttpServletRequestWrapper {

        private ReadPostRequestWrapper(HttpServletRequest request) {
            super(request);
        }

        @Override
        public String getMethod() {
            return "GET";
        }
    }
}
