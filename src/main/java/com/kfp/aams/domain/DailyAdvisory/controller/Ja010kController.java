package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja010kDetailDto;
import com.kfp.aams.domain.daily.dto.Ja010kMasterDto;
import com.kfp.aams.domain.daily.dto.Ja010kSaveDto;
import com.kfp.aams.domain.daily.service.Ja010kService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010kController {

    private final Ja010kService ja010kService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja010k", "/views/daily/w_ja010k"})
    public String viewJa010k(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "fymd", required = false) String paramFymd,
                             @RequestParam(name = "tymd", required = false) String paramTymd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA010K");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010k");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 자문일일 > 일일작업";

        LocalDate today = LocalDate.now();
        String tymd = (paramTymd != null && !paramTymd.isBlank()) ? paramTymd
                : today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        String fymd = (paramFymd != null && !paramFymd.isBlank()) ? paramFymd
                : today.minusMonths(3).plusDays(1).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("fymd", fymd);
        model.addAttribute("tymd", tymd);

        return "views/daily/w_ja010k";
    }

    @GetMapping("/api/daily/ja010k/master")
    @ResponseBody
    public ResponseEntity<List<Ja010kMasterDto>> getMasterList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "tymd", required = false) String tymd,
            @RequestParam(name = "tYmd", required = false) String paramTYmd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        String finalTymd = (tymd != null && !tymd.isBlank()) ? tymd : paramTYmd;
        if (finalTymd == null || finalTymd.isBlank()) {
            finalTymd = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja010kMasterDto> list = ja010kService.getMasterList(corpGr, finalTymd);
        return ResponseEntity.ok(list);
    }

    @GetMapping("/api/daily/ja010k/detail")
    @ResponseBody
    public ResponseEntity<List<Ja010kDetailDto>> getDetailList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "fymd", required = false) String fymd,
            @RequestParam(name = "fYmd", required = false) String paramFYmd,
            @RequestParam(name = "tymd", required = false) String tymd,
            @RequestParam(name = "tYmd", required = false) String paramTYmd,
            @RequestParam(name = "fundCd", required = false) String fundCd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        String finalFymd = (fymd != null && !fymd.isBlank()) ? fymd : paramFYmd;
        String finalTymd = (tymd != null && !tymd.isBlank()) ? tymd : paramTYmd;

        if (finalTymd == null || finalTymd.isBlank()) {
            finalTymd = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }
        if (finalFymd == null || finalFymd.isBlank()) {
            finalFymd = LocalDate.now().minusMonths(3).plusDays(1).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }

        List<Ja010kDetailDto> list = ja010kService.getDetailList(corpGr, finalFymd, finalTymd, fundCd);
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/daily/ja010k/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(
            @RequestBody Ja010kSaveDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(null, cookieCorpGr, principal);

        if (saveDto != null && saveDto.getUpdatedList() != null) {
            for (Ja010kSaveDto.Ja010kItemSaveDto item : saveDto.getUpdatedList()) {
                if (item.getCorpGr() == null || item.getCorpGr().isBlank()) {
                    item.setCorpGr(corpGr);
                }
            }
        }

        try {
            ja010kService.save(saveDto);
            return ResponseEntity.ok(Map.of("success", true, "message", "저장이 완료되었습니다."));
        } catch (Exception e) {
            log.error("Error saving ja010k detail:", e);
            return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "저장 중 오류가 발생했습니다: " + e.getMessage()));
        }
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
