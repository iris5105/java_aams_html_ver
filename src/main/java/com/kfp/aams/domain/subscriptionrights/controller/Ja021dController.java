package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021dReportType;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class Ja021dController {
    private final WorkDateService workDateService;
    private final MenuService menuService;

    public Ja021dController(WorkDateService workDateService, MenuService menuService) {
        this.workDateService = workDateService;
        this.menuService = menuService;
    }

    @GetMapping({"/views/w_ja021d", "/views/subscriptionrights/w_ja021d"})
    public String viewJa021d(
            @AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd", required = false) String paramYmd,
            @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr,
            Model model) {
        String corpGr = resolveCorpGr(paramCorpGr, savedCorpGr, cookieCorpGr, principal);
        String workDate = workDateService.getWorkDateOrDefault(corpGr);
        String initialYmd = paramYmd != null && !paramYmd.isBlank() ? paramYmd.trim() : workDate;
        var menu = menuService.getMenuByPgmId("W_JA021D");
        if (menu == null) menu = menuService.getMenuByPgmId("w_ja021d");

        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", initialYmd);
        model.addAttribute("ymd", initialYmd);
        model.addAttribute("fYmd", initialYmd);
        model.addAttribute("tYmd", initialYmd);
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "");
        model.addAttribute("reportTypes", Ja021dReportType.values());
        return "views/subscriptionrights/w_ja021d";
    }

    private String resolveCorpGr(String paramCorpGr, String savedCorpGr, String cookieCorpGr,
                                 UserPrincipal principal) {
        for (String value : new String[]{paramCorpGr, savedCorpGr, cookieCorpGr,
                principal != null ? principal.getCorpGr() : null}) {
            if (value != null && !value.isBlank()) return value.trim();
        }
        return "";
    }
}
