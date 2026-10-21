package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032mDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032mFundDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032mService;
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
 * 종목별 위험값 (W_JA032M) 컨트롤러
 */
@Controller
public class Ja032mController {

    private static final Logger log = LoggerFactory.getLogger(Ja032mController.class);

    private final Ja032mService ja032mService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    // 명시적 생성자 주입 (Zero-Lombok-ECJ-Conflict 원칙, 규정 01-4)
    public Ja032mController(Ja032mService ja032mService, MenuService menuService, WorkDateService workDateService) {
        this.ja032mService = ja032mService;
        this.menuService = menuService;
        this.workDateService = workDateService;
    }

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032m", "/views/usportfoliomodel/w_ja032m"})
    public String viewJa032m(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA032M");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032m");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 종목별 위험값[ w_ja032m ]";

        // DB 기준 작업일자 연동 필수 (Zero-LocalDate-Now 원칙, 규정 01-3)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : workDateService.getWorkDateOrDefault(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);
        model.addAttribute("workDate", workDate);

        return "views/usportfoliomodel/w_ja032m";
    }

    /**
     * 1. 펀드 목록 조회 API (d_ja032m1.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032m/fund-list")
    @ResponseBody
    public ResponseEntity<List<Ja032mFundDto>> getFundList(@RequestParam("corpGr") String corpGr,
                                                           @RequestParam("ymd") String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }
        List<Ja032mFundDto> list = ja032mService.getFundList(corpGr, ymd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 2. 종목별 위험값 상세 조회 API (d_ja032m2.srd)
     */
    @GetMapping("/api/usportfoliomodel/ja032m/detail-list")
    @ResponseBody
    public ResponseEntity<List<Ja032mDetailDto>> getDetailList(@RequestParam("corpGr") String corpGr,
                                                               @RequestParam("ymd") String ymd,
                                                               @RequestParam("fundCd") String fundCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank() || fundCd == null || fundCd.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }
        List<Ja032mDetailDto> list = ja032mService.getDetailList(corpGr, ymd, fundCd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 회사그룹(corp_gr) 파라미터 추출 (Zero-Hardcoding 원칙)
     */
    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, Object principalObj) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr.trim();
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr.trim();
        }
        if (principalObj instanceof UserPrincipal p) {
            String c = p.getCorpGr();
            if (c != null && !c.isBlank()) {
                return c.trim();
            }
        }
        return "";
    }
}
