package com.kfp.aams.domain.DailyAdvisory.controller;

import com.kfp.aams.domain.DailyAdvisory.dto.Ja991aDetailDto;
import com.kfp.aams.domain.DailyAdvisory.dto.Ja991aMasterDto;
import com.kfp.aams.domain.DailyAdvisory.service.Ja991aService;
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
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja991aController {

    private final Ja991aService ja991aService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja991a", "/views/DailyAdvisory/w_ja991a"})
    public String viewJa991a(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             @CookieValue(name = "workDate", required = false) String cookieWorkDate,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA991A");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja991a");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 기준정보관리 > 주식 종가조회";

        String effectiveWorkDate = (cookieWorkDate != null && !cookieWorkDate.isBlank())
                ? cookieWorkDate
                : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", effectiveWorkDate);

        return "views/DailyAdvisory/w_ja991a";
    }

    @GetMapping("/api/daily/ja991a/master")
    @ResponseBody
    public ResponseEntity<List<Ja991aMasterDto>> getMasterList(
            @RequestParam(name = "corpGr", required = false) String corpGr,
            @RequestParam(name = "ymd", required = false) String ymd,
            @CookieValue(name = "workDate", required = false) String cookieWorkDate,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String effectiveCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : cookieCorpGr;
        String effectiveYmd = (ymd != null && !ymd.isBlank()) ? ymd : cookieWorkDate;

        List<Ja991aMasterDto> list = ja991aService.getMasterList(effectiveCorpGr, effectiveYmd);
        return ResponseEntity.ok(list);
    }

    @GetMapping("/api/daily/ja991a/detail")
    @ResponseBody
    public ResponseEntity<List<Ja991aDetailDto>> getDetailList(
            @RequestParam(name = "koscomCd") String koscomCd,
            @RequestParam(name = "ymd", required = false) String ymd,
            @CookieValue(name = "workDate", required = false) String cookieWorkDate) {

        if (koscomCd == null || koscomCd.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        String effectiveYmd = (ymd != null && !ymd.isBlank()) ? ymd : cookieWorkDate;

        List<Ja991aDetailDto> list = ja991aService.getDetailList(koscomCd, effectiveYmd);
        return ResponseEntity.ok(list);
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr;
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr;
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr();
        }
        return "";
    }
}
