package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bOptDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bOptFundDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bOptStockDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032bOptService;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 기준정보 옵션위험값 일별현황 (W_JA032B_OPT) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja032bOptController {

    private final Ja032bOptService ja032bOptService;
    private final MenuService menuService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032b_opt", "/views/usportfoliomodel/w_ja032b_opt"})
    public String viewJa032bOpt(@AuthenticationPrincipal Object principalObj,
                                @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                @RequestParam(name = "ymd", required = false) String paramYmd,
                                @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                                Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA032B_OPT");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032b_opt");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 기준정보 옵션위험값 일별현황";

        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja032bOptService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = LocalDate.now().toString();
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("workDate", workDate);
        model.addAttribute("corpGr", corpGr);

        return "views/usportfoliomodel/w_ja032b_opt";
    }

    /**
     * 포트 시작일(fymd) 조회 API
     */
    @GetMapping("/api/usportfoliomodel/ja032b-opt/fymd")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getFymd(@RequestParam("corpGr") String corpGr,
                                                       @RequestParam("ymd") String ymd) {
        String fymd = ja032bOptService.getFymd(corpGr, ymd);
        Map<String, String> result = new HashMap<>();
        result.put("fymd", fymd);
        return ResponseEntity.ok(result);
    }

    /**
     * 1. 펀드 목록 조회 API (d_ja032n1.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032b-opt/fund-list")
    @ResponseBody
    public ResponseEntity<List<Ja032bOptFundDto>> getFundList(@RequestParam("corpGr") String corpGr,
                                                              @RequestParam("ymd") String ymd) {
        List<Ja032bOptFundDto> list = ja032bOptService.getFundList(corpGr, ymd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 2. 종목 목록 조회 API (d_ja032b.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032b-opt/stock-list")
    @ResponseBody
    public ResponseEntity<List<Ja032bOptStockDto>> getStockList(@RequestParam("corpGr") String corpGr,
                                                                @RequestParam(name = "fymd", required = false) String fymd,
                                                                @RequestParam("tymd") String tymd,
                                                                @RequestParam("fundCd") String fundCd) {
        List<Ja032bOptStockDto> list = ja032bOptService.getStockList(corpGr, fymd, tymd, fundCd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 3. 옵션위험값 일별현황 상세 조회 API (d_ja032b_opt.srd / d_ja032b_opt_krx.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032b-opt/detail-list")
    @ResponseBody
    public ResponseEntity<List<Ja032bOptDetailDto>> getDetailList(@RequestParam("corpGr") String corpGr,
                                                                  @RequestParam("fundCd") String fundCd,
                                                                  @RequestParam("jmCd") String jmCd,
                                                                  @RequestParam(name = "fymd", required = false) String fymd,
                                                                  @RequestParam("tymd") String tymd) {
        List<Ja032bOptDetailDto> list = ja032bOptService.getDetailList(corpGr, fundCd, jmCd, fymd, tymd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * Zero-Hardcoding: corpGr 추출 헬퍼
     */
    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return "";
    }
}
