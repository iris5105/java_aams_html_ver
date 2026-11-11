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
public class Ja031h1Controller {

    private final WorkDateService workDateService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja031h1", "/views/assetmanagement/w_ja031h1"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA031H1");

        // PB w_ja031h1::wue_lastopen:
        // tymd = trunc(idt_workdate, 'mm') - 1 (전월 말일)
        // fymd = add_months(trunc(idt_workdate, 'mm'), -12) (1년 전 해당 월 1일)
        String[] dates = calculateDefaultDates(workDate);
        String fymd = dates[0];
        String tymd = dates[1];

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fymd", fymd);
        model.addAttribute("tymd", tymd);
        model.addAttribute("pgmNo", menu == null ? "" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA031H1" : menu.getFullpgm2());

        return "views/assetmanagement/w_ja031h1";
    }

    private String[] calculateDefaultDates(String dateStr) {
        if (dateStr == null || dateStr.isBlank()) {
            return new String[]{"", ""};
        }
        try {
            String digits = dateStr.replaceAll("[^0-9]", "").trim();
            LocalDate baseDate;
            if (digits.length() == 8) {
                baseDate = LocalDate.parse(digits, DateTimeFormatter.ofPattern("yyyyMMdd"));
            } else {
                baseDate = LocalDate.parse(dateStr.replace(".", "-").trim(), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }
            LocalDate firstDayOfCurrentMonth = baseDate.withDayOfMonth(1);
            LocalDate tymdDate = firstDayOfCurrentMonth.minusDays(1);
            LocalDate fymdDate = tymdDate.minusYears(1).withDayOfMonth(1);

            return new String[]{
                    fymdDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")),
                    tymdDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))
            };
        } catch (Exception e) {
            log.warn("[Ja031h1Controller] calculateDefaultDates parse error: {}", dateStr);
            return new String[]{dateStr, dateStr};
        }
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }
}

