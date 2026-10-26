package com.kfp.aams.domain.dailyadvisory.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010jDto;
import com.kfp.aams.domain.dailyadvisory.service.Ja010jService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.JwtProvider;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010jController {

    private final Ja010jService ja010jService;
    private final WorkDateService workDateService;
    private final MenuService menuService;
    private final JwtProvider jwtProvider;

    @GetMapping({"/views/w_ja010j", "/views/dailyadvisory/w_ja010j"})
    public String ja010jView(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "fymd", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate paramFymd,
                             @RequestParam(name = "tymd", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate paramTymd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             @CookieValue(name = "accessToken", required = false) String accessToken,
                             HttpServletRequest request,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        boolean isAdmin = checkIsAdmin(principalObj, accessToken, request);

        var menuDto = menuService.getMenuByPgmId("W_JA010J");
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 공모청약 수요예측 참여표(회사)";

        // 파워빌더 w_ja010j.srw (wue_lastopen) 명세:
        // tymd = 기준일자(작업일자), fymd = 기준일자 기준 3개월 전 + 1일 (ADD_MONTHS(tymd, -3) + 1)
        LocalDate tymd;
        if (paramTymd != null) {
            tymd = paramTymd;
        } else {
            String defaultYmd = workDateService.getWorkDateOrDefault(corpGr);
            try {
                tymd = LocalDate.parse(defaultYmd);
            } catch (Exception e) {
                tymd = LocalDate.now();
            }
        }
        LocalDate fymd = (paramFymd != null) ? paramFymd : tymd.minusMonths(3);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("adminYn", isAdmin ? "Y" : "N");
        model.addAttribute("isAdmin", isAdmin);
        model.addAttribute("initialTymd", tymd.toString());
        model.addAttribute("initialFymd", fymd.toString());
        model.addAttribute("tymd", tymd.toString());
        model.addAttribute("fymd", fymd.toString());
        model.addAttribute("workDate", tymd.toString());

        return "views/dailyadvisory/w_ja010j";
    }

    /**
     * 회사 변경 시 해당 회사의 기준일자 및 3개월 전 일자 조회 API (개발지침 달력 규칙 4)
     */
    @GetMapping("/api/daily/ja010j/workdate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String defaultYmd = workDateService.getWorkDateOrDefault(corpGr);
        LocalDate tymd;
        try {
            tymd = LocalDate.parse(defaultYmd);
        } catch (Exception e) {
            tymd = LocalDate.now();
        }
        LocalDate fymd = tymd.minusMonths(3);

        Map<String, String> response = new HashMap<>();
        response.put("workDate", tymd.toString());
        response.put("tymd", tymd.toString());
        response.put("fymd", fymd.toString());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/daily/ja010j/list")
    @ResponseBody
    public ResponseEntity<List<Ja010jDto>> getList(
            @AuthenticationPrincipal Object principalObj,
            @RequestParam(name = "corpGr", required = false) String corpGr,
            @RequestParam("ymd") @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
            @CookieValue(name = "accessToken", required = false) String accessToken,
            HttpServletRequest request) {

        // 파워빌더 w_ja010j.srw 명세: 계정 권한이 어드민(gaa.aams)인 경우 '%'를 넘겨 전체 회사 참여그룹 조회
        boolean isAdmin = checkIsAdmin(principalObj, accessToken, request);
        String targetCorpGr;
        if (isAdmin) {
            targetCorpGr = "%";
        } else {
            targetCorpGr = (corpGr != null && corpGr.contains(",")) ? corpGr.split(",")[0].trim() : (corpGr != null ? corpGr.trim() : "");
            if (targetCorpGr.isBlank() && principalObj instanceof UserPrincipal p && p.getCorpGr() != null) {
                targetCorpGr = p.getCorpGr().trim();
            }
        }

        List<Ja010jDto> list = ja010jService.selectJa010jList(targetCorpGr, ymd);
        return ResponseEntity.ok(list);
    }

    /**
     * 사용자 어드민 권한 여부 판별 (Principal -> SecurityContext -> JWT -> Cookie 순차 안전 검증)
     */
    private boolean checkIsAdmin(Object principalObj, String accessToken, HttpServletRequest request) {
        if (principalObj instanceof UserPrincipal p && "Y".equalsIgnoreCase(p.getAdminYn())) {
            return true;
        }
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.getPrincipal() instanceof UserPrincipal p && "Y".equalsIgnoreCase(p.getAdminYn())) {
                return true;
            }
        } catch (Exception ignored) {
        }
        String token = (accessToken != null && !accessToken.isBlank()) ? accessToken : extractAccessTokenFromRequest(request);
        if (token != null && !token.isBlank()) {
            try {
                UserPrincipal p = jwtProvider.getUserPrincipal(token);
                if (p != null && "Y".equalsIgnoreCase(p.getAdminYn())) {
                    return true;
                }
            } catch (Exception ignored) {
            }
        }
        if (request != null && request.getCookies() != null) {
            for (Cookie c : request.getCookies()) {
                if ("adminYn".equals(c.getName()) && "Y".equalsIgnoreCase(c.getValue())) {
                    return true;
                }
            }
        }
        return false;
    }

    private String extractAccessTokenFromRequest(HttpServletRequest request) {
        if (request != null && request.getCookies() != null) {
            for (Cookie c : request.getCookies()) {
                if ("accessToken".equals(c.getName()) && c.getValue() != null && !c.getValue().isBlank()) {
                    return c.getValue();
                }
            }
        }
        return null;
    }

    /**
     * Helper to resolve corporate group (Guideline 1: no default value)
     * filter에 corpGr 관련 dddw가 없는 화면이므로 엑세스토큰(UserPrincipal)의 corpGr을 최우선으로 반영
     */
    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr.trim();
        return null;
    }
}
