package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja031dDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031dSaveRequest;
import com.kfp.aams.domain.assetmanagement.service.Ja031dService;
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
public class Ja031dController {

    private final Ja031dService service;
    private final WorkDateService workDateService;
    private final MenuService menuService;

    /**
     * W_JA031D 화면 뷰 매핑
     */
    @GetMapping({"/views/w_ja031d", "/views/assetmanagement/w_ja031d"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA031D");
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("ymd", workDate);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "사무관리 > 자산운용 > 3016 (타사)수익증권 매매내역 등록 [W_JA031D]");
        return "views/assetmanagement/w_ja031d";
    }

    /**
     * (타사)수익증권 매매내역 목록 조회
     */
    @GetMapping("/api/assetmanagement/ja031d/list")
    @ResponseBody
    public List<Ja031dDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                @RequestParam(required = false) String corpGr,
                                @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
                                @RequestParam String trCd) {
        return service.list(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, trCd);
    }

    /**
     * 달력 하이라이트 일자 목록 조회
     */
    @GetMapping("/api/assetmanagement/ja031d/dates")
    @ResponseBody
    public List<String> dates(@AuthenticationPrincipal UserPrincipal principal,
                              @RequestParam(required = false) String corpGr,
                              @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        return service.getHighlightDates(resolveCorpGr(principal, corpGr, savedCorpGr));
    }

    /**
     * 펀드 수탁사 정보 조회
     */
    @GetMapping("/api/assetmanagement/ja031d/fund-custodian")
    @ResponseBody
    public Map<String, Object> getFundCustodian(@AuthenticationPrincipal UserPrincipal principal,
                                                @RequestParam(required = false) String corpGr,
                                                @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                                @RequestParam String fundCd) {
        return service.getFundCustodian(resolveCorpGr(principal, corpGr, savedCorpGr), fundCd);
    }

    /**
     * 타사종목 정보 조회
     */
    @GetMapping("/api/assetmanagement/ja031d/tasa-jm-info")
    @ResponseBody
    public Map<String, Object> getTasaJmInfo(@AuthenticationPrincipal UserPrincipal principal,
                                            @RequestParam(required = false) String corpGr,
                                            @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                            @RequestParam String tasaJmCd) {
        return service.getTasaJmInfo(resolveCorpGr(principal, corpGr, savedCorpGr), tasaJmCd);
    }

    /**
     * 기준가/과표가 조회
     */
    @GetMapping("/api/assetmanagement/ja031d/gijunga")
    @ResponseBody
    public Map<String, Object> getGijunga(@AuthenticationPrincipal UserPrincipal principal,
                                         @RequestParam(required = false) String corpGr,
                                         @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                         @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
                                         @RequestParam String jmCd,
                                         @RequestParam(required = false) String tasaFundCd) {
        return service.getGijunga(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, jmCd, tasaFundCd);
    }

    /**
     * 잔여좌수 조회 (전부매도 K61 더블클릭 연동)
     */
    @GetMapping("/api/assetmanagement/ja031d/residual-jwa")
    @ResponseBody
    public Map<String, Object> getResidualJwa(@AuthenticationPrincipal UserPrincipal principal,
                                             @RequestParam(required = false) String corpGr,
                                             @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                             @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
                                             @RequestParam String fundCd,
                                             @RequestParam String tasaJmCd) {
        return service.getResidualJwa(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, fundCd, tasaJmCd);
    }

    /**
     * 일괄 저장 (CUD)
     */
    @PostMapping("/api/assetmanagement/ja031d/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@AuthenticationPrincipal UserPrincipal principal,
                                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                                    @RequestBody Ja031dSaveRequest request) {
        String resolvedCorpGr = resolveCorpGr(principal, request.getCorpGr(), savedCorpGr);
        request.setCorpGr(resolvedCorpGr);
        String userId = principal != null ? principal.getUsername() : "SYSTEM";
        Map<String, Object> result = service.save(request, userId);
        return ResponseEntity.ok(result);
    }

    private String resolveCorpGr(UserPrincipal principal, String paramCorpGr, String cookieCorpGr) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return "ALL";
    }
}

