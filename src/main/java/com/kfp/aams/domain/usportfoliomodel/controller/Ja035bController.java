package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja035bDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja035bService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * 해외 주식 PORT 매매관리 (W_JA035B) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja035bController {

    private final Ja035bService ja035bService;
    private final MenuService menuService;

    /**
     * 뷰 렌더링
     */
    @GetMapping({"/views/w_ja035b", "/views/usportfoliomodel/w_ja035b"})
    public String viewJa035b(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             Model model) {
        String corpGr = resolveCorpGr(paramCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA035B");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja035b");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 3510 해외주식 PORT 매매관리[ w_ja035b ]";

        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja035b";
    }

    /**
     * 해외주식 매매내역 목록 조회 API (d_ja035b)
     */
    @GetMapping("/api/usportfoliomodel/ja035b/list")
    @ResponseBody
    public ResponseEntity<List<Ja035bDto>> getList(@RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                   @RequestParam("ymd") String ymd,
                                                   @RequestParam(name = "trCd", required = false) String trCd,
                                                   @RequestParam(name = "fundCd", required = false) String fundCd,
                                                   @AuthenticationPrincipal Object principalObj) {
        String corpGr = resolveCorpGr(paramCorpGr, principalObj);
        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }
        List<Ja035bDto> list = ja035bService.getList(corpGr, ymd, trCd, fundCd);
        return ResponseEntity.ok(list);
    }

    /**
     * 해외주식 잔고 목록 조회 API (매도 시 보유종목 자동 불러오기용)
     */
    @GetMapping("/api/usportfoliomodel/ja035b/balance")
    @ResponseBody
    public ResponseEntity<List<Ja035bDto>> getBalanceList(@RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                          @RequestParam("ymd") String ymd,
                                                          @RequestParam("fundCd") String fundCd,
                                                          @AuthenticationPrincipal Object principalObj) {
        String corpGr = resolveCorpGr(paramCorpGr, principalObj);
        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }
        List<Ja035bDto> list = ja035bService.getBalanceList(corpGr, ymd, fundCd);
        return ResponseEntity.ok(list);
    }

    /**
     * 당일 최대 TR_SEQ 조회 API
     */
    @GetMapping("/api/usportfoliomodel/ja035b/max-trseq")
    @ResponseBody
    public ResponseEntity<Long> getMaxTrSeq(@RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                            @RequestParam("ymd") String ymd,
                                            @RequestParam(name = "fundCd", required = false) String fundCd,
                                            @AuthenticationPrincipal Object principalObj) {
        String corpGr = resolveCorpGr(paramCorpGr, principalObj);
        Long maxSeq = ja035bService.getMaxTrSeq(corpGr, ymd, fundCd);
        return ResponseEntity.ok(maxSeq != null ? maxSeq : 0L);
    }

    /**
     * 통화별 환율 조회 API (F_CURRENCY_RT)
     */
    @GetMapping("/api/usportfoliomodel/ja035b/currency-rate")
    @ResponseBody
    public ResponseEntity<BigDecimal> getCurrencyRate(@RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                      @RequestParam("ymd") String ymd,
                                                      @RequestParam("currency") String currency,
                                                      @AuthenticationPrincipal Object principalObj) {
        String corpGr = resolveCorpGr(paramCorpGr, principalObj);
        BigDecimal rate = ja035bService.getCurrencyRate(corpGr, ymd, currency);
        return ResponseEntity.ok(rate != null ? rate : BigDecimal.ZERO);
    }

    /**
     * 보관처 기본 통화 조회 API
     */
    @GetMapping("/api/usportfoliomodel/ja035b/trustee-currency")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getTrusteeCurrency(@RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                                  @RequestParam("trustee") String trustee,
                                                                  @AuthenticationPrincipal Object principalObj) {
        String corpGr = resolveCorpGr(paramCorpGr, principalObj);
        String currency = ja035bService.getTrusteeCurrency(corpGr, trustee);
        return ResponseEntity.ok(Collections.singletonMap("currency", currency != null ? currency : ""));
    }

    /**
     * 종목 정보 단건 조회 API (SYM0YA)
     */
    @GetMapping("/api/usportfoliomodel/ja035b/item-info")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getItemInfo(@RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                           @RequestParam("jmCd") String jmCd,
                                                           @AuthenticationPrincipal Object principalObj) {
        String corpGr = resolveCorpGr(paramCorpGr, principalObj);
        Map<String, Object> info = ja035bService.getItemInfo(corpGr, jmCd);
        return ResponseEntity.ok(info != null ? info : Collections.emptyMap());
    }

    /**
     * 매매내역 CUD 저장 API
     */
    @PostMapping("/api/usportfoliomodel/ja035b/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveList(@RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                        @RequestBody List<Ja035bDto> dtoList,
                                                        @AuthenticationPrincipal Object principalObj) {
        String corpGr = resolveCorpGr(paramCorpGr, principalObj);
        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "회사그룹(corpGr) 정보가 누락되었습니다."));
        }
        Map<String, Object> result = ja035bService.saveList(corpGr, dtoList);
        return ResponseEntity.ok(result);
    }

    private String resolveCorpGr(String paramCorpGr, Object principalObj) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr;
        }
        if (principalObj instanceof UserPrincipal userPrincipal) {
            return userPrincipal.getCorpGr();
        }
        return null;
    }
}
