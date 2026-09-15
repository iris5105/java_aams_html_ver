package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Shm1pgDto;
import com.kfp.aams.domain.daily.dto.Shm1pgFilterDto;
import com.kfp.aams.domain.daily.dto.Shm1pgSaveDto;
import com.kfp.aams.domain.daily.service.Shm1pgService;
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
public class Shm1pgController {

    private final Shm1pgService shm1pgService;
    private final MenuService menuService;

    @GetMapping({"/views/w_shm1pg", "/views/daily/w_shm1pg"})
    public String viewShm1pg(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_SHM1PG");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_shm1pg");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 자문일일 > 일일작업";

        String ymd = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd
                : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", ymd);

        return "views/daily/w_shm1pg";
    }

    @GetMapping("/api/daily/shm1pg/list")
    @ResponseBody
    public ResponseEntity<List<Shm1pgDto>> getShm1pgList(
            @ModelAttribute Shm1pgFilterDto filter,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(filter.getCorpGr(), cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank() || filter.getYmd() == null || filter.getYmd().isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Shm1pgDto> list = shm1pgService.getShm1pgList(corpGr, filter.getYmd());
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/daily/shm1pg/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveShm1pg(
            @RequestBody Shm1pgSaveDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(saveDto.getCorpGr(), cookieCorpGr, principal);
        saveDto.setCorpGr(corpGr);

        try {
            shm1pgService.saveShm1pg(saveDto);
            return ResponseEntity.ok(Map.of("success", true, "message", "저장이 완료되었습니다."));
        } catch (Exception e) {
            log.error("Error saving shm1pg:", e);
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
