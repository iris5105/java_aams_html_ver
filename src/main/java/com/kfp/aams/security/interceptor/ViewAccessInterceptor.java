package com.kfp.aams.security.interceptor;

import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * ViewAccessInterceptor
 * 사용자가 브라우저 URL 주소창 직접 입력 또는 비정상적인 경로로 화면(/views/**)에 접근할 때,
 * 사용자 접근 권한(FW_ROLE_PGM)과 비교하여 접근 허용 여부를 검증하고 차단하는 인터셉터
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ViewAccessInterceptor implements HandlerInterceptor {

    private final MenuService menuService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();

        // 1. 공통 및 예외 경로 2차 방어 (화이트리스트)
        if (uri.startsWith("/views/common/") || uri.equals("/error")) {
            return true;
        }

        // 2. 인증 사용자(UserPrincipal) 확인
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal() instanceof UserPrincipal principal)) {
            log.warn("[ViewAccessInterceptor] Unauthenticated access attempt to view: {}", uri);
            handleUnauthenticated(request, response);
            return false;
        }

        // 3. 슈퍼관리자(Admin) 권한 패스
        if ("Y".equalsIgnoreCase(principal.getAdminYn())) {
            return true;
        }

        // 4. 대상 프로그램 식별자(PGM_ID / PGM_GO) 추출
        String targetId = extractTargetProgramId(uri);
        if (targetId == null || targetId.isBlank()) {
            return true;
        }

        // 5. 사용자의 허용 프로그램 Set 취득 (세션 캐싱)
        String userId = principal.getUserId();
        String userNm = principal.getUserNm();
        String corpGr = (principal.getCorpGr() != null) ? principal.getCorpGr() : "";

        HttpSession session = request.getSession(true);
        String sessionKey = "AAMS_PERMITTED_PGMS_" + userId + "_" + corpGr;

        @SuppressWarnings("unchecked")
        Set<String> permittedSet = (Set<String>) session.getAttribute(sessionKey);
        if (permittedSet == null) {
            permittedSet = menuService.getPermittedPgmSet(userId, userNm);
            session.setAttribute(sessionKey, permittedSet);
            log.debug("[ViewAccessInterceptor] Cached {} permitted programs for user [{}], corpGr [{}]",
                    permittedSet.size(), userId, corpGr);
        }

        // 6. 권한 검증: 대상 프로그램 및 후보군(Candidates) 비교
        List<String> candidates = buildCandidates(targetId, request);
        boolean hasAccess = false;
        for (String cand : candidates) {
            if (permittedSet.contains(cand)) {
                hasAccess = true;
                break;
            }
        }

        if (!hasAccess) {
            log.warn("[ViewAccessInterceptor] Forbidden access: User [{}] attempted unauthorized view [{}] (Candidates: {})",
                    userId, uri, candidates);
            handleForbidden(request, response, targetId);
            return false;
        }

        return true;
    }

    /**
     * URI로부터 프로그램 식별자 추출 (예: /views/usportfoliomodel/w_ja033a -> w_ja033a)
     */
    private String extractTargetProgramId(String uri) {
        if (uri == null || uri.isBlank()) return null;
        int lastSlash = uri.lastIndexOf('/');
        String lastSegment = (lastSlash >= 0) ? uri.substring(lastSlash + 1) : uri;
        if (lastSegment.contains("?")) {
            lastSegment = lastSegment.substring(0, lastSegment.indexOf('?'));
        }
        if (lastSegment.contains(";")) {
            lastSegment = lastSegment.substring(0, lastSegment.indexOf(';'));
        }
        return lastSegment.trim();
    }

    /**
     * PGM_ID(대문자), PGM_GO, 파라미터 등 가능한 후보군 목록 생성
     */
    private List<String> buildCandidates(String targetId, HttpServletRequest request) {
        List<String> candidates = new ArrayList<>();
        String upper = targetId.toUpperCase();
        candidates.add(upper); // 예: W_JA033A

        if (upper.startsWith("W_")) {
            candidates.add(upper.substring(2)); // 예: JA033A (PGM_GO 매칭)
        } else {
            candidates.add("W_" + upper); // 예: W_JA033A
        }

        // 쿼리 파라미터(pgmId, pgmGo, pgmNo)가 명시된 경우 후보군에 추가
        String pgmId = request.getParameter("pgmId");
        if (pgmId != null && !pgmId.isBlank()) {
            candidates.add(pgmId.trim().toUpperCase());
        }
        String pgmGo = request.getParameter("pgmGo");
        if (pgmGo != null && !pgmGo.isBlank()) {
            candidates.add(pgmGo.trim().toUpperCase());
        }
        String pgmNo = request.getParameter("pgmNo");
        if (pgmNo != null && !pgmNo.isBlank()) {
            candidates.add(pgmNo.trim().toUpperCase());
        }

        return candidates;
    }

    /**
     * 미인증 접근 처리
     */
    private void handleUnauthenticated(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (isDirectBrowserAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
        }
    }

    /**
     * 비인가(접근 권한 없음) 접근 차단 처리
     */
    private void handleForbidden(HttpServletRequest request, HttpServletResponse response, String targetId) throws IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();
        if (isDirectBrowserAccess(request)) {
            // 브라우저 주소창 직접 입력 시: 친절한 alert 경고 후 홈으로 이동
            out.println("<!DOCTYPE html>");
            out.println("<html lang=\"ko\">");
            out.println("<head><meta charset=\"UTF-8\"><title>접근 제한</title></head>");
            out.println("<body>");
            out.println("<script>");
            out.println("    alert('해당 화면(" + targetId.toUpperCase() + ")에 대한 접근 권한이 없습니다.');");
            out.println("    if (window.history.length > 1) {");
            out.println("        window.history.back();");
            out.println("    } else {");
            out.println("        window.location.href = '" + request.getContextPath() + "/';");
            out.println("    }");
            out.println("</script>");
            out.println("</body>");
            out.println("</html>");
        } else {
            // MDI 탭 내부 비동기 Fetch 요청 시: 패널 내부에 에러 뷰 렌더링
            out.println("<div class=\"pane-error\" style=\"padding: 50px 20px; text-align: center; color: #ef4444;\">");
            out.println("    <i class=\"fa-solid fa-ban fa-3x\" style=\"color: #f87171;\"></i>");
            out.println("    <p style=\"margin-top: 14px; font-weight: 600; font-size: 16px; color: #1e293b;\">화면 접근 권한이 없습니다.</p>");
            out.println("    <p style=\"font-size: 13px; color: #64748b; margin-top: 6px; line-height: 1.5;\">");
            out.println("        해당 화면(<b>" + targetId.toUpperCase() + "</b>)에 대한 사용 권한이 부여되지 않았습니다.<br>");
            out.println("        권한 신청이 필요하신 경우 시스템 관리자에게 문의해 주세요.");
            out.println("    </p>");
            out.println("</div>");
        }
        out.flush();
    }

    /**
     * 브라우저 주소창 직접 접근(Direct Navigation) 여부 판별
     */
    private boolean isDirectBrowserAccess(HttpServletRequest request) {
        String xRequestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(xRequestedWith)) {
            return false;
        }

        String secFetchDest = request.getHeader("Sec-Fetch-Dest");
        if ("document".equalsIgnoreCase(secFetchDest)) {
            return true;
        }

        String accept = request.getHeader("Accept");
        return accept != null && accept.contains("text/html");
    }
}
