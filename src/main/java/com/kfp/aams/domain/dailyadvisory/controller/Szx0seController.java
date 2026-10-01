package com.kfp.aams.domain.dailyadvisory.controller;

import com.kfp.aams.domain.dailyadvisory.dto.Szx0seDto;
import com.kfp.aams.domain.dailyadvisory.service.Szx0seService;
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
public class Szx0seController {

    private final Szx0seService szx0seService;
    private final com.kfp.aams.menu.service.MenuService menuService;
    private final com.kfp.aams.common.service.DddwService dddwService;

    @GetMapping({"/views/w_szx0se", "/views/dailyadvisory/w_szx0se"})
    public String viewSzx0se(@AuthenticationPrincipal Object principalObj,
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
        model.addAttribute("dataList", szx0seService.getSzx0seList(corpGr));

        var menuDto = menuService.getMenuByPgmId("w_szx0se");
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : null;
        model.addAttribute("fullpgm2", fullpgm2);

        return "views/dailyadvisory/w_szx0se";
    }

    @GetMapping("/api/account/szx0se/list")
    @ResponseBody
    public List<Szx0seDto> getSzx0seList(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        return szx0seService.getSzx0seList(corpGr);
    }

    @org.springframework.web.bind.annotation.PostMapping("/api/account/szx0se/save")
    @ResponseBody
    public java.util.Map<String, Object> saveSzx0se(
            @org.springframework.web.bind.annotation.RequestBody com.kfp.aams.domain.dailyadvisory.dto.Szx0seSaveRequestDto saveDto,
            @AuthenticationPrincipal UserPrincipal principal,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        try {
            String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
            String corpGr = resolveCorpGr(saveDto.getCorpGr(), cookieCorpGr, principal);
            saveDto.setCorpGr(corpGr);

            szx0seService.saveSzx0se(saveDto);
            return java.util.Map.of("success", true, "message", "저장이 완료되었습니다.");
        } catch (Exception e) {
            return java.util.Map.of("success", false, "message", "저장 중 오류 발생: " + e.getMessage());
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr;
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr();
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr;
        return "";
    }
}
