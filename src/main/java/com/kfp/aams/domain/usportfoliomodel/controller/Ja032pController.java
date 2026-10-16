package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032pDayDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032pDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032pFundDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032pService;
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
import java.util.List;

/**
 * 기준정보 옵션종목 일별현황 (W_JA032P) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja032pController {

    private final Ja032pService ja032pService;
    private final MenuService menuService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032p", "/views/usportfoliomodel/w_ja032p"})
    public String viewJa032p(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA032P");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032p");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 기준정보 옵션종목 일별현황";

        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja032pService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = LocalDate.now().toString();
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("workDate", workDate);
        model.addAttribute("ymd", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("corpGr", corpGr);

        return "views/usportfoliomodel/w_ja032p";
    }

    /**
     * 1. 펀드 목록 조회 API (d_ja032m1.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032p/fund-list")
    @ResponseBody
    public ResponseEntity<List<Ja032pFundDto>> getFundList(@RequestParam("corpGr") String corpGr,
                                                           @RequestParam("ymd") String ymd) {
        List<Ja032pFundDto> list = ja032pService.getFundList(corpGr, ymd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 2. 옵션종목 보유현황 조회 API (d_ja032p2.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032p/detail-list")
    @ResponseBody
    public ResponseEntity<List<Ja032pDetailDto>> getDetailList(@RequestParam("corpGr") String corpGr,
                                                               @RequestParam("ymd") String ymd,
                                                               @RequestParam("fundCd") String fundCd) {
        List<Ja032pDetailDto> list = ja032pService.getDetailList(corpGr, ymd, fundCd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 3. 옵션종목 일별추이 조회 API (d_ja032p3.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032p/day-list")
    @ResponseBody
    public ResponseEntity<List<Ja032pDayDto>> getDayList(@RequestParam("corpGr") String corpGr,
                                                         @RequestParam("ymd") String ymd,
                                                         @RequestParam("fundCd") String fundCd,
                                                         @RequestParam("jmCd") String jmCd,
                                                         @RequestParam("trustee") String trustee) {
        List<Ja032pDayDto> list = ja032pService.getDayList(corpGr, ymd, fundCd, jmCd, trustee);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 회사그룹(corp_gr) 파라미터 추출 (Zero-Hardcoding 원칙)
     */
    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr.trim();
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr.trim();
        }
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return "";
    }
}
