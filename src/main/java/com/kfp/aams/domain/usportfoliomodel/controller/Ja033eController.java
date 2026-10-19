package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aMasterDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja033eDetailDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja033eService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
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
 * 포트/종목별 종가대비 행사가격 (W_JA033E) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja033eController {

    private final Ja033eService ja033eService;
    private final MenuService menuService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja033e", "/views/usportfoliomodel/w_ja033e"})
    public String viewJa033e(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA033E");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja033e");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 포트/종목별 종가대비 행사가격";

        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja033eService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = LocalDate.now().toString();
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja033e";
    }

    /**
     * 작업일자 조회 API
     */
    @GetMapping("/api/usportfoliomodel/ja033e/workdate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String workDate = ja033eService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = LocalDate.now().toString();
        }
        Map<String, String> response = new HashMap<>();
        response.put("workDate", workDate);
        return ResponseEntity.ok(response);
    }

    /**
     * 1. 마스터 펀드 목록 조회 API (d_ja033e1 / d_ja032a1)
     */
    @GetMapping("/api/usportfoliomodel/ja033e/master")
    @ResponseBody
    public ResponseEntity<List<Ja032aMasterDto>> getMasterList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja032aMasterDto> list = ja033eService.getMasterList(corpGr, ymd);
        return ResponseEntity.ok(list);
    }

    /**
     * 2. 하단 포트/종목별 종가대비 행사가격 상세 목록 조회 API (d_ja033e2)
     */
    @GetMapping("/api/usportfoliomodel/ja033e/detail")
    @ResponseBody
    public ResponseEntity<List<Ja033eDetailDto>> getDetailList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
            @RequestParam(name = "fundCd") String fundCd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja033eDetailDto> list = ja033eService.getDetailList(corpGr, ymd, fundCd);
        return ResponseEntity.ok(list);
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.trim().isEmpty()) {
            return paramCorpGr.trim();
        }
        if (cookieCorpGr != null && !cookieCorpGr.trim().isEmpty()) {
            return cookieCorpGr.trim();
        }
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().trim().isEmpty()) {
            return principal.getCorpGr().trim();
        }
        return "";
    }
}
