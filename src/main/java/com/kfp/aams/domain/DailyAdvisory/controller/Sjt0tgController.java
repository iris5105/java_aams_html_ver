package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Sjt0tgDto;
import com.kfp.aams.domain.daily.dto.Sjt0tgFilterDto;
import com.kfp.aams.domain.daily.dto.Sjt0tgSaveDto;
import com.kfp.aams.domain.daily.service.Sjt0tgService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.HttpSession;
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

/**
 * Controller for w_sjt0tg (주식 종가 관리 / 종가LOAD)
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Sjt0tgController {

    private final Sjt0tgService sjt0tgService;
    private final MenuService menuService;

    /**
     * 뷰 템플릿 렌더링
     */
    @GetMapping({"/views/w_sjt0tg", "/views/daily/w_sjt0tg"})
    public String viewSjt0tg(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model,
                             HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_SJT0TG");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_sjt0tg");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 자문일일 > 일일작업";

        String ymd = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd
                : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", ymd);

        return "views/daily/w_sjt0tg";
    }

    /**
     * 주식 종가 목록 조회 API
     */
    @GetMapping("/api/daily/sjt0tg/list")
    @ResponseBody
    public ResponseEntity<List<Sjt0tgDto>> getSjt0tgList(
            @ModelAttribute Sjt0tgFilterDto filter,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(filter.getCorpGr(), cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank() || filter.getYmd() == null || filter.getYmd().isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Sjt0tgDto> list = sjt0tgService.getSjt0tgList(corpGr, filter.getYmd());
        return ResponseEntity.ok(list);
    }

    /**
     * 주식 종가 일괄 저장 API
     */
    @PostMapping("/api/daily/sjt0tg/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveSjt0tg(
            @RequestBody Sjt0tgSaveDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(saveDto.getCorpGr(), cookieCorpGr, principal);
        saveDto.setCorpGr(corpGr);

        try {
            sjt0tgService.saveSjt0tg(saveDto);
            return ResponseEntity.ok(Map.of("success", true, "message", "저장이 완료되었습니다."));
        } catch (Exception e) {
            log.error("Error saving sjt0tg:", e);
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
