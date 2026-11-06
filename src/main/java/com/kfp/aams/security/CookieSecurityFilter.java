package com.kfp.aams.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Locale;

/**
 * Adds uniform browser cookie transport attributes to every Set-Cookie response header.
 * The secure flag is automatic: enabled for HTTPS requests and disabled only for local HTTP
 * development unless the deployment explicitly forces it on or off.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class CookieSecurityFilter extends OncePerRequestFilter {

    private final String secureMode;
    private final String sameSite;

    public CookieSecurityFilter(
            @Value("${app.security.cookie.secure:auto}") String secureMode,
            @Value("${app.security.cookie.same-site:Lax}") String sameSite
    ) {
        this.secureMode = secureMode;
        this.sameSite = sameSite;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {
        filterChain.doFilter(request, new CookieSecurityResponseWrapper(response, isSecureCookieRequired(request), sameSite));
    }

    private boolean isSecureCookieRequired(HttpServletRequest request) {
        if ("true".equalsIgnoreCase(secureMode)) {
            return true;
        }
        if ("false".equalsIgnoreCase(secureMode)) {
            return false;
        }
        return request.isSecure();
    }

    private static final class CookieSecurityResponseWrapper extends HttpServletResponseWrapper {

        private final boolean secure;
        private final String sameSite;

        private CookieSecurityResponseWrapper(HttpServletResponse response, boolean secure, String sameSite) {
            super(response);
            this.secure = secure;
            this.sameSite = sameSite;
        }

        @Override
        public void addHeader(String name, String value) {
            super.addHeader(name, secureSetCookie(name, value));
        }

        @Override
        public void addCookie(Cookie cookie) {
            if (cookie != null) {
                if (secure) {
                    cookie.setSecure(true);
                }
                if (!cookie.getAttributes().containsKey("SameSite")) {
                    cookie.setAttribute("SameSite", sameSite);
                }
            }
            super.addCookie(cookie);
        }

        @Override
        public void setHeader(String name, String value) {
            super.setHeader(name, secureSetCookie(name, value));
        }

        private String secureSetCookie(String name, String value) {
            if (name == null || !"set-cookie".equals(name.toLowerCase(Locale.ROOT)) || value == null) {
                return value;
            }

            String normalized = value.toLowerCase(Locale.ROOT);
            String result = value;
            if (secure && !normalized.contains("; secure")) {
                result += "; Secure";
                normalized += "; secure";
            }
            if (!normalized.contains("; samesite=")) {
                result += "; SameSite=" + sameSite;
            }
            return result;
        }
    }
}
