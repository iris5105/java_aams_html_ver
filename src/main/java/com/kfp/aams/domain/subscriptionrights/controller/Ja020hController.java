package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.domain.subscriptionrights.dto.Ja020hDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020hSaveDto;
import com.kfp.aams.domain.subscriptionrights.service.Ja020hService;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * W_JA020H (채권 펀드/종목별 시가등록) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja020hController {

    private final Ja020hService ja020hService;
    private final MenuService menuService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja020h", "/views/subscriptionrights/w_ja020h"})
    public String viewJa020h(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA020H");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja020h");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 공모청약(권리) > 공모청약(권리)관리 > 채권 펀드/종목별 시가등록";

        // DB 영업일자(SZX0AA.HYUN_YMD) 연동 (Zero-LocalDate-Now 원칙)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : ja020hService.getWorkDate(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/subscriptionrights/w_ja020h";
    }

    /**
     * 채권 펀드/종목별 시가 목록 조회 API (d_ja020h)
     */
    @GetMapping("/api/subscriptionrights/ja020h/list")
    @ResponseBody
    public ResponseEntity<List<Ja020hDto>> getList(
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

        List<Ja020hDto> list = ja020hService.getList(corpGr, ymd);
        return ResponseEntity.ok(list);
    }

    /**
     * 채권 시가평가액 저장 API
     */
    @PostMapping("/api/subscriptionrights/ja020h/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(
            @RequestBody Ja020hSaveDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(saveDto.getCorpGr(), cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "회사그룹 정보가 누락되었습니다.");
            return ResponseEntity.badRequest().body(err);
        }

        saveDto.setCorpGr(corpGr);
        String loginUser = (principal != null) ? principal.getUsername() : "admin";

        try {
            int updatedCount = ja020hService.save(saveDto, loginUser);
            Map<String, Object> res = new HashMap<>();
            res.put("success", true);
            res.put("message", "정상적으로 저장되었습니다.");
            res.put("updatedCount", updatedCount);
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            log.error("Failed to save ja020h siga amounts:", e);
            Map<String, Object> res = new HashMap<>();
            res.put("success", false);
            res.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
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
        return null;
    }
}
