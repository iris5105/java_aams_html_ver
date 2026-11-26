package com.kfp.aams.domain.foreignassetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036bDto;
import com.kfp.aams.domain.foreignassetmanagement.service.Ja036bService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;

/**
 * W_JA036B 외화배당금 수령등록 컨트롤러
 */
@Controller
@RequiredArgsConstructor
public class Ja036bController {

    private final Ja036bService service;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    @GetMapping({"/views/w_ja036b", "/views/foreignassetmanagement/w_ja036b"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @RequestParam(required = false) String ymd,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        String selectedYmd = (ymd == null || ymd.isBlank()) ? workDate : ymd;
        var menu = menuService.getMenuByPgmId("W_JA036B");

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", selectedYmd);
        model.addAttribute("ymd", selectedYmd);
        model.addAttribute("trDates", service.getHighlightDates(resolvedCorpGr));
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "사무관리 > 외화자산운용 > 배당/권리 > 외화배당금 수령등록");
        return "views/foreignassetmanagement/w_ja036b";
    }

    @GetMapping("/api/foreignassetmanagement/ja036b/list")
    @ResponseBody
    public List<Ja036bDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                @RequestParam(required = false) String corpGr,
                                @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                @RequestParam String ymd) {
        return service.getList(resolveCorpGr(principal, corpGr, savedCorpGr), ymd);
    }

    @GetMapping("/api/foreignassetmanagement/ja036b/dates")
    @ResponseBody
    public List<String> dates(@AuthenticationPrincipal UserPrincipal principal,
                              @RequestParam(required = false) String corpGr,
                              @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        return service.getHighlightDates(resolveCorpGr(principal, corpGr, savedCorpGr));
    }

    @GetMapping("/api/foreignassetmanagement/ja036b/default-gyulje-jm")
    @ResponseBody
    public Map<String, String> defaultGyuljeJm(@AuthenticationPrincipal UserPrincipal principal,
                                               @RequestParam(required = false) String corpGr,
                                               @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                               @RequestParam String currency) {
        String jmCd = service.getDefaultGyuljeJmCd(resolveCorpGr(principal, corpGr, savedCorpGr), currency);
        return Map.of("gyuljeJmCd", jmCd != null ? jmCd : "");
    }

    @PostMapping("/api/foreignassetmanagement/ja036b/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@AuthenticationPrincipal UserPrincipal principal,
                                                    @RequestParam(required = false) String corpGr,
                                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                                    @RequestBody List<Ja036bDto> rows) {
        int count = service.save(resolveCorpGr(principal, corpGr, savedCorpGr), rows);
        return ResponseEntity.ok(Map.of("success", true, "count", count, "message", "저장되었습니다."));
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (principal == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        if ("Y".equalsIgnoreCase(principal.getAdminYn())) {
            if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
            if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        }
        return principal.getCorpGr() != null ? principal.getCorpGr().trim() : "";
    }
}
