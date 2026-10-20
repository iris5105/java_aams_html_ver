package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032kFundDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032kService;
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
import java.util.Map;

/**
 * Controller for W_JA032K (자산현황)
 */
@Controller
public class Ja032kController {

    private static final Logger log = LoggerFactory.getLogger(Ja032kController.class);

    private final Ja032kService ja032kService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    public Ja032kController(Ja032kService ja032kService, MenuService menuService, WorkDateService workDateService) {
        this.ja032kService = ja032kService;
        this.menuService = menuService;
        this.workDateService = workDateService;
    }

    /**
     * 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032k", "/views/usportfoliomodel/w_ja032k"})
    public String viewJa032k(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA032K");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032k");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 자산현황[ w_ja032k ]";

        // DB 영업일자 연동 필수 (WorkDateService)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : workDateService.getWorkDateOrDefault(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja032k";
    }

    /**
     * 펀드 목록 조회 API (d_ja036e)
     */
    @GetMapping("/api/usportfoliomodel/ja032k/funds")
    @ResponseBody
    public ResponseEntity<List<Ja032kFundDto>> getFundList(
            @RequestParam(name = "corpGr") String corpGr,
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "mgCd", required = false, defaultValue = "%") String mgCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }
        List<Ja032kFundDto> list = ja032kService.getFundList(corpGr, ymd, mgCd);
        return ResponseEntity.ok(list);
    }

    /**
     * 증권사 선택 드롭다운 목록 API
     */
    @GetMapping("/api/usportfoliomodel/ja032k/brokers")
    @ResponseBody
    public ResponseEntity<List<Map<String, String>>> getBrokerList(
            @RequestParam(name = "corpGr") String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }
        List<Map<String, String>> list = ja032kService.getBrokerList(corpGr);
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
