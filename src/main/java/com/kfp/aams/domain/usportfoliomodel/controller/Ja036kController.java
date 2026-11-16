package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja036kLoadDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja036kService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class Ja036kController {
    private final WorkDateService workDateService;
    private final MenuService menuService;
    private final Ja036kService service;

    @GetMapping({"/views/w_ja036k", "/views/usportfoliomodel/w_ja036k"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA036K");
        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);
        model.addAttribute("pgmNo", menu == null ? "W_JA036K" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA036K" : menu.getFullpgm2());
        return "views/usportfoliomodel/w_ja036k";
    }

    @GetMapping("/api/usportfoliomodel/ja036k/list")
    @ResponseBody
    public List<Ja036kLoadDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                    @RequestParam String mode,
                                    @RequestParam String ymd,
                                    @RequestParam(required = false) String corpGr,
                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        return service.getList(mode, resolvedCorpGr, parseYmd(ymd));
    }

    private String resolveCorpGr(UserPrincipal principal, String requested, String saved) {
        if (requested != null && !requested.isBlank()) return requested.trim();
        if (saved != null && !saved.isBlank()) return saved.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }

    private LocalDate parseYmd(String ymd) {
        return LocalDate.parse(ymd.replaceAll("[^0-9]", ""), DateTimeFormatter.BASIC_ISO_DATE);
    }
}
