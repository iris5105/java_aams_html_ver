package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja031cDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031cSaveRequest;
import com.kfp.aams.domain.assetmanagement.service.Ja031cService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja031cController {

    private final Ja031cService service;
    private final WorkDateService workDateService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja031c", "/views/assetmanagement/w_ja031c", "/views/usportfoliomodel/w_ja031c"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA031C");
        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("ymd", workDate);
        model.addAttribute("workDate", workDate);
        model.addAttribute("dddw", "S30");
        model.addAttribute("fullpgm2", menu == null ? "W_JA031C" : menu.getFullpgm2());
        return "views/assetmanagement/w_ja031c";
    }

    @GetMapping("/api/assetmanagement/ja031c/list")
    @ResponseBody
    public List<Ja031cDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                 @RequestParam(required = false) String corpGr,
                                 @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                 @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
                                 @RequestParam String trCd) {
        return service.list(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, trCd);
    }

    @GetMapping("/api/assetmanagement/ja031c/dates")
    @ResponseBody
    public List<String> dates(@AuthenticationPrincipal UserPrincipal principal,
                              @RequestParam(required = false) String corpGr,
                              @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        return service.highlightDates(resolveCorpGr(principal, corpGr, savedCorpGr));
    }

    @GetMapping("/api/assetmanagement/ja031c/next-sequence")
    @ResponseBody
    public Map<String, Integer> nextSequence(@AuthenticationPrincipal UserPrincipal principal,
                                              @RequestParam(required = false) String corpGr,
                                              @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                              @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
                                              @RequestParam String trCd) {
        return Map.of("trSeqNo", service.nextSequence(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, trCd));
    }

    @PostMapping("/api/assetmanagement/ja031c/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@AuthenticationPrincipal UserPrincipal principal,
                                                     @RequestBody Ja031cSaveRequest request) {
        try {
            request.setCorpGr(resolveCorpGr(principal, request.getCorpGr(), null));
            return ResponseEntity.ok(service.save(request));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", ex.getMessage()));
        } catch (Exception ex) {
            log.error("W_JA031C 저장 오류", ex);
            return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "저장 중 오류가 발생했습니다."));
        }
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }
}
