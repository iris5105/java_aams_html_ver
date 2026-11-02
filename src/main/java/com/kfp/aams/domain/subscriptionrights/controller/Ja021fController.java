package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021fDetailDto;
import com.kfp.aams.domain.subscriptionrights.service.Ja021fService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
public class Ja021fController {
    private final WorkDateService workDates;
    private final MenuService menus;
    private final Ja021fService service;

    public Ja021fController(WorkDateService workDates, MenuService menus, Ja021fService service) {
        this.workDates = workDates;
        this.menus = menus;
        this.service = service;
    }

    @GetMapping({"/views/w_ja021f", "/views/subscriptionrights/w_ja021f"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       @CookieValue(name = "corpGr", required = false) String cookieCorpGr,
                       Model model) {
        String corpGr = resolveCorpGr(principal, paramCorpGr, savedCorpGr, cookieCorpGr);
        String workDate = workDates.getWorkDateOrDefault(corpGr);
        var menu = menus.getMenuByPgmId("W_JA021F");
        if (menu == null) menu = menus.getMenuByPgmId("w_ja021f");
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "");
        return "views/subscriptionrights/w_ja021f";
    }

    @GetMapping("/api/subscriptionrights/ja021f/data")
    @ResponseBody
    public Map<String, Object> data(@RequestParam String tab,
                                    @RequestParam(required = false) String corpGr,
                                    @RequestParam(required = false) String workDate,
                                    @AuthenticationPrincipal UserPrincipal principal,
                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                    @CookieValue(name = "corpGr", required = false) String cookieCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr, cookieCorpGr);
        return service.selectTab(tab, resolvedCorpGr, workDate);
    }

    @GetMapping("/api/subscriptionrights/ja021f/detail")
    @ResponseBody
    public List<Ja021fDetailDto> detail(@RequestParam(required = false) String corpGr,
                                        @RequestParam String ymd,
                                        @RequestParam String balhCo,
                                        @RequestParam String jeungjMth,
                                        @AuthenticationPrincipal UserPrincipal principal,
                                        @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                        @CookieValue(name = "corpGr", required = false) String cookieCorpGr) {
        return service.selectDetail(resolveCorpGr(principal, corpGr, savedCorpGr, cookieCorpGr), ymd, balhCo, jeungjMth);
    }

    private String resolveCorpGr(UserPrincipal principal, String requested, String saved, String cookie) {
        if (principal == null) throw new IllegalStateException("로그인이 필요합니다.");
        if (!"Y".equalsIgnoreCase(principal.getAdminYn())) {
            return principal.getCorpGr();
        }
        for (String value : new String[]{requested, saved, cookie, principal.getCorpGr()}) {
            if (value != null && !value.isBlank()) return value.trim();
        }
        throw new IllegalArgumentException("회사그룹을 확인할 수 없습니다.");
    }
}
