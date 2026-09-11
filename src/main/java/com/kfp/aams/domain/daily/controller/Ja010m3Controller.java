package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja010m3Dto;
import com.kfp.aams.domain.daily.dto.Ja010m3SaveDto;
import com.kfp.aams.domain.daily.service.Ja010m3Service;
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
public class Ja010m3Controller {

    private final Ja010m3Service ja010m3Service;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja010m3", "/views/daily/w_ja010m3"})
    public String viewJa010m3(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @RequestParam(name = "dddw", required = false) String paramDddw,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA010M3");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010m3");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 자문일일 > 일일작업";

        // 기본 결산기준일: 36개월 전 날짜
        LocalDate defaultDate = LocalDate.now().minusMonths(36);
        String ymd = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd
                : defaultDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        String dddw = (paramDddw != null && !paramDddw.isBlank()) ? paramDddw : "1";

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", ymd);
        model.addAttribute("dddw", dddw);

        return "views/daily/w_ja010m3";
    }

    @GetMapping("/api/daily/ja010m3/list")
    @ResponseBody
    public ResponseEntity<List<Ja010m3Dto>> getList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "gyulYmd", required = false) String gyulYmd,
            @RequestParam(name = "sortGb", required = false, defaultValue = "1") String sortGb,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        boolean isAdmin = (principal != null && principal.getAuthorities() != null &&
                principal.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN")));

        List<Ja010m3Dto> list = ja010m3Service.getList(corpGr, gyulYmd, sortGb, isAdmin);
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/daily/ja010m3/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(
            @RequestBody Ja010m3SaveDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(null, cookieCorpGr, principal);

        if (saveDto != null && saveDto.getUpdatedList() != null) {
            for (Ja010m3SaveDto.Ja010m3ItemSaveDto item : saveDto.getUpdatedList()) {
                if (item.getCorpGr() == null || item.getCorpGr().isBlank()) {
                    item.setCorpGr(corpGr);
                }
            }
        }

        try {
            ja010m3Service.save(saveDto);
            return ResponseEntity.ok(Map.of("success", true, "message", "저장이 완료되었습니다."));
        } catch (Exception e) {
            log.error("Error saving ja010m3 detail:", e);
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
