package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja031eController {

    private final WorkDateService workDateService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja031e", "/views/assetmanagement/w_ja031e"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA031E");

        // PB w_ja031e::wue_lastopen: dw_c.object.fymd[1] = f_first_ymd (date (idt_workdate)), tymd = idt_workdate
        String fymd = calculateMonthFirstDay(workDate);
        String tymd = workDate;

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fymd", fymd);
        model.addAttribute("tymd", tymd);
        model.addAttribute("pgmNo", menu == null ? "" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA031E" : menu.getFullpgm2());

        return "views/assetmanagement/w_ja031e";
    }

    private String calculateMonthFirstDay(String dateStr) {
        if (dateStr == null || dateStr.isBlank()) return "";
        try {
            String clean = dateStr.replace(".", "-").trim();
            LocalDate date = LocalDate.parse(clean, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            LocalDate firstDay = date.withDayOfMonth(1);
            return firstDay.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        } catch (Exception e) {
            log.warn("[Ja031eController] calculateMonthFirstDay parse error: {}", dateStr);
            return dateStr;
        }
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }
}

