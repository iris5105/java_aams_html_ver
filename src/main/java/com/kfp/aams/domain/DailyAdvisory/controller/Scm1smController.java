package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Scm1smDto;
import com.kfp.aams.domain.daily.dto.Scm1smFilterDto;
import com.kfp.aams.domain.daily.dto.Scm1smSaveDto;
import com.kfp.aams.domain.daily.service.Scm1smService;
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
 * Controller for w_scm1sm (채권단가 / 종가LOAD)
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Scm1smController {

    private final Scm1smService scm1smService;
    private final MenuService menuService;

    /**
     * 뷰 템플릿 렌더링
     */
    @GetMapping({"/views/w_scm1sm", "/views/daily/w_scm1sm"})
    public String viewScm1sm(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model,
                             HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_SCM1SM");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_scm1sm");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 자문일일 > 일일작업";

        String ymd = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd
                : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", ymd);

        return "views/daily/w_scm1sm";
    }

    /**
     * 채권 단가 목록 조회 API
     */
    @GetMapping("/api/daily/scm1sm/list")
    @ResponseBody
    public ResponseEntity<List<Scm1smDto>> getScm1smList(
            @ModelAttribute Scm1smFilterDto filter,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(filter.getCorpGr(), cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank() || filter.getYmd() == null || filter.getYmd().isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Scm1smDto> list = scm1smService.getScm1smList(corpGr, filter.getYmd());
        return ResponseEntity.ok(list);
    }

    /**
     * 채권 단가 일괄 저장 API
     */
    @PostMapping("/api/daily/scm1sm/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveScm1sm(
            @RequestBody Scm1smSaveDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(saveDto.getCorpGr(), cookieCorpGr, principal);
        saveDto.setCorpGr(corpGr);

        try {
            scm1smService.saveScm1sm(saveDto);
            return ResponseEntity.ok(Map.of("success", true, "message", "저장이 완료되었습니다."));
        } catch (Exception e) {
            log.error("Error saving scm1sm:", e);
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
