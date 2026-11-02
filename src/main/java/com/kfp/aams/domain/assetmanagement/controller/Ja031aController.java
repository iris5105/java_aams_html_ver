package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja031aDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031aSaveRequest;
import com.kfp.aams.domain.assetmanagement.service.Ja031aService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja031aController {

    private final Ja031aService service;
    private final WorkDateService workDateService;
    private final MenuService menuService;

    /**
     * W_JA031A 화면 뷰 매핑
     */
    @GetMapping({"/views/w_ja031a", "/views/assetmanagement/w_ja031a"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA031A");
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("ymd", workDate);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "자산운용 > 선물/파생관리 > 선물매매 거래 등록 [W_JA031A]");
        return "views/assetmanagement/w_ja031a";
    }

    /**
     * 선물매매 거래 목록 조회
     */
    @GetMapping("/api/assetmanagement/ja031a/list")
    @ResponseBody
    public List<Ja031aDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                @RequestParam(required = false) String corpGr,
                                @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
                                @RequestParam String trCd) {
        return service.list(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, trCd);
    }

    /**
     * 달력 하이라이트 일자 목록 조회
     */
    @GetMapping("/api/assetmanagement/ja031a/dates")
    @ResponseBody
    public List<String> dates(@AuthenticationPrincipal UserPrincipal principal,
                              @RequestParam(required = false) String corpGr,
                              @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        return service.getHighlightDates(resolveCorpGr(principal, corpGr, savedCorpGr));
    }

    /**
     * 종목별 단위승수 조회
     */
    @GetMapping("/api/assetmanagement/ja031a/unit-aek")
    @ResponseBody
    public Map<String, Object> getUnitAek(@AuthenticationPrincipal UserPrincipal principal,
                                         @RequestParam(required = false) String corpGr,
                                         @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                         @RequestParam String sjCd) {
        Double unitAek = service.getUnitAek(resolveCorpGr(principal, corpGr, savedCorpGr), sjCd);
        return Map.of("unitAek", unitAek != null ? unitAek : 1.0);
    }

    /**
     * 선물매매 거래 저장 (CUD)
     */
    @PostMapping("/api/assetmanagement/ja031a/save")
    @ResponseBody
    public Map<String, Object> save(@AuthenticationPrincipal UserPrincipal principal,
                                    @RequestParam(required = false) String corpGr,
                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                    @RequestBody Ja031aSaveRequest request) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String userId = (principal != null && principal.getUsername() != null) ? principal.getUsername() : "SYSTEM";
        int count = service.save(resolvedCorpGr, request, userId);
        return Map.of("success", true, "count", count, "message", "정상적으로 저장되었습니다.");
    }

    /**
     * 만기거래생성 (KFP.SR_JA031A)
     */
    @PostMapping("/api/assetmanagement/ja031a/create-expiry")
    @ResponseBody
    public Map<String, Object> createExpiry(@AuthenticationPrincipal UserPrincipal principal,
                                            @RequestParam(required = false) String corpGr,
                                            @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String msg = service.createExpiry(resolvedCorpGr, ymd);
        return Map.of("success", true, "message", msg);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> handleInvalid(IllegalArgumentException ex) {
        return ResponseEntity.badRequest().body(Map.of("success", false, "message", ex.getMessage()));
    }

    private String resolveCorpGr(UserPrincipal principal, String paramCorpGr, String savedCorpGr) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return "";
    }
}

