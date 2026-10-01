package com.kfp.aams.domain.dailyadvisory.controller;

//import com.kfp.aams.common.service.DddwService;
import com.kfp.aams.domain.dailyadvisory.dto.Ja030cDto;
import com.kfp.aams.domain.dailyadvisory.service.Ja030cService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
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
 * Controller for w_ja030c (채권 매매등록)
 * Adheres strictly to Guideline 1 (no default value fallback).
 */
@Controller
@RequiredArgsConstructor
public class Ja030cController {

    private final Ja030cService ja030cService;
    private final MenuService menuService;
    // private final DddwService dddwService;

    @GetMapping({ "/views/w_ja030c", "/views/dailyadvisory/w_ja030c" })
    public String viewJa030c(@AuthenticationPrincipal Object principalObj,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd", required = false) String paramYmd,
            @RequestParam(name = "dddw", required = false) String paramDddw,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
            Model model,
            HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA030C");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja030c");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 채권 매매등록";
        model.addAttribute("fullpgm2", fullpgm2);
        List<String> trDates = (corpGr != null && !corpGr.isBlank())
                ? ja030cService.getDates(corpGr)
                : Collections.emptyList();
        String initialYmd = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : (!trDates.isEmpty() ? trDates.get(0) : java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd")));

        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", initialYmd);
        model.addAttribute("dddw", paramDddw != null ? paramDddw : "J15");
        model.addAttribute("trDates", trDates);

        return "views/dailyadvisory/w_ja030c";
    }

    /**
     * API: Available Dates for Calendar Highlighting (w_ja030c.srw / dw_c::ue_getdate / SCT0CG)
     */
    @GetMapping("/api/daily/ja030c/dates")
    @ResponseBody
    public List<String> getDates(@AuthenticationPrincipal Object principalObj,
                                 @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                 @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                 @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja030cService.getDates(corpGr);
    }

    @GetMapping("/api/daily/ja030c/list")
    @ResponseBody
    public List<Ja030cDto> getJa030cList(@AuthenticationPrincipal Object principalObj,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd", required = false) String ymd,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }

        return ja030cService.getJa030cList(corpGr, ymd);
    }

    /**
     * PB ue_insertstart / itemchanged: 다음 순번 조회 (채번)
     */
    @GetMapping("/api/daily/ja030c/next-seq")
    @ResponseBody
    public java.util.Map<String, Object> getNextSeq(@AuthenticationPrincipal Object principalObj,
                                                    @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                    @RequestParam(name = "trCd", required = false) String trCd,
                                                    @RequestParam(name = "ymd", required = false) String ymd,
                                                    @RequestParam(name = "fundCd", required = false) String fundCd,
                                                    @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                                    @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        java.math.BigDecimal nextSeq = ja030cService.getNextSeqNo(corpGr, trCd, ymd, fundCd);
        return java.util.Map.of("nextSeqNo", nextSeq);
    }

    /**
     * PB itemchanged(fund_cd): 관리계좌의 운용회사코드 조회
     */
    @GetMapping("/api/daily/ja030c/tr-co-cd")
    @ResponseBody
    public java.util.Map<String, Object> getTrCoCd(@AuthenticationPrincipal Object principalObj,
                                                   @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                   @RequestParam(name = "fundCd", required = false) String fundCd,
                                                   @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                                   @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        String trCoCd = ja030cService.getTrCoCd(corpGr, fundCd);
        return java.util.Map.of("trCoCd", trCoCd != null ? trCoCd : "");
    }

    @org.springframework.web.bind.annotation.PostMapping("/api/daily/ja030c/save")
    @ResponseBody
    public java.util.Map<String, Object> saveJa030c(@AuthenticationPrincipal Object principalObj,
                                                    @org.springframework.web.bind.annotation.RequestBody com.kfp.aams.domain.dailyadvisory.dto.Ja030cSaveRequestDto requestDto,
                                                    @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                    @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                                    @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (requestDto.getCorpGr() == null || requestDto.getCorpGr().isBlank()) {
            requestDto.setCorpGr(corpGr);
        }

        int count = ja030cService.saveJa030c(requestDto);
        return java.util.Map.of("success", true, "count", count, "message", "저장되었습니다.");
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr;
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr;
        }
        if (principal != null && principal.getCorpGr() != null) {
            return principal.getCorpGr();
        }
        return "";
    }
}
