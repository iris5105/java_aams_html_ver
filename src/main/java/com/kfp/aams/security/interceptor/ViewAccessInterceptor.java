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
 * 1. 브라우저 주소창 직접 입력(Direct Navigation) 원천 차단:
 *    - /views/** (개별 화면 조각 뷰) 주소창 직접 접근 차단
 *    - /api/** (데이터 REST API) 주소창 직접 접근 차단
 * 2. 차단 시 [이전 화면으로] 및 [AAMS 메인 화면으로 돌아가기] 2개 버튼 오류 화면 표출
 * 3. MDI 탭 내부 호출 시 유저의 역할 권한(FW_ROLE_PGM) 비교 검증
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
        if (uri.startsWith("/views/common/") || uri.equals("/error")
                || uri.contains("/security-config") || uri.contains("/download")
                || uri.contains("/export") || uri.contains("/rd/")) {
            return true;
        }

        String targetId = extractTargetProgramId(uri);
        boolean isApiRequest = uri.startsWith("/api/");

        // 2. 브라우저 주소창 직접 호출(Direct Navigation) 감지 시 즉시 차단 및 오류 페이지 표출
        if (isDirectBrowserAccess(request)) {
            log.warn("[ViewAccessInterceptor] Blocked direct address bar access to [{}] (API: {}): URI [{}]",
                    targetId, isApiRequest, uri);
            handleDirectAccessBlocked(request, response, targetId, isApiRequest);
            return false;
        }

        // 3. /api/** 요청인 경우 (정상적인 화면 내부 fetch/ajax 호출은 컨트롤러로 통과)
        if (isApiRequest) {
            return true;
        }

        // 4. /views/** 화면에 대한 인증 사용자(UserPrincipal) 확인 (MDI 탭 비동기 요청)
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal() instanceof UserPrincipal principal)) {
            log.warn("[ViewAccessInterceptor] Unauthenticated access attempt to view: {}", uri);
            handleUnauthenticated(request, response);
            return false;
        }

        // 5. 슈퍼관리자(Admin) 권한 패스
        if ("Y".equalsIgnoreCase(principal.getAdminYn())) {
            return true;
        }

        if (targetId == null || targetId.isBlank()) {
            return true;
        }

        // 6. 사용자의 허용 프로그램 Set 취득 (세션 캐싱)
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

        // 7. 권한 검증: 대상 프로그램 및 후보군(Candidates) 비교
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
     * URI로부터 프로그램 또는 API 식별자 추출 (예: /views/usportfoliomodel/w_ja033a -> w_ja033a)
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
     * 브라우저 주소창 직접 접근(Direct Navigation) 차단 시 전용 오류 페이지 렌더링
     */
    private void handleDirectAccessBlocked(HttpServletRequest request, HttpServletResponse response, String targetId, boolean isApi) throws IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType("text/html;charset=UTF-8");

        String displayItem = (targetId != null ? targetId.toUpperCase() : "요청");
        String titleText = isApi ? "비정상적인 API 접근입니다" : "비정상적인 화면 접근입니다";
        String descText = isApi
                ? "AAMS 시스템 데이터 API는 브라우저 주소창 직접 입력으로 호출할 수 없습니다.<br>통합 시스템 화면을 통해 정상적으로 이용해 주시기 바랍니다."
                : "AAMS 업무 화면은 브라우저 주소창 직접 입력으로 열 수 없습니다.<br>이전 화면으로 돌아가시거나 시스템 메뉴를 통해 정상적으로 진입해 주시기 바랍니다.";
        String iconClass = isApi ? "fa-solid fa-shield-halved" : "fa-solid fa-triangle-exclamation";
        String badgeIcon = isApi ? "fa-solid fa-network-wired" : "fa-regular fa-window-maximize";

        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html lang=\"ko\">");
        out.println("<head>");
        out.println("    <meta charset=\"UTF-8\">");
        out.println("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        out.println("    <title>" + titleText + " - AAMS 자산관리</title>");
        out.println("    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css\">");
        out.println("    <style>");
        out.println("        * { box-sizing: border-box; margin: 0; padding: 0; }");
        out.println("        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Noto Sans KR', sans-serif; background-color: #f1f5f9; display: flex; align-items: center; justify-content: center; min-height: 100vh; padding: 20px; }");
        out.println("        .error-card { background: #ffffff; border-radius: 14px; box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1); width: 100%; max-width: 530px; padding: 44px 36px; text-align: center; border-top: 5px solid #ef4444; }");
        out.println("        .icon-box { width: 76px; height: 76px; background: #fee2e2; color: #ef4444; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 34px; margin: 0 auto 22px auto; }");
        out.println("        .title { font-size: 22px; font-weight: 700; color: #0f172a; margin-bottom: 12px; letter-spacing: -0.5px; }");
        out.println("        .desc { font-size: 14px; color: #64748b; line-height: 1.6; margin-bottom: 22px; word-break: keep-all; }");
        out.println("        .pgm-badge { display: inline-block; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; padding: 6px 14px; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 26px; font-family: monospace; }");
        out.println("        .btn-group { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }");
        out.println("        .btn-back { display: inline-flex; align-items: center; justify-content: center; gap: 8px; background: #f1f5f9; color: #334155; border: 1px solid #cbd5e1; text-decoration: none; padding: 12px 22px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: background 0.2s; }");
        out.println("        .btn-back:hover { background: #e2e8f0; }");
        out.println("        .btn-home { display: inline-flex; align-items: center; justify-content: center; gap: 8px; background: #2563eb; color: #ffffff; text-decoration: none; padding: 12px 24px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: background 0.2s; box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2); }");
        out.println("        .btn-home:hover { background: #1d4ed8; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("    <div class=\"error-card\">");
        out.println("        <div class=\"icon-box\"><i class=\"" + iconClass + "\"></i></div>");
        out.println("        <h1 class=\"title\">" + titleText + "</h1>");
        out.println("        <p class=\"desc\">" + descText + "</p>");
        out.println("        <div class=\"pgm-badge\"><i class=\"" + badgeIcon + "\" style=\"margin-right: 6px; color: #64748b;\"></i>" + displayItem + "</div>");
        out.println("        <div class=\"btn-group\">");
        out.println("            <a href=\"javascript:void(0);\" onclick=\"if(window.history.length>1){window.history.back();}else{window.location.href='" + request.getContextPath() + "/';}\" class=\"btn-back\">");
        out.println("                <i class=\"fa-solid fa-arrow-left\"></i> 이전 화면으로");
        out.println("            </a>");
        out.println("            <a href=\"" + request.getContextPath() + "/\" class=\"btn-home\">");
        out.println("                <i class=\"fa-solid fa-house\"></i> AAMS 메인 화면으로 돌아가기");
        out.println("            </a>");
        out.println("        </div>");
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
        out.flush();
    }

    /**
     * 미인증 접근 처리 (MDI 탭 비동기 요청)
     */
    private void handleUnauthenticated(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
    }

    /**
     * 비인가(접근 권한 없음) 접근 차단 처리 (MDI 탭 내부 패널 에러 렌더링)
     */
    private void handleForbidden(HttpServletRequest request, HttpServletResponse response, String targetId) throws IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();
        out.println("<div class=\"pane-error\" style=\"padding: 50px 20px; text-align: center; color: #ef4444;\">");
        out.println("    <i class=\"fa-solid fa-ban fa-3x\" style=\"color: #f87171;\"></i>");
        out.println("    <p style=\"margin-top: 14px; font-weight: 600; font-size: 16px; color: #1e293b;\">화면 접근 권한이 없습니다.</p>");
        out.println("    <p style=\"font-size: 13px; color: #64748b; margin-top: 6px; line-height: 1.5;\">");
        out.println("        해당 화면(<b>" + (targetId != null ? targetId.toUpperCase() : "") + "</b>)에 대한 사용 권한이 부여되지 않았습니다.<br>");
        out.println("        권한 신청이 필요하신 경우 시스템 관리자에게 문의해 주세요.");
        out.println("    </p>");
        out.println("</div>");
        out.flush();
    }

    /**
     * 브라우저 주소창 직접 접근(Direct Navigation) 여부 판별
     * - MDI 탭 및 JS AJAX 호출: X-Requested-With: XMLHttpRequest 또는 Sec-Fetch-Dest: empty
     * - 주소창 직접 입력/엔터: X-Requested-With 없음 AND (Sec-Fetch-Dest == 'document' OR Sec-Fetch-Site == 'none' OR Referer == null)
     */
    private boolean isDirectBrowserAccess(HttpServletRequest request) {
        String xRequestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(xRequestedWith)) {
            return false;
        }

        String secFetchDest = request.getHeader("Sec-Fetch-Dest");
        if ("empty".equalsIgnoreCase(secFetchDest)) {
            return false; // JS Fetch MDI 비동기 호출
        }

        if ("document".equalsIgnoreCase(secFetchDest)) {
            return true;
        }

        String secFetchSite = request.getHeader("Sec-Fetch-Site");
        if ("none".equalsIgnoreCase(secFetchSite)) {
            return true;
        }

        String referer = request.getHeader("Referer");
        if (referer == null && "GET".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String accept = request.getHeader("Accept");
        return accept != null && accept.contains("text/html");
    }
}
