package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cBetaDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cGreeksDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cGreeksRecalcRequest;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cPortDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cUpDownDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cVolatilityDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032cService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

/**
 * USPM 포트폴리오 모델 변동성분석 (W_JA032C) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja032cController {

    private final Ja032cService ja032cService;
    private final MenuService menuService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032c", "/views/usportfoliomodel/w_ja032c"})
    public String viewJa032c(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String principalCorpGr = null;
        if (principalObj instanceof UserPrincipal principal) {
            principalCorpGr = principal.getCorpGr();
        }

        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalCorpGr);

        var menuDto = menuService.getMenuByPgmId("W_JA032C");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032c");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > USPM 변동성 추이";

        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja032cService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = LocalDate.now().toString();
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("workDate", workDate);
        model.addAttribute("ymd", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("corpGr", corpGr);

        return "views/usportfoliomodel/w_ja032c";
    }

    /**
     * 1. 펀드/포트 목록 조회 API (d_ja032c1.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032c/port-list")
    @ResponseBody
    public ResponseEntity<List<Ja032cPortDto>> getPortList(@RequestParam("corpGr") String corpGr,
                                                           @RequestParam("ymd") String ymd) {
        List<Ja032cPortDto> list = ja032cService.getPortList(corpGr, ymd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 2. 포트 내 종목 상세 현황 조회 API (d_ja032c2.srd / d_ja032c2_krx.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032c/detail-list")
    @ResponseBody
    public ResponseEntity<List<Ja032cDetailDto>> getDetailList(@RequestParam("corpGr") String corpGr,
                                                               @RequestParam("ymd") String ymd,
                                                               @RequestParam("fundCd") String fundCd,
                                                               @RequestParam("portNum") String portNum,
                                                               @RequestParam(name = "tt", required = false, defaultValue = "") String tt) {
        List<Ja032cDetailDto> list = ja032cService.getDetailList(corpGr, ymd, fundCd, portNum, tt);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 3. 변동수준 / 괴리율 분석 조회 API (d_ja032c3.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032c/volatility-list")
    @ResponseBody
    public ResponseEntity<List<Ja032cVolatilityDto>> getVolatilityList(@RequestParam("corpGr") String corpGr,
                                                                       @RequestParam("jmCd") String jmCd,
                                                                       @RequestParam("fymd") String fymd,
                                                                       @RequestParam("tymd") String tymd,
                                                                       @RequestParam(name = "type", required = false, defaultValue = "변동수준") String type) {
        List<Ja032cVolatilityDto> list = ja032cService.getVolatilityList(corpGr, jmCd, fymd, tymd, type);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 4. 베타 분석 조회 API (d_ja032c3_beta.srd / d_ja032c3_beta_krx.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032c/beta-list")
    @ResponseBody
    public ResponseEntity<List<Ja032cBetaDto>> getBetaList(@RequestParam("corpGr") String corpGr,
                                                           @RequestParam(name = "tt", required = false, defaultValue = "") String tt,
                                                           @RequestParam("jmCd") String jmCd,
                                                           @RequestParam("fymd") String fymd,
                                                           @RequestParam("tymd") String tymd) {
        List<Ja032cBetaDto> list = ja032cService.getBetaList(corpGr, tt, jmCd, fymd, tymd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 5. 상승/하락일수 분석 조회 API (d_ja032c3_ud.srd / d_ja032c3_ud_krx.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032c/updown-list")
    @ResponseBody
    public ResponseEntity<List<Ja032cUpDownDto>> getUpDownList(@RequestParam("corpGr") String corpGr,
                                                               @RequestParam(name = "tt", required = false, defaultValue = "") String tt,
                                                               @RequestParam("jmCd") String jmCd,
                                                               @RequestParam("fymd") String fymd,
                                                               @RequestParam("tymd") String tymd) {
        List<Ja032cUpDownDto> list = ja032cService.getUpDownList(corpGr, tt, jmCd, fymd, tymd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 6. 델타/감마/세타/베가/로 (Option Greeks) 분석 조회 API (d_ja032c3_dgtvr.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032c/greeks")
    @ResponseBody
    public ResponseEntity<Ja032cGreeksDto> getOptionGreeks(@RequestParam("corpGr") String corpGr,
                                                           @RequestParam("ymd") String ymd,
                                                           @RequestParam("fundCd") String fundCd,
                                                           @RequestParam("portNum") String portNum,
                                                           @RequestParam("jmCd") String jmCd,
                                                           @RequestParam(name = "srsCd", required = false) String srsCd,
                                                           @RequestParam(name = "mangi", required = false) String mangi) {
        Ja032cGreeksDto dto = ja032cService.getOptionGreeks(corpGr, ymd, fundCd, portNum, jmCd, srsCd, mangi);
        return ResponseEntity.ok(dto);
    }

    /**
     * 7. 옵션 그릭스 실시간 동적 재계산 API
     */
    @PostMapping("/api/usportfoliomodel/ja032c/recalc-greeks")
    @ResponseBody
    public ResponseEntity<Ja032cGreeksDto> recalcGreeks(@RequestBody Ja032cGreeksRecalcRequest req) {
        Ja032cGreeksDto dto = ja032cService.recalcGreeks(
                req.getS(), req.getT(), req.getK(), req.getR(),
                req.getMarketPrice(), req.getImpVolatility(), req.isPriceChanged()
        );
        return ResponseEntity.ok(dto);
    }

    /**
     * 회사그룹(corp_gr) 파라미터 추출 (Zero-Hardcoding 원칙)
     */
    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, String principalCorpGr) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr.trim();
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr.trim();
        }
        if (principalCorpGr != null && !principalCorpGr.isBlank()) {
            return principalCorpGr.trim();
        }
        return "";
    }
}
