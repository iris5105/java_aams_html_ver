package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.security.UserPrincipal;
import com.kfp.aams.domain.daily.dto.Ja010gDto;
import com.kfp.aams.domain.daily.dto.Ja010gFilterDto;
import com.kfp.aams.domain.daily.service.Ja010gService;
import com.kfp.aams.domain.menu.service.MenuService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010gController {

    private final Ja010gService ja010gService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja010g", "/views/daily/w_ja010g"})
    public String ja010gView(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA010G");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010g");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 일일작업";

        // 파워빌더 wue_lastopen 기준일자 명세: SZX0AA.JUNYONG_YMD 또는 작업일자
        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja010gService.getWorkDate(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", workDate);

        return "views/daily/w_ja010g";
    }

    @GetMapping("/api/daily/ja010g/workdate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWorkDate(@RequestParam("corpGr") String corpGr) {
        String workDate = ja010gService.getWorkDate(corpGr);
        Map<String, String> res = new HashMap<>();
        res.put("workDate", workDate);
        return ResponseEntity.ok(res);
    }

    @GetMapping("/api/daily/ja010g/list")
    @ResponseBody
    public ResponseEntity<List<Ja010gDto>> getJa010gList(
            @RequestParam("corpGr") String corpGr,
            @RequestParam("ymd") String ymd) {
        List<Ja010gDto> list = ja010gService.selectJa010gList(corpGr, ymd);
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/daily/ja010g/confirm")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> confirmDifference(@RequestBody Ja010gFilterDto req) {
        Map<String, Object> result = new HashMap<>();
        try {
            int updated = ja010gService.updateConfirmYmd(req.getCorpGr(), req.getYmd());
            result.put("success", true);
            result.put("updatedCount", updated);
            result.put("message", "원장생성을 하시면 LOAD된 예수금으로 예수금을 반영합니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("차액반영 오류: ", e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return null;
    }
}
