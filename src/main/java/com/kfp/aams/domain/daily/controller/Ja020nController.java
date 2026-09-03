package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja020nSigaDto;
import com.kfp.aams.domain.daily.dto.Ja020nStatusDto;
import com.kfp.aams.domain.daily.dto.Ja020nTrDto;
import com.kfp.aams.domain.daily.service.Ja020nService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collections;
import java.util.List;

/**
 * Controller for w_ja020n (국내 체결/잔고 엑셀자료 LOAD)
 * Adheres strictly to Guideline 1 (no default value fallback).
 */
@Controller
@RequiredArgsConstructor
public class Ja020nController {

    private final Ja020nService ja020nService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja020n", "/views/daily/w_ja020n"})
    public String viewJa020n(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model,
                             HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA020N");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja020n");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 일일작업";
        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", paramYmd);

        return "views/daily/w_ja020n";
    }

    /**
     * API: Load Status list (d_ja020n)
     */
    @GetMapping("/api/daily/ja020n/status")
    @ResponseBody
    public List<Ja020nStatusDto> getStatusList(@RequestParam(name = "corpGr", required = false) String corpGr,
                                               @RequestParam(name = "ymd", required = false) String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja020nService.getStatusList(corpGr, ymd);
    }

    /**
     * API: Loaded Balance / Siga list (d_ja020n_siga)
     */
    @GetMapping("/api/daily/ja020n/siga")
    @ResponseBody
    public List<Ja020nSigaDto> getSigaList(@RequestParam(name = "corpGr", required = false) String corpGr,
                                           @RequestParam(name = "ymd", required = false) String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja020nService.getSigaList(corpGr, ymd);
    }

    /**
     * API: Loaded Execution / Tr list (d_ja020n_tr)
     */
    @GetMapping("/api/daily/ja020n/tr")
    @ResponseBody
    public List<Ja020nTrDto> getTrList(@RequestParam(name = "corpGr", required = false) String corpGr,
                                       @RequestParam(name = "ymd", required = false) String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja020nService.getTrList(corpGr, ymd);
    }

    /**
     * Helper to resolve corporate group (Guideline 1: no default value)
     */
    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return null;
    }
}
