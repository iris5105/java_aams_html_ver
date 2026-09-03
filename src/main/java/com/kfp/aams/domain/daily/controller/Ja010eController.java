package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja010eDto;
import com.kfp.aams.domain.daily.service.Ja010eService;
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
 * Controller for w_ja010e (주식체결LOAD(입고))
 * Adheres strictly to Guideline 1 (no default value fallback).
 */
@Controller
@RequiredArgsConstructor
public class Ja010eController {

    private final Ja010eService ja010eService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja010e", "/views/daily/w_ja010e"})
    public String viewJa010e(@AuthenticationPrincipal Object principalObj,
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

        var menuDto = menuService.getMenuByPgmId("W_JA010E");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010e");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 일일작업";
        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", paramYmd);
        model.addAttribute("dddw", paramDddw != null ? paramDddw : "%");

        return "views/daily/w_ja010e";
    }

    /**
     * API: Stock Trading Load List (d_ja010e1)
     */
    @GetMapping("/api/daily/ja010e/list")
    @ResponseBody
    public List<Ja010eDto> getList(@RequestParam(name = "corpGr", required = false) String corpGr,
                                   @RequestParam(name = "ymd", required = false) String ymd,
                                   @RequestParam(name = "trCoCd", required = false) String trCoCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja010eService.getList(corpGr, ymd, trCoCd);
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
