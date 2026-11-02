package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja030fDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030fSaveRequest;
import com.kfp.aams.domain.assetmanagement.service.Ja030fService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class Ja030fController {
    private final Ja030fService service;
    private final WorkDateService workDateService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja030f", "/views/assetmanagement/w_ja030f"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA030F");
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("ymd", workDate);
        model.addAttribute("fullpgm2", menu == null ? "" : menu.getFullpgm2());
        return "views/assetmanagement/w_ja030f";
    }

    @GetMapping("/api/assetmanagement/ja030f/list")
    @ResponseBody
    public List<Ja030fDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                 @RequestParam(required = false) String corpGr,
                                 @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                 @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd) {
        return service.list(resolveCorpGr(principal, corpGr, savedCorpGr), ymd);
    }

    @PostMapping("/api/assetmanagement/ja030f/save")
    @ResponseBody
    public Map<String, Object> save(@AuthenticationPrincipal UserPrincipal principal,
                                    @RequestParam(required = false) String corpGr,
                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                    @RequestBody Ja030fSaveRequest request) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        if (!"Y".equalsIgnoreCase(principal.getAdminYn()) && request != null && request.getTrYmd() != null
                && request.getTrYmd().isBefore(LocalDate.parse(workDateService.getWorkDateOrDefault(resolvedCorpGr)))) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "기준일 이전 거래는 수정할 수 없습니다.");
        }
        int count = service.save(resolvedCorpGr, request);
        return Map.of("success", true, "count", count, "message", "저장되었습니다.");
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (principal == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        if ("Y".equalsIgnoreCase(principal.getAdminYn())) {
            if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr;
            if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr;
        }
        return principal.getCorpGr();
    }
}
