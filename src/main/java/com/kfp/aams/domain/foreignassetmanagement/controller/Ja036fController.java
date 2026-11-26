package com.kfp.aams.domain.foreignassetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036fDto;
import com.kfp.aams.domain.foreignassetmanagement.service.Ja036fService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

/**
 * W_JA036F 외화자산 조회 컨트롤러
 */
@Controller
@RequiredArgsConstructor
public class Ja036fController {

    private final Ja036fService service;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    @GetMapping({"/views/w_ja036f", "/views/foreignassetmanagement/w_ja036f"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @RequestParam(required = false) String ymd,
                       @RequestParam(required = false, defaultValue = "1") String accountType,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        String selectedYmd = (ymd == null || ymd.isBlank()) ? workDate : ymd;
        String resolvedAccountType = "2".equals(accountType) ? "2" : "1";
        var menu = menuService.getMenuByPgmId("W_JA036F");

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", selectedYmd);
        model.addAttribute("ymd", selectedYmd);
        model.addAttribute("initialAccountType", resolvedAccountType);
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "사무관리 > 외화자산운용 > 외화자산운용 > 외화 자산조회");
        return "views/foreignassetmanagement/w_ja036f";
    }

    @GetMapping("/api/foreignassetmanagement/ja036f/list")
    @ResponseBody
    public List<Ja036fDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                @RequestParam(required = false) String corpGr,
                                @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                @RequestParam String ymd,
                                @RequestParam(required = false, defaultValue = "1") String accountType) {
        return service.getList(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, accountType);
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
