package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.domain.subscriptionrights.dto.Ja020fDto;
import com.kfp.aams.domain.subscriptionrights.service.Ja020fService;
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
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * W_JA020F (권리보유 원장현황) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja020fController {

    private final Ja020fService service;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja020f", "/views/subscriptionrights/w_ja020f"})
    public String view(@AuthenticationPrincipal Object principalObj,
                       @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                       @RequestParam(name = "ymd", required = false) String paramYmd,
                       @RequestParam(name = "rcd", required = false) String paramRcd,
                       @RequestParam(name = "rcdNm", required = false) String paramRcdNm,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       @CookieValue(name = "corpGr", required = false) String cookieCorpGr,
                       Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String corpGr = resolveCorpGr(paramCorpGr, savedCorpGr, cookieCorpGr, principal);
        String workDate = service.getWorkDate(corpGr);
        String initialYmd = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd.trim() : workDate;

        var menu = menuService.getMenuByPgmId("W_JA020F");
        if (menu == null) {
            menu = menuService.getMenuByPgmId("w_ja020f");
        }
        String fullpgm2 = (menu != null && menu.getFullpgm2() != null)
                ? menu.getFullpgm2()
                : "사무관리 > 공모청약(권리) > 공모청약(권리)관리 > 권리보유 원장현황";

        boolean directRetrieve = (paramRcd != null && !paramRcd.isBlank());
        String initialRcd = directRetrieve ? paramRcd.trim() : "%";
        String initialRcdNm = (paramRcdNm != null && !paramRcdNm.isBlank()) ? paramRcdNm.trim() : "전체";

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", initialYmd);
        model.addAttribute("ymd", initialYmd);
        model.addAttribute("initialRcd", initialRcd);
        model.addAttribute("initialRcdNm", initialRcdNm);
        model.addAttribute("directRetrieve", directRetrieve);

        return "views/subscriptionrights/w_ja020f";
    }

    @GetMapping("/api/subscriptionrights/ja020f/list")
    @ResponseBody
    public ResponseEntity<List<Ja020fDto>> list(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
            @RequestParam(name = "rcd", defaultValue = "%") String rcd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String corpGr = resolveCorpGr(paramCorpGr, savedCorpGr, cookieCorpGr, principal);
        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }
        boolean isAdmin = principal != null && "Y".equalsIgnoreCase(principal.getAdminYn());

        return ResponseEntity.ok(service.getList(corpGr, isAdmin, ymd, rcd));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> handleInvalid(IllegalArgumentException ex) {
        return ResponseEntity.badRequest().body(Map.of("success", false, "message", ex.getMessage()));
    }

    private String resolveCorpGr(String paramCorpGr, String savedCorpGr, String cookieCorpGr, UserPrincipal principal) {
        for (String val : new String[]{paramCorpGr, savedCorpGr, cookieCorpGr,
                principal != null ? principal.getCorpGr() : null}) {
            if (val != null && !val.isBlank()) {
                return val.trim();
            }
        }
        return "";
    }
}

