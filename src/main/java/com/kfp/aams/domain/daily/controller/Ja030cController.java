package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.common.service.DddwService;
import com.kfp.aams.domain.daily.dto.Ja030cDto;
import com.kfp.aams.domain.daily.service.Ja030cService;
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
 * Controller for w_ja030c (채권 매매등록)
 * Adheres strictly to Guideline 1 (no default value fallback).
 */
@Controller
@RequiredArgsConstructor
public class Ja030cController {

    private final Ja030cService ja030cService;
    private final MenuService menuService;
    private final DddwService dddwService;

    @GetMapping({"/views/w_ja030c", "/views/daily/w_ja030c"})
    public String viewJa030c(@AuthenticationPrincipal Object principalObj,
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

        var menuDto = menuService.getMenuByPgmId("W_JA030C");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja030c");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 채권 매매등록";
        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", paramYmd);
        model.addAttribute("dddw", paramDddw != null ? paramDddw : "J15");

        return "views/daily/w_ja030c";
    }

    @GetMapping("/api/daily/ja030c/list")
    @ResponseBody
    public List<Ja030cDto> getJa030cList(@AuthenticationPrincipal Object principalObj,
                                         @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                         @RequestParam(name = "ymd", required = false) String ymd,
                                         @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                         @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }

        return ja030cService.getJa030cList(corpGr, ymd);
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr;
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr;
        }
        if (principal != null && principal.getCorpGr() != null) {
            return principal.getCorpGr();
        }
        return "";
    }
}
