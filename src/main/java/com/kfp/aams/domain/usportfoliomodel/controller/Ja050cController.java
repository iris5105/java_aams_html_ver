package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja050cFundDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja050cService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

/**
 * Controller for W_JA050C (손익 상세현황 / 분개장)
 */
@Controller
public class Ja050cController {

    private static final Logger log = LoggerFactory.getLogger(Ja050cController.class);

    private final Ja050cService ja050cService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    public Ja050cController(Ja050cService ja050cService, MenuService menuService, WorkDateService workDateService) {
        this.ja050cService = ja050cService;
        this.menuService = menuService;
        this.workDateService = workDateService;
    }

    /**
     * 뷰 렌더링
     */
    @GetMapping({"/views/w_ja050c", "/views/usportfoliomodel/w_ja050c", "/views/ledgerinquiry/w_ja050c"})
    public String viewJa050c(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA050C");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja050c");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 손익 상세현황(분개장)[ w_ja050c ]";

        // DB 영업일자 연동 필수 (WorkDateService)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : workDateService.getWorkDateOrDefault(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja050c";
    }

    /**
     * 고객(펀드) 목록 조회 API (d_fund_select)
     */
    @GetMapping({"/api/usportfoliomodel/ja050c/funds", "/api/ledgerinquiry/ja050c/funds"})
    @ResponseBody
    public ResponseEntity<List<Ja050cFundDto>> getFundList(
            @RequestParam(name = "corpGr") String corpGr,
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "procStep", required = false, defaultValue = "1") String procStep) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }
        List<Ja050cFundDto> list = ja050cService.getFundList(corpGr, ymd, procStep);
        return ResponseEntity.ok(list);
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
