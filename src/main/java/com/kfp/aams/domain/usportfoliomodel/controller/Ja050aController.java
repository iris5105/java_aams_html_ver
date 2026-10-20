package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja050aFundDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja050aService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
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
 * Controller for W_JA050A (손익현황(원장) / 가격대장)
 */
@Controller
public class Ja050aController {

    private static final Logger log = LoggerFactory.getLogger(Ja050aController.class);

    private final Ja050aService ja050aService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    public Ja050aController(Ja050aService ja050aService, MenuService menuService, WorkDateService workDateService) {
        this.ja050aService = ja050aService;
        this.menuService = menuService;
        this.workDateService = workDateService;
    }

    /**
     * 뷰 렌더링
     */
    @GetMapping({"/views/w_ja050a", "/views/usportfoliomodel/w_ja050a", "/views/ledgerinquiry/w_ja050a"})
    public String viewJa050a(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA050A");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja050a");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 손익현황(원장)[ w_ja050a ]";

        // DB 영업일자 연동 필수 (WorkDateService)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : workDateService.getWorkDateOrDefault(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja050a";
    }

    /**
     * 고객(펀드) 목록 조회 API (d_ja050a1)
     */
    @GetMapping({"/api/usportfoliomodel/ja050a/funds", "/api/ledgerinquiry/ja050a/funds"})
    @ResponseBody
    public ResponseEntity<List<Ja050aFundDto>> getFundList(
            @RequestParam(name = "corpGr") String corpGr,
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "mgCd", required = false, defaultValue = "%") String mgCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }
        List<Ja050aFundDto> list = ja050aService.getFundList(corpGr, ymd, mgCd);
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
