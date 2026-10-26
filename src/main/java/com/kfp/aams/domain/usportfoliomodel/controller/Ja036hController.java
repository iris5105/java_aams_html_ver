package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;

/**
 * Controller for W_JA036H (외화증권 매매내역)
 * 단독 리포트 뷰어 (rd_ja036h.mrd) 화면
 */
@Controller
public class Ja036hController {

    private static final Logger log = LoggerFactory.getLogger(Ja036hController.class);

    private final MenuService menuService;
    private final WorkDateService workDateService;

    public Ja036hController(MenuService menuService, WorkDateService workDateService) {
        this.menuService = menuService;
        this.workDateService = workDateService;
    }

    /**
     * 뷰 렌더링
     */
    @GetMapping({"/views/w_ja036h", "/views/usportfoliomodel/w_ja036h", "/views/foreignassetmanagement/w_ja036h"})
    public String viewJa036h(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "fymd", required = false) String paramFymd,
                             @RequestParam(name = "tymd", required = false) String paramTymd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA036H");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja036h");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 외화증권 매매내역[ w_ja036h ]";

        // DB 기준 작업일자 연동 (WorkDateService)
        String workDate = workDateService.getWorkDateOrDefault(corpGr);
        LocalDate toDate;
        try {
            toDate = LocalDate.parse(workDate.replace(".", "-"));
        } catch (Exception e) {
            toDate = LocalDate.now();
        }
        LocalDate fromDate = toDate.minusMonths(3);

        String initialFymd = (paramFymd != null && !paramFymd.isBlank()) ? paramFymd : fromDate.toString();
        String initialTymd = (paramTymd != null && !paramTymd.isBlank()) ? paramTymd : toDate.toString();

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialFymd", initialFymd);
        model.addAttribute("initialTymd", initialTymd);
        model.addAttribute("fYmd", initialFymd);
        model.addAttribute("tYmd", initialTymd);
        model.addAttribute("fymd", initialFymd);
        model.addAttribute("tymd", initialTymd);

        return "views/usportfoliomodel/w_ja036h";
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, Object principalObj) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr.trim();
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr.trim();
        }
        if (principalObj instanceof UserPrincipal principal) {
            if (principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
                return principal.getCorpGr().trim();
            }
        }
        return "";
    }
}
