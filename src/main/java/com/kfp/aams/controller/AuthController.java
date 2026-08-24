package com.kfp.aams.controller;

import com.kfp.aams.dto.LoginRequestDto;
import com.kfp.aams.dto.LoginResponseDto;
import com.kfp.aams.dto.UserDto;
import com.kfp.aams.repository.UserQueryDslRepository;
import com.kfp.aams.security.JwtProvider;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AuthController {

    private final JwtProvider jwtProvider;
    private final UserQueryDslRepository userQueryDslRepository;

    @GetMapping({"/login", "/w_login_aams"})
    public String loginPage() {
        return "w_login_aams";
    }

    @GetMapping("/api/auth/check-user-info")
    @ResponseBody
    public ResponseEntity<?> checkUserInfo(@RequestParam(name = "userId", required = false) String userId) {
        if (userId == null || userId.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("exists", false, "message", "아이디를 입력해주세요."));
        }
        UserDto userDto = userQueryDslRepository.findUserRoleAndCorpGr(userId.trim());
        if (userDto == null) {
            return ResponseEntity.ok(Map.of("exists", false));
        }
        return ResponseEntity.ok(Map.of(
                "exists", true,
                "userId", userDto.getUserId() != null ? userDto.getUserId() : "",
                "corpGr", userDto.getCorpGr() != null ? userDto.getCorpGr() : "",
                "adminYn", userDto.getAdminYn() != null ? userDto.getAdminYn() : "N"
        ));
    }

    @PostMapping("/api/auth/login")
    @ResponseBody
    public ResponseEntity<LoginResponseDto> login(@RequestBody LoginRequestDto request, HttpServletRequest httpRequest, HttpServletResponse response) {
        String userId = request.getUserId();
        String password = request.getPassword();

        if (userId == null || userId.isBlank()) {
            return ResponseEntity.badRequest().body(LoginResponseDto.builder()
                    .success(false)
                    .message("아이디를 입력해주세요.")
                    .build());
        }

        // Query user info from FW_USER_MST via QueryDSL Repository
        UserDto userDto = null;
        try {
            userDto = userQueryDslRepository.findUserForLogin(userId, password);
        } catch (Exception e) {
            log.warn("DB user query for userId {} failed: {}", userId, e.getMessage());
        }

        // If user not found in FW_USER_MST or corpGr is missing, fail login
        if (userDto == null || userDto.getCorpGr() == null || userDto.getCorpGr().isBlank()) {
            return ResponseEntity.badRequest().body(LoginResponseDto.builder()
                    .success(false)
                    .message("가입되지 않은 회원이거나 아이디/비밀번호가 올바르지 않습니다.")
                    .build());
        }

        // Admin check for corpGr: If admin (adminYn == 'Y'), use savedCorpGr cookie if present; if non-admin (adminYn == 'N'), use user's DB corpGr
        String effectiveCorpGr = userDto.getCorpGr();
        boolean isAdmin = "Y".equalsIgnoreCase(userDto.getAdminYn());
        if (isAdmin && httpRequest != null && httpRequest.getCookies() != null) {
            for (Cookie c : httpRequest.getCookies()) {
                if ("savedCorpGr".equals(c.getName()) && c.getValue() != null && !c.getValue().isBlank()) {
                    effectiveCorpGr = c.getValue();
                    break;
                }
            }
        }
        userDto.setCorpGr(effectiveCorpGr);

        // Issue JWT Access Token (with all UserDto claims) and Refresh Token (1 week)
        String accessToken = jwtProvider.createAccessToken(userDto);
        String refreshToken = jwtProvider.createRefreshToken(userDto.getUserId(), userDto.getCorpGr());

        // Store user in SecurityContextHolder
        UserPrincipal principal = new UserPrincipal(userDto);
        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(principal, null, principal.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authentication);

        // Set Access Token Cookie (30 mins = 1800s)
        Cookie accessCookie = new Cookie("accessToken", accessToken);
        accessCookie.setHttpOnly(true);
        accessCookie.setPath("/");
        accessCookie.setMaxAge(30 * 60);
        response.addCookie(accessCookie);

        // Set Refresh Token Cookie (1 week = 604800s)
        Cookie refreshCookie = new Cookie("refreshToken", refreshToken);
        refreshCookie.setHttpOnly(true);
        refreshCookie.setPath("/");
        refreshCookie.setMaxAge(7 * 24 * 60 * 60);
        response.addCookie(refreshCookie);

        // Set savedEmail Cookie for login auto-fill (30 days)
        if (userDto.getEncEMail() != null && !userDto.getEncEMail().isBlank()) {
            Cookie savedEmailCookie = new Cookie("savedEmail", userDto.getEncEMail());
            savedEmailCookie.setPath("/");
            savedEmailCookie.setMaxAge(30 * 24 * 60 * 60);
            response.addCookie(savedEmailCookie);
        }

        // Set savedCorpGr Cookie for login logo & active corpGr (30 days)
        if (userDto.getCorpGr() != null && !userDto.getCorpGr().isBlank()) {
            Cookie savedCorpGrCookie = new Cookie("savedCorpGr", userDto.getCorpGr());
            savedCorpGrCookie.setPath("/");
            savedCorpGrCookie.setMaxAge(30 * 24 * 60 * 60);
            response.addCookie(savedCorpGrCookie);
        }

        log.info("User {} logged in successfully (adminYn: {}). Assigned corpGr: {}.", userDto.getUserId(), userDto.getAdminYn(), userDto.getCorpGr());

        return ResponseEntity.ok(LoginResponseDto.builder()
                .success(true)
                .message("로그인 성공")
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .userId(userDto.getUserId())
                .corpGr(userDto.getCorpGr())
                .encEMail(userDto.getEncEMail())
                .companyName(userDto.getCompanyName())
                .hyunYmd(userDto.getHyunYmd())
                .customerGr(userDto.getCustomerGr())
                .build());
    }

    @PostMapping("/api/auth/switch-company")
    @ResponseBody
    public ResponseEntity<?> switchCompany(@RequestBody Map<String, String> request,
                                           @AuthenticationPrincipal UserPrincipal principal,
                                           HttpServletResponse response) {
        if (principal == null || principal.getAdminYn() == null || !"Y".equalsIgnoreCase(principal.getAdminYn().trim())) {
            return ResponseEntity.status(403).body(Map.of("success", false, "message", "관리자 권한이 필요합니다."));
        }

        String newCorpGr = request != null ? request.get("corpGr") : null;
        if (newCorpGr == null || newCorpGr.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "변경할 회사 코드가 필요합니다."));
        }

        UserDto updatedUserDto = UserDto.builder()
                .userId(principal.getUserId())
                .userNm(principal.getUserNm())
                .outYmd(principal.getOutYmd())
                .deptCd(principal.getDeptCd())
                .deptNm(principal.getDeptNm())
                .inYmd(principal.getInYmd())
                .corpGr(newCorpGr)
                .adminYn(principal.getAdminYn())
                .managerYn(principal.getManagerYn())
                .watchmanYn(principal.getWatchmanYn())
                .bookmarkStart(principal.getBookmarkStart())
                .lastConnect(principal.getLastConnect())
                .encEMail(principal.getEncEMail())
                .companyName(principal.getCompanyName())
                .hyunYmd(principal.getHyunYmd())
                .customerGr(principal.getCustomerGr())
                .build();

        String newAccessToken = jwtProvider.createAccessToken(updatedUserDto);
        String newRefreshToken = jwtProvider.createRefreshToken(principal.getUserId(), newCorpGr);

        UserPrincipal updatedPrincipal = new UserPrincipal(updatedUserDto);
        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(updatedPrincipal, null, updatedPrincipal.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authentication);

        Cookie accessCookie = new Cookie("accessToken", newAccessToken);
        accessCookie.setHttpOnly(true);
        accessCookie.setPath("/");
        accessCookie.setMaxAge(30 * 60);
        response.addCookie(accessCookie);

        Cookie refreshCookie = new Cookie("refreshToken", newRefreshToken);
        refreshCookie.setHttpOnly(true);
        refreshCookie.setPath("/");
        refreshCookie.setMaxAge(7 * 24 * 60 * 60);
        response.addCookie(refreshCookie);

        Cookie savedCorpGrCookie = new Cookie("savedCorpGr", newCorpGr);
        savedCorpGrCookie.setPath("/");
        savedCorpGrCookie.setMaxAge(30 * 24 * 60 * 60);
        response.addCookie(savedCorpGrCookie);

        log.info("User {} switched company corpGr to {}", principal.getUserId(), newCorpGr);

        return ResponseEntity.ok(Map.of("success", true, "corpGr", newCorpGr));
    }

    @PostMapping("/api/auth/logout")
    @ResponseBody
    public ResponseEntity<LoginResponseDto> logout(HttpServletResponse response) {
        SecurityContextHolder.clearContext();

        Cookie accessCookie = new Cookie("accessToken", null);
        accessCookie.setHttpOnly(true);
        accessCookie.setPath("/");
        accessCookie.setMaxAge(0);
        response.addCookie(accessCookie);

        Cookie refreshCookie = new Cookie("refreshToken", null);
        refreshCookie.setHttpOnly(true);
        refreshCookie.setPath("/");
        refreshCookie.setMaxAge(0);
        response.addCookie(refreshCookie);

        return ResponseEntity.ok(LoginResponseDto.builder()
                .success(true)
                .message("로그아웃 되었습니다.")
                .build());
    }
}
