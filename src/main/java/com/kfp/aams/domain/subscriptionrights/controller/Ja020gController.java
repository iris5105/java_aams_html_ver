package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;

@Controller
public class Ja020gController {

    private final WorkDateService workDateService;
    private final MenuService menuService;

    public Ja020gController(WorkDateService workDateService, MenuService menuService) {
        this.workDateService = workDateService;
        this.menuService = menuService;
    }

    @GetMapping({"/views/w_ja020g", "/views/subscriptionrights/w_ja020g"})
    public String viewJa020g(
            @AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "fYmd", required = false) String paramFYmd,
            @RequestParam(name = "tYmd", required = false) String paramTYmd,
            @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr,
            Model model) {
        String corpGr = resolveCorpGr(paramCorpGr, savedCorpGr, cookieCorpGr, principal);
        String workDate = workDateService.getWorkDateOrDefault(corpGr);
        String initialTYmd = (paramTYmd != null && !paramTYmd.isBlank()) ? paramTYmd.trim() : workDate;
        String initialFYmd = (paramFYmd != null && !paramFYmd.isBlank()) ? paramFYmd.trim() : minusOneMonth(initialTYmd);

        var menu = menuService.getMenuByPgmId("W_JA020G");
        if (menu == null) menu = menuService.getMenuByPgmId("w_ja020g");

        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", initialTYmd);
        model.addAttribute("ymd", initialTYmd);
        model.addAttribute("fYmd", initialFYmd);
        model.addAttribute("fymd", initialFYmd);
        model.addAttribute("tYmd", initialTYmd);
        model.addAttribute("tymd", initialTYmd);
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "");
        return "views/subscriptionrights/w_ja020g";
    }

    private String minusOneMonth(String ymd) {
        if (ymd == null || ymd.isBlank()) return "";
        try {
            return LocalDate.parse(ymd.trim().replace(".", "-")).minusMonths(1).toString();
        } catch (Exception e) {
            return ymd;
        }
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

