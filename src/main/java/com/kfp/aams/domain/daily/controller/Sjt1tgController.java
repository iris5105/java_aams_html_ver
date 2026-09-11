package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Sjt1tgDto;
import com.kfp.aams.domain.daily.dto.Sjt1tgFilterDto;
import com.kfp.aams.domain.daily.dto.Sjt1tgSaveDto;
import com.kfp.aams.domain.daily.service.Sjt1tgService;
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
public class Sjt1tgController {

    private final Sjt1tgService sjt1tgService;
    private final MenuService menuService;

    @GetMapping({"/views/w_sjt1tg", "/views/daily/w_sjt1tg"})
    public String viewSjt1tg(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_SJT1TG");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_sjt1tg");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 자문일일 > 일일작업";

        String ymd = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd
                : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", ymd);

        return "views/daily/w_sjt1tg";
    }

    @GetMapping("/api/daily/sjt1tg/list")
    @ResponseBody
    public ResponseEntity<List<Sjt1tgDto>> getSjt1tgList(@ModelAttribute Sjt1tgFilterDto filter) {
        if (filter.getYmd() == null || filter.getYmd().isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }
        List<Sjt1tgDto> list = sjt1tgService.getSjt1tgList(filter.getYmd());
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/daily/sjt1tg/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveSjt1tg(@RequestBody Sjt1tgSaveDto saveDto) {
        try {
            sjt1tgService.saveSjt1tg(saveDto);
            return ResponseEntity.ok(Map.of("success", true, "message", "저장이 완료되었습니다."));
        } catch (Exception e) {
            log.error("Error saving sjt1tg:", e);
            return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "저장 중 오류가 발생했습니다: " + e.getMessage()));
        }
    }

    @GetMapping("/api/daily/sjt1tg/generate")
    @ResponseBody
    public ResponseEntity<List<Sjt1tgDto>> generateNewFutures(
            @RequestParam(name = "corpGr") String corpGr,
            @RequestParam(name = "ymd") String ymd) {
        try {
            List<Sjt1tgDto> list = sjt1tgService.generateNewFutures(corpGr, ymd);
            return ResponseEntity.ok(list);
        } catch (Exception e) {
            log.error("Error generating new futures:", e);
            return ResponseEntity.internalServerError().body(Collections.emptyList());
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
