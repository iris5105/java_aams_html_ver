package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja990dDto;
import com.kfp.aams.domain.daily.dto.Ja990dSaveDto;
import com.kfp.aams.domain.daily.service.Ja990dService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja990dController {

    private final Ja990dService ja990dService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja990d", "/views/daily/w_ja990d"})
    public String viewJa990d(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA990D");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja990d");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 기준정보관리 > 종목코드관리";

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);

        return "views/daily/w_ja990d";
    }

    @GetMapping("/api/daily/ja990d/stocks")
    @ResponseBody
    public ResponseEntity<List<Ja990dDto>> getStockList(
            @RequestParam(name = "searchKeyword", required = false) String searchKeyword) {
        List<Ja990dDto> list = ja990dService.getStockList(searchKeyword);
        return ResponseEntity.ok(list);
    }

    @GetMapping("/api/daily/ja990d/rights")
    @ResponseBody
    public ResponseEntity<List<Ja990dDto>> getRightList(
            @RequestParam(name = "searchKeyword", required = false) String searchKeyword) {
        List<Ja990dDto> list = ja990dService.getRightList(searchKeyword);
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/daily/ja990d/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(
            @RequestBody Ja990dSaveDto saveDto) {
        try {
            ja990dService.save(saveDto);
            return ResponseEntity.ok(Map.of("success", true, "message", "저장이 완료되었습니다."));
        } catch (Exception e) {
            log.error("Error saving ja990d:", e);
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
