package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.domain.usportfoliomodel.dto.*;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032eCallService;
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

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * Controller for W_JA032E_CALL (USPM 운용지시 CALL배분작업)
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja032eCallController {

    private final Ja032eCallService ja032eCallService;
    private final MenuService menuService;
    private final com.kfp.aams.common.service.WorkDateService workDateService;

    /**
     * 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032e_call", "/views/usportfoliomodel/w_ja032e_call"})
    public String viewJa032eCall(@AuthenticationPrincipal Object principalObj,
                                 @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                 @RequestParam(name = "ymd", required = false) String paramYmd,
                                 @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                 @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                                 Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA032E_CALL");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032e_call");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > USPM 운용지시 CALL배분작업";

        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : workDateService.getWorkDateOrDefault(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja032e_call";
    }

    /**
     * 1. 펀드/포트 목록 조회 API (d_ja032e1_call)
     */
    @GetMapping("/api/usportfoliomodel/ja032e-call/funds")
    @ResponseBody
    public List<Ja032eCallFundDto> getFundList(@RequestParam(name = "corpGr") String corpGr,
                                               @RequestParam(name = "ymd") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate ymd) {
        return ja032eCallService.getFundList(corpGr, ymd);
    }

    /**
     * 2. 포트 내 종목 설정 목록 조회 API (d_ja032e2_call)
     */
    @GetMapping("/api/usportfoliomodel/ja032e-call/ports")
    @ResponseBody
    public List<Ja032eCallPortDto> getPortList(@RequestParam(name = "corpGr") String corpGr,
                                               @RequestParam(name = "fundCd") String fundCd,
                                               @RequestParam(name = "ymd") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate ymd,
                                               @RequestParam(name = "portNum") String portNum) {
        return ja032eCallService.getPortList(corpGr, fundCd, ymd, portNum);
    }

    /**
     * 3. 해외옵션 상세 시세 및 주문 목록 조회 API (d_ja032e3_call)
     */
    @GetMapping("/api/usportfoliomodel/ja032e-call/details")
    @ResponseBody
    public List<Ja032eCallDetailDto> getDetailList(@RequestParam(name = "corpGr") String corpGr,
                                                   @RequestParam(name = "ymd") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate ymd,
                                                   @RequestParam(name = "mangiYmd") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate mangiYmd,
                                                   @RequestParam(name = "srsCd") String srsCd,
                                                   @RequestParam(name = "targetReturnPer", required = false) BigDecimal targetReturnPer,
                                                   @RequestParam(name = "jonga", required = false) BigDecimal jonga) {
        return ja032eCallService.getDetailList(corpGr, ymd, mangiYmd, srsCd, targetReturnPer, jonga);
    }

    /**
     * TT 세부코드명 조회 API
     */
    @GetMapping("/api/usportfoliomodel/ja032e-call/tt-title")
    @ResponseBody
    public Map<String, String> getTtTitle(@RequestParam(name = "tt") String tt) {
        return Map.of("title", ja032eCallService.getTtTitle(tt));
    }

    /**
     * 4. 설정 저장 API
     */
    @PostMapping("/api/usportfoliomodel/ja032e-call/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveSettings(@RequestBody Ja032eCallSaveRequestDto req) {
        return ResponseEntity.ok(ja032eCallService.saveSettings(req));
    }

    /**
     * 5. CALL 배분생성 API
     */
    @PostMapping("/api/usportfoliomodel/ja032e-call/create-orders")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createCallOrders(@RequestBody Ja032eCallOrderCreateRequestDto req) {
        return ResponseEntity.ok(ja032eCallService.createCallOrders(req));
    }

    /**
     * 6. 변동성 재계산 API
     */
    @PostMapping("/api/usportfoliomodel/ja032e-call/recalculate")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> recalculate(@RequestBody Map<String, String> body) {
        String corpGr = body.get("corpGr");
        String ymd = body.get("ymd");
        return ResponseEntity.ok(ja032eCallService.recalculateVolatility(corpGr, ymd));
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
