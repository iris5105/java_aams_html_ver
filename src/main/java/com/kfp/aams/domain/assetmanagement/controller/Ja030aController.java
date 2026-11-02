package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja030aDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030aSaveRequest;
import com.kfp.aams.domain.assetmanagement.service.Ja030aService;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class Ja030aController {
    private final Ja030aService service;
    private final WorkDateService workDateService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja030a", "/views/assetmanagement/w_ja030a"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA030A");
        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("ymd", workDateService.getWorkDateOrDefault(resolvedCorpGr));
        model.addAttribute("fullpgm2", menu == null ? "" : menu.getFullpgm2());
        return "views/assetmanagement/w_ja030a";
    }

    @GetMapping("/api/assetmanagement/ja030a/list")
    @ResponseBody
    public List<Ja030aDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                 @RequestParam(required = false) String corpGr,
                                 @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                 @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
                                 @RequestParam String trCd,
                                 @RequestParam String jmCd) {
        return service.list(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, trCd, jmCd);
    }

    @GetMapping("/api/assetmanagement/ja030a/dates")
    @ResponseBody
    public List<LocalDate> dates(@AuthenticationPrincipal UserPrincipal principal,
                                 @RequestParam(required = false) String corpGr,
                                 @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        return service.dates(resolveCorpGr(principal, corpGr, savedCorpGr));
    }

    @PostMapping("/api/assetmanagement/ja030a/save")
    @ResponseBody
    public Map<String, Object> save(@AuthenticationPrincipal UserPrincipal principal,
                                    @RequestParam(required = false) String corpGr,
                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                    @RequestBody Ja030aSaveRequest request) {
        int count = service.save(resolveCorpGr(principal, corpGr, savedCorpGr), request);
        return Map.of("success", true, "count", count, "message", "저장되었습니다.");
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        requirePrincipal(principal);
        if ("Y".equalsIgnoreCase(principal.getAdminYn())) {
            if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr;
            if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr;
        }
        return principal.getCorpGr();
    }

    private void requirePrincipal(UserPrincipal principal) {
        if (principal == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
    }
}
