package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Szx0seDto;
import com.kfp.aams.domain.daily.service.Szx0seService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class Szx0seController {

    private final Szx0seService szx0seService;
    private final com.kfp.aams.domain.menu.service.MenuService menuService;
    private final com.kfp.aams.domain.common.service.DddwService dddwService;

    @GetMapping({"/views/w_szx0se", "/views/daily/w_szx0se"})
    public String viewSzx0se(@AuthenticationPrincipal Object principalObj,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
            Model model,
            jakarta.servlet.http.HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        String adminYn = (principal != null && principal.getAdminYn() != null) ? principal.getAdminYn() : "N";

        String addWhere = null;
        if (!"Y".equalsIgnoreCase(adminYn)) {
            addWhere = "corp_gr = '" + corpGr + "'";
        }

        var corpList = dddwService.getDddwList("CORP_GR", 1, addWhere, null, session);

        model.addAttribute("corpGr", corpGr);
        model.addAttribute("adminYn", adminYn);
        model.addAttribute("corpList", corpList);
        model.addAttribute("dataList", szx0seService.getSzx0seList(corpGr));

        var menuDto = menuService.getMenuByPgmId("w_szx0se");
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : null;
        model.addAttribute("fullpgm2", fullpgm2);

        return "views/daily/w_szx0se";
    }

    @GetMapping("/api/account/szx0se/list")
    @ResponseBody
    public List<Szx0seDto> getSzx0seList(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        return szx0seService.getSzx0seList(corpGr);
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr;
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr;
        if (principal != null && principal.getCorpGr() != null) return principal.getCorpGr();
        return "";
    }
}
