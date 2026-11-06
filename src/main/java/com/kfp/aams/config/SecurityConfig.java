package com.kfp.aams.config;

import com.kfp.aams.security.JwtAuthenticationEntryPoint;
import com.kfp.aams.security.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.csrf.CsrfTokenRequestAttributeHandler;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration(proxyBeanMethods = false)
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        CookieCsrfTokenRepository csrfTokenRepository = CookieCsrfTokenRepository.withHttpOnlyFalse();
        CsrfTokenRequestAttributeHandler csrfTokenRequestHandler = new CsrfTokenRequestAttributeHandler();

        http
                .csrf(csrf -> csrf
                        .csrfTokenRepository(csrfTokenRepository)
                        // XSRF-TOKEN Cookie is read by the browser and sent as the
                        // X-XSRF-TOKEN header. Use the raw-token handler so the cookie
                        // value is accepted as-is instead of expecting an XOR-masked value.
                        .csrfTokenRequestHandler(csrfTokenRequestHandler)
                        // Authentication starts before a CSRF token exists. The user-info
                        // endpoint is a read-only login helper that the common fetch layer
                        // transparently sends as POST.
                        .ignoringRequestMatchers("/api/auth/login", "/api/auth/check-user-info", "/api/common/security-config"))
                .headers(headers -> headers.frameOptions(frameOptions -> frameOptions.disable()))
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .exceptionHandling(exception -> exception.authenticationEntryPoint(jwtAuthenticationEntryPoint))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/", "/home", "/w_home5", "/login", "/w_login_aams", "/css/**",
                                "/js/**", "/images/**", "/img/**", "/h2-console/**", "/favicon.ico", "/favicon.svg", "/error", "/w_*")
                        .permitAll()
                        // Login starts without an authenticated principal. The GET endpoint is
                        // transparently sent as POST by the common API read-request interceptor.
                        .requestMatchers("/api/auth/login", "/api/auth/check-user-info", "/api/common/security-config")
                        .permitAll()
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        .anyRequest().authenticated())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
