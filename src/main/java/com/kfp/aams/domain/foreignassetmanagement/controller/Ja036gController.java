package com.kfp.aams.domain.foreignassetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036gDetailDto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036gMasterDto;
import com.kfp.aams.domain.foreignassetmanagement.service.Ja036gService;
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
 * W_JA036G 외화자산 보유현황(종목/기간별) 컨트롤러
 */
@Controller
@RequiredArgsConstructor
public class Ja036gController {

    private final Ja036gService service;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    @GetMapping({"/views/w_ja036g", "/views/foreignassetmanagement/w_ja036g"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @RequestParam(required = false) String fYmd,
                       @RequestParam(required = false) String tYmd,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        String defaultTYmd = (tYmd == null || tYmd.isBlank()) ? workDate : tYmd;
        String defaultFYmd = (fYmd == null || fYmd.isBlank()) ? toFirstDayOfMonth(defaultTYmd) : fYmd;
        var menu = menuService.getMenuByPgmId("W_JA036G");

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fYmd", defaultFYmd);
        model.addAttribute("tYmd", defaultTYmd);
        model.addAttribute("initialFYmd", defaultFYmd);
        model.addAttribute("initialTYmd", defaultTYmd);
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "사무관리 > 외화자산운용 > 외화자산운용 > 외화자산 보유현황(종목/기간별)");
        return "views/foreignassetmanagement/w_ja036g";
    }

    @GetMapping("/api/foreignassetmanagement/ja036g/master")
    @ResponseBody
    public List<Ja036gMasterDto> master(@AuthenticationPrincipal UserPrincipal principal,
                                        @RequestParam(required = false) String corpGr,
                                        @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                        @RequestParam String fYmd,
                                        @RequestParam String tYmd) {
        return service.getMasterList(resolveCorpGr(principal, corpGr, savedCorpGr), fYmd, tYmd);
    }

    @GetMapping("/api/foreignassetmanagement/ja036g/detail")
    @ResponseBody
    public List<Ja036gDetailDto> detail(@AuthenticationPrincipal UserPrincipal principal,
                                        @RequestParam(required = false) String corpGr,
                                        @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                        @RequestParam String fYmd,
                                        @RequestParam String tYmd,
                                        @RequestParam String fundCd,
                                        @RequestParam String jmCd) {
        return service.getDetailList(resolveCorpGr(principal, corpGr, savedCorpGr), fYmd, tYmd, fundCd, jmCd);
    }

    private String toFirstDayOfMonth(String ymd) {
        if (ymd == null || ymd.isBlank()) return "";
        String trimmed = ymd.trim();
        if (trimmed.length() >= 8 && trimmed.contains("-")) {
            return trimmed.substring(0, 8) + "01";
        }
        if (trimmed.length() == 8) {
            return trimmed.substring(0, 6) + "01";
        }
        return trimmed;
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
