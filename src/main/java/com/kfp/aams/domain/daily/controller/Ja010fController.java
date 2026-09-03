package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja010fDto;
import com.kfp.aams.domain.daily.service.Ja010fService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collections;
import java.util.List;

/**
 * Controller for w_ja010f (예수금잔액LOAD)
 * Adheres strictly to Guideline 1 (no default value fallback).
 */
@Controller
@RequiredArgsConstructor
public class Ja010fController {

    private final Ja010fService ja010fService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja010f", "/views/daily/w_ja010f"})
    public String viewJa010f(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @RequestParam(name = "dddw", required = false) String paramDddw,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model,
                             HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA010F");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010f");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 일일작업";
        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", paramYmd);
        model.addAttribute("dddw", paramDddw != null ? paramDddw : "%");

        return "views/daily/w_ja010f";
    }

    /**
     * API: Deposit Balance Load List (d_ja010f1)
     */
    @GetMapping("/api/daily/ja010f/list")
    @ResponseBody
    public List<Ja010fDto> getList(@RequestParam(name = "corpGr", required = false) String corpGr,
                                   @RequestParam(name = "ymd", required = false) String ymd,
                                   @RequestParam(name = "trCoCd", required = false) String trCoCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja010fService.getList(corpGr, ymd, trCoCd);
    }

    /**
     * Helper to resolve corporate group (Guideline 1: no default value)
     */
    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return null;
    }
}
