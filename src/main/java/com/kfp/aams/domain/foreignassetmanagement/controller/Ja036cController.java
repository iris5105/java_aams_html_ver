package com.kfp.aams.domain.foreignassetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036cDto;
import com.kfp.aams.domain.foreignassetmanagement.service.Ja036cService;
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
 * W_JA036C 유상청약납입 컨트롤러
 */
@Controller
@RequiredArgsConstructor
public class Ja036cController {

    private final Ja036cService service;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    @GetMapping({"/views/w_ja036c", "/views/foreignassetmanagement/w_ja036c"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @RequestParam(required = false) String ymd,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        String selectedYmd = (ymd == null || ymd.isBlank()) ? workDate : ymd;
        var menu = menuService.getMenuByPgmId("W_JA036C");

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", selectedYmd);
        model.addAttribute("ymd", selectedYmd);
        model.addAttribute("trDates", service.getHighlightDates(resolvedCorpGr));
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "사무관리 > 외화자산운용 > 외화자산운용 > 유상청약납입");
        return "views/foreignassetmanagement/w_ja036c";
    }

    @GetMapping("/api/foreignassetmanagement/ja036c/list")
    @ResponseBody
    public List<Ja036cDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                @RequestParam(required = false) String corpGr,
                                @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                @RequestParam String ymd) {
        return service.getList(resolveCorpGr(principal, corpGr, savedCorpGr), ymd);
    }

    @GetMapping("/api/foreignassetmanagement/ja036c/dates")
    @ResponseBody
    public List<String> dates(@AuthenticationPrincipal UserPrincipal principal,
                              @RequestParam(required = false) String corpGr,
                              @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        return service.getHighlightDates(resolveCorpGr(principal, corpGr, savedCorpGr));
    }

    @GetMapping("/api/foreignassetmanagement/ja036c/default-gyulje-jm")
    @ResponseBody
    public Map<String, String> defaultGyuljeJm(@AuthenticationPrincipal UserPrincipal principal,
                                               @RequestParam(required = false) String corpGr,
                                               @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                               @RequestParam String currency) {
        String jmCd = service.getDefaultGyuljeJmCd(resolveCorpGr(principal, corpGr, savedCorpGr), currency);
        return Map.of("gyuljeJmCd", jmCd != null ? jmCd : "");
    }

    @PostMapping("/api/foreignassetmanagement/ja036c/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@AuthenticationPrincipal UserPrincipal principal,
                                                    @RequestParam(required = false) String corpGr,
                                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                                    @RequestBody List<Ja036cDto> rows) {
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
