package com.kfp.aams.domain.foreignassetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035rDto;
import com.kfp.aams.domain.foreignassetmanagement.service.Ja035rService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
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

import java.util.List;
import java.util.Map;

/**
 * W_JA035R 외화주식 종목등록 컨트롤러
 */
@Controller
@RequiredArgsConstructor
public class Ja035rController {

    private final Ja035rService service;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    @GetMapping({"/views/w_ja035r", "/views/foreignassetmanagement/w_ja035r"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA035R");

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "사무관리 > 외화자산운용 > 외화 종목 및 권리관리 > 외화주식 종목등록");
        return "views/foreignassetmanagement/w_ja035r";
    }

    @GetMapping("/api/foreignassetmanagement/ja035r/list")
    @ResponseBody
    public List<Ja035rDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                @RequestParam(required = false) String corpGr,
                                @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        return service.getList(resolveCorpGr(principal, corpGr, savedCorpGr));
    }

    @PostMapping("/api/foreignassetmanagement/ja035r/save")
    @ResponseBody
    public Map<String, Object> save(@AuthenticationPrincipal UserPrincipal principal,
                                    @RequestParam(required = false) String corpGr,
                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                    @RequestBody List<Ja035rDto> items) {
        int savedCount = service.saveAll(resolveCorpGr(principal, corpGr, savedCorpGr), items);
        return Map.of("success", true, "savedCount", savedCount);
    }

    @GetMapping("/api/foreignassetmanagement/ja035r/nation-currency")
    @ResponseBody
    public Map<String, String> nationCurrency(@RequestParam String nationCd) {
        return Map.of("currency", service.getCurrencyByNation(nationCd));
    }

    @GetMapping("/api/foreignassetmanagement/ja035r/currency-nation")
    @ResponseBody
    public Map<String, String> currencyNation(@RequestParam String currency) {
        return Map.of("nationCd", service.getNationByCurrency(currency));
    }

    @GetMapping("/api/foreignassetmanagement/ja035r/exchange-info")
    @ResponseBody
    public Map<String, String> exchangeInfo(@RequestParam String stockGb) {
        return service.resolveExchangeInfo(stockGb);
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
