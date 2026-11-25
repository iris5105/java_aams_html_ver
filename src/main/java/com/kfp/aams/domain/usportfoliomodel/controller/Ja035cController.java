package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja035cDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja035cService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class Ja035cController {
    private final Ja035cService service;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    @GetMapping({"/views/w_ja035c", "/views/usportfoliomodel/w_ja035c"})
    public String view(@AuthenticationPrincipal Object principal, @RequestParam(required = false) String corpGr,
                       @RequestParam(required = false) String ymd, Model model) {
        String resolvedCorpGr = corpGr == null || corpGr.isBlank() ? principalCorpGr(principal) : corpGr.trim();
        String workDate = ymd == null || ymd.isBlank() ? workDateService.getWorkDateOrDefault(resolvedCorpGr) : ymd;
        var menu = menuService.getMenuByPgmId("W_JA035C");
        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "자산운용 > US Portfolio Model > 해외 결제 관리");
        return "views/usportfoliomodel/w_ja035c";
    }

    @GetMapping("/api/usportfoliomodel/ja035c/list") @ResponseBody
    public List<Ja035cDto> list(@RequestParam String corpGr, @RequestParam String ymd, @RequestParam String trCd) {
        return service.getList(corpGr, ymd, trCd);
    }
    @GetMapping("/api/usportfoliomodel/ja035c/currency-rate") @ResponseBody
    public BigDecimal rate(@RequestParam String corpGr, @RequestParam String ymd, @RequestParam String currency) {
        return service.getCurrencyRate(corpGr, ymd, currency);
    }
    @GetMapping("/api/usportfoliomodel/ja035c/trustee-currency") @ResponseBody
    public Map<String, String> trusteeCurrency(@RequestParam String corpGr, @RequestParam String trustee) {
        String currency = service.getTrusteeCurrency(corpGr, trustee);
        return Map.of("currency", currency == null ? "" : currency);
    }
    @GetMapping("/api/usportfoliomodel/ja035c/trustee-bank-currency") @ResponseBody
    public Map<String, String> trusteeBankCurrency(@RequestParam String corpGr, @RequestParam String trustee) {
        String currency = service.getTrusteeBankCurrency(corpGr, trustee);
        return Map.of("currency", currency == null ? "" : currency);
    }
    @PostMapping("/api/usportfoliomodel/ja035c/save") @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@RequestParam String corpGr, @RequestParam String ymd, @RequestParam String trCd,
                                                     @RequestBody List<Ja035cDto> rows) {
        return ResponseEntity.ok(Map.of("success", true, "count", service.save(corpGr, ymd, trCd, rows), "message", "저장되었습니다."));
    }
    private String principalCorpGr(Object principal) {
        return principal instanceof UserPrincipal user && user.getCorpGr() != null ? user.getCorpGr().trim() : "";
    }
}
