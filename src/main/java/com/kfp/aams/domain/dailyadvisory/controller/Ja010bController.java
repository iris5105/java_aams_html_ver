package com.kfp.aams.domain.dailyadvisory.controller;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010bDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010bIoDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010bMasterDto;
import com.kfp.aams.domain.dailyadvisory.service.Ja010bService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class Ja010bController {

    private final Ja010bService ja010bService;
    private final com.kfp.aams.menu.service.MenuService menuService;
    private final com.kfp.aams.common.service.DddwService dddwService;

    @GetMapping({"/views/w_ja010b", "/views/dailyadvisory/w_ja010b"})
    public String viewJa010b(@AuthenticationPrincipal Object principalObj,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
            Model model,
            jakarta.servlet.http.HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        String adminYn = (principal != null && principal.getAdminYn() != null) ? principal.getAdminYn() : "N";

        String addWhere = null;
        if (!"Y".equalsIgnoreCase(adminYn)) {
            addWhere = "corp_gr = '" + corpGr + "'";
        }

        var corpList = dddwService.getDddwList("CORP_GR", 1, addWhere, null, session);

        model.addAttribute("corpGr", corpGr);
        model.addAttribute("adminYn", adminYn);
        model.addAttribute("corpList", corpList);
        model.addAttribute("masterList", ja010bService.getMasterList(corpGr));

        var menuDto = menuService.getMenuByPgmId("w_ja010b");
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : null;
        model.addAttribute("fullpgm2", fullpgm2);

        return "views/dailyadvisory/w_ja010b";
    }

    @GetMapping("/api/account/ja010b/master")
    @ResponseBody
    public List<Ja010bMasterDto> getMasterList(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        return ja010bService.getMasterList(corpGr);
    }

    @GetMapping("/api/account/ja010b/next-fund-cd")
    @ResponseBody
    public java.util.Map<String, String> getNextFundCd(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        return java.util.Map.of("nextFundCd", ja010bService.getNextFundCd(corpGr));
    }

    @GetMapping("/api/account/ja010b/detail")
    @ResponseBody
    public List<Ja010bDetailDto> getDetailList(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
            @RequestParam(name = "fundCd") String fundCd) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        return ja010bService.getDetailList(corpGr, fundCd);
    }

    @GetMapping("/api/account/ja010b/io")
    @ResponseBody
    public List<Ja010bIoDto> getIoList(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
            @RequestParam(name = "fundCd") String fundCd) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        return ja010bService.getIoList(corpGr, fundCd);
    }

    @org.springframework.web.bind.annotation.PostMapping("/api/account/ja010b/save")
    @ResponseBody
    public java.util.Map<String, Object> saveJa010b(@AuthenticationPrincipal Object principalObj,
            @org.springframework.web.bind.annotation.RequestBody com.kfp.aams.domain.dailyadvisory.dto.Ja010bSaveRequestDto request) {
        try {
            UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
            String modUser = "SYSTEM";
            if (principal != null) {
                modUser = principal.getEmail();
            } else {
                var auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
                if (auth != null && auth.getPrincipal() instanceof UserPrincipal p) {
                    modUser = p.getEmail();
                }
            }

            if (request.getCorpGr() == null || request.getCorpGr().isBlank()) {
                if (principal != null && principal.getCorpGr() != null) {
                    request.setCorpGr(principal.getCorpGr());
                }
            }
            ja010bService.saveJa010b(request, modUser);
            return java.util.Map.of("success", true, "message", "정상적으로 저장되었습니다.");
        } catch (Exception e) {
            return java.util.Map.of("success", false, "message", "저장 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr;
        }
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr();
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr;
        }
        return "";
    }
}
