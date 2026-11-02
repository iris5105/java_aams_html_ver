package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.*;
import com.kfp.aams.domain.subscriptionrights.service.Ja021gService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller @RequiredArgsConstructor
public class Ja021gController {
    private final WorkDateService workDates;
    private final MenuService menus;
    private final Ja021gService service;

    @GetMapping({"/views/w_ja021g", "/views/subscriptionrights/w_ja021g"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(required=false) String corpGr,
            @CookieValue(name="savedCorpGr", required=false) String savedCorpGr, Model model) {
        String resolved = company(principal, corpGr, savedCorpGr);
        String workDate = workDates.getWorkDateOrDefault(resolved);
        var menu = menus.getMenuByPgmId("W_JA021G");
        if (menu == null) menu = menus.getMenuByPgmId("w_ja021g");
        model.addAttribute("corpGr", resolved);
        model.addAttribute("workDate", workDate);
        model.addAttribute("ymd", workDate);
        model.addAttribute("fullpgm2", menu == null ? "" : menu.getFullpgm2());
        return "views/subscriptionrights/w_ja021g";
    }

    @GetMapping("/api/subscriptionrights/ja021g/data") @ResponseBody
    public List<Ja021gMasterDto> data(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(required=false) String corpGr,
            @CookieValue(name="savedCorpGr", required=false) String savedCorpGr,
            @RequestParam String tab) {
        String resolved = company(principal, corpGr, savedCorpGr);
        String workDate = workDates.getWorkDateOrDefault(resolved).replace("-", "").substring(0, 8);
        return service.master(tab, LocalDate.parse(workDate, java.time.format.DateTimeFormatter.BASIC_ISO_DATE));
    }

    @GetMapping("/api/subscriptionrights/ja021g/detail") @ResponseBody
    public List<Ja021gDetailDto> detail(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam String tab, @RequestParam LocalDate trYmd,
            @RequestParam String habCo, @RequestParam String piHabCo) {
        requireUser(principal);
        return service.detail(tab, isAdmin(principal) ? "%" : principal.getCorpGr(), trYmd, habCo, piHabCo);
    }

    @PostMapping("/api/subscriptionrights/ja021g/save") @ResponseBody
    public Map<String, Object> save(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(required=false) String corpGr,
            @CookieValue(name="savedCorpGr", required=false) String savedCorpGr,
            @RequestBody Ja021gSaveDto request) {
        String resolved = company(principal, corpGr, savedCorpGr);
        String ymd = workDates.getWorkDateOrDefault(resolved).replace("-", "").substring(0, 8);
        service.save(request, resolved, isAdmin(principal),
                LocalDate.parse(ymd, java.time.format.DateTimeFormatter.BASIC_ISO_DATE));
        return Map.of("success", true);
    }

    private void requireUser(UserPrincipal user) {
        if (user == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
    }
    private boolean isAdmin(UserPrincipal user) { return "Y".equalsIgnoreCase(user.getAdminYn()); }
    private String company(UserPrincipal user, String requested, String saved) {
        requireUser(user);
        if (!isAdmin(user)) return user.getCorpGr();
        for (String value : new String[]{requested, saved, user.getCorpGr()})
            if (value != null && !value.isBlank()) return value.trim();
        throw new IllegalArgumentException("회사그룹을 확인할 수 없습니다.");
    }
}

