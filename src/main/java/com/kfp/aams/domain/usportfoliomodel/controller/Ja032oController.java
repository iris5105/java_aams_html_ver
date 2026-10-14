package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032oDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032oFundDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032oOrderCreateRequestDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032oService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * Controller for W_JA032O (파생 환매수 운용지시)
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja032oController {

    private final Ja032oService ja032oService;
    private final MenuService menuService;
    private final com.kfp.aams.common.service.WorkDateService workDateService;

    /**
     * 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032o", "/views/usportfoliomodel/w_ja032o"})
    public String viewJa032o(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA032O");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032o");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 파생 환매수 운용지시";

        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : workDateService.getWorkDateOrDefault(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja032o";
    }

    /**
     * 1. 펀드/포트 만기별 목록 조회 API (d_ja032o1)
     */
    @GetMapping("/api/usportfoliomodel/ja032o/funds")
    @ResponseBody
    public List<Ja032oFundDto> getFundList(@RequestParam(name = "corpGr") String corpGr,
                                           @RequestParam(name = "ymd") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate ymd) {
        return ja032oService.getFundList(corpGr, ymd);
    }

    /**
     * 2. 파생상품 보유 내역 및 환매수 주문 생성 목록 조회 API (d_ja032o2)
     */
    @GetMapping("/api/usportfoliomodel/ja032o/details")
    @ResponseBody
    public List<Ja032oDetailDto> getDetailList(@RequestParam(name = "corpGr") String corpGr,
                                               @RequestParam(name = "ymd") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate ymd,
                                               @RequestParam(name = "fundCd") String fundCd,
                                               @RequestParam(name = "portNum") String portNum) {
        return ja032oService.getDetailList(corpGr, ymd, fundCd, portNum);
    }

    /**
     * 3. 환매수 주문생성 실행 API (cb_syt0mg)
     */
    @PostMapping("/api/usportfoliomodel/ja032o/create-orders")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createRepurchaseOrders(@RequestBody Ja032oOrderCreateRequestDto req) {
        return ResponseEntity.ok(ja032oService.createRepurchaseOrders(req));
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return "";
    }
}
