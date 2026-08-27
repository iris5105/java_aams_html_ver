package com.kfp.aams.domain.ja010.controller;

import com.kfp.aams.domain.ja010.dto.Ja010dDto;
import com.kfp.aams.domain.ja010.service.Ja010dService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class Ja010dController {

    private final Ja010dService ja010dService;
    private final com.kfp.aams.domain.menu.service.MenuService menuService;
    private final com.kfp.aams.domain.common.service.DddwService dddwService;

    @GetMapping({"/views/w_ja010d", "/views/ja010/w_ja010d"})
    public String viewJa010d(@AuthenticationPrincipal Object principalObj,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "trYmd", required = false) String paramTrYmd,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
            Model model,
            jakarta.servlet.http.HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        String adminYn = (principal != null && principal.getAdminYn() != null) ? principal.getAdminYn() : "N";

        String trYmd = (paramTrYmd != null && !paramTrYmd.isBlank()) ? paramTrYmd
                : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        String addWhere = null;
        if (!"Y".equalsIgnoreCase(adminYn)) {
            addWhere = "corp_gr = '" + corpGr + "'";
        }

        var corpList = dddwService.getDddwList("CORP_GR", 1, addWhere, null, session);

        model.addAttribute("corpGr", corpGr);
        model.addAttribute("trYmd", trYmd);
        model.addAttribute("adminYn", adminYn);
        model.addAttribute("corpList", corpList);
        model.addAttribute("dataList", ja010dService.getJa010dList(corpGr, trYmd));
        model.addAttribute("trDates", ja010dService.getTrDates(corpGr));

        var menuDto = menuService.getMenuByPgmId("w_ja010d");
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : null;
        model.addAttribute("fullpgm2", fullpgm2);

        return "views/ja010/w_ja010d";
    }

    @GetMapping("/api/account/ja010d/list")
    @ResponseBody
    public List<Ja010dDto> getJa010dList(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "trYmd", required = false) String paramTrYmd,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        String trYmd = (paramTrYmd != null && !paramTrYmd.isBlank()) ? paramTrYmd
                : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        return ja010dService.getJa010dList(corpGr, trYmd);
    }

    @GetMapping("/api/account/ja010d/dates")
    @ResponseBody
    public List<String> getTrDates(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        return ja010dService.getTrDates(corpGr);
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr;
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr;
        }
        if (principal != null && principal.getCorpGr() != null) {
            return principal.getCorpGr();
        }
        return "2200";
    }
}
