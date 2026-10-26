package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.domain.dailyadvisory.dto.Uzm0hyDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020qReportParamDto;
import com.kfp.aams.domain.subscriptionrights.service.Ja020qService;
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
import java.util.Collections;
import java.util.List;

/**
 * W_JA020Q (수요예측 참여자료) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja020qController {

    private final Ja020qService ja020qService;
    private final MenuService menuService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja020q", "/views/subscriptionrights/w_ja020q"})
    public String viewJa020q(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA020Q");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja020q");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 공모청약(권리) > 공모청약(권리)관리 > 수요예측 참여자료";

        // 파워빌더 w_ja020q.srw wue_lastopen 규격: idt_workdate - 1 (전영업일자)
        String workDate = ja020qService.getWorkDate(corpGr);
        String junyongDate = ja020qService.getJunyongDate(corpGr);
        String initialYmd = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : ((junyongDate != null && !junyongDate.isBlank()) ? junyongDate : workDate);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", initialYmd);
        model.addAttribute("ymd", initialYmd);

        return "views/subscriptionrights/w_ja020q";
    }

    /**
     * 계좌(펀드) 목록 조회 API (d_uzm0hy)
     */
    @GetMapping("/api/subscriptionrights/ja020q/list")
    @ResponseBody
    public ResponseEntity<List<Uzm0hyDto>> getFundList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }

        List<Uzm0hyDto> list = ja020qService.getFundList(corpGr, ymd);
        return ResponseEntity.ok(list);
    }

    /**
     * 탭별 MRD 리포트 파라미터 조회 API
     */
    @GetMapping("/api/subscriptionrights/ja020q/report-params")
    @ResponseBody
    public ResponseEntity<Ja020qReportParamDto> getReportParams(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "fundCd") String fundCd,
            @RequestParam(name = "fundNm", required = false) String fundNm,
            @RequestParam(name = "gugan", required = false) String gugan,
            @RequestParam(name = "ymd") @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
            @RequestParam(name = "tabId", defaultValue = "tab1") String tabId,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.badRequest().build();
        }

        Ja020qReportParamDto params = ja020qService.getReportParams(corpGr, fundCd, fundNm, gugan, ymd, tabId);
        if (params == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(params);
    }

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
