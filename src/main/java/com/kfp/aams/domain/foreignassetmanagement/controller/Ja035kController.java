package com.kfp.aams.domain.foreignassetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035kDto;
import com.kfp.aams.domain.foreignassetmanagement.service.Ja035kService;
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

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * W_JA035K 해외수익증권 매매내역 컨트롤러
 */
@Controller
@RequiredArgsConstructor
public class Ja035kController {

    private final Ja035kService service;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    @GetMapping({"/views/w_ja035k", "/views/foreignassetmanagement/w_ja035k", "/views/usportfoliomodel/w_ja035k"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @RequestParam(required = false) String ymd,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        String selectedYmd = (ymd == null || ymd.isBlank()) ? workDate : ymd;
        var menu = menuService.getMenuByPgmId("W_JA035K");

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", selectedYmd);
        model.addAttribute("ymd", selectedYmd);
        model.addAttribute("trDates", service.getHighlightDates(resolvedCorpGr));
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "사무관리 > 외화자산운용 > 해외수익증권 매매내역");
        return "views/foreignassetmanagement/w_ja035k";
    }

    @GetMapping("/api/foreignassetmanagement/ja035k/list")
    @ResponseBody
    public List<Ja035kDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                @RequestParam(required = false) String corpGr,
                                @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                @RequestParam String ymd,
                                @RequestParam String trCd) {
        return service.getList(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, trCd);
    }

    @GetMapping("/api/foreignassetmanagement/ja035k/dates")
    @ResponseBody
    public List<String> dates(@AuthenticationPrincipal UserPrincipal principal,
                              @RequestParam(required = false) String corpGr,
                              @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        return service.getHighlightDates(resolveCorpGr(principal, corpGr, savedCorpGr));
    }

    @GetMapping("/api/foreignassetmanagement/ja035k/trustee-info")
    @ResponseBody
    public Map<String, Object> trusteeInfo(@AuthenticationPrincipal UserPrincipal principal,
                                           @RequestParam(required = false) String corpGr,
                                           @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                           @RequestParam String ymd,
                                           @RequestParam String trustee) {
        return service.getTrusteeInfo(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, trustee);
    }

    @GetMapping("/api/foreignassetmanagement/ja035k/currency-rate")
    @ResponseBody
    public BigDecimal rate(@AuthenticationPrincipal UserPrincipal principal,
                           @RequestParam(required = false) String corpGr,
                           @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                           @RequestParam String ymd,
                           @RequestParam String currency) {
        return service.getCurrencyRate(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, currency);
    }

    @PostMapping("/api/foreignassetmanagement/ja035k/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@AuthenticationPrincipal UserPrincipal principal,
                                                    @RequestParam(required = false) String corpGr,
                                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                                    @RequestParam String ymd,
                                                    @RequestParam String trCd,
                                                    @RequestBody List<Ja035kDto> rows) {
        int count = service.save(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, trCd, rows);
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
