package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja990cDetailDto;
import com.kfp.aams.domain.daily.dto.Ja990cMasterDto;
import com.kfp.aams.domain.daily.dto.Ja990cSaveDto;
import com.kfp.aams.domain.daily.service.Ja990cService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja990cController {

    private final Ja990cService ja990cService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja990c", "/views/daily/w_ja990c"})
    public String viewJa990c(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA990C");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja990c");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 기준정보관리 > 종목코드관리";

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);

        return "views/daily/w_ja990c";
    }

    @GetMapping("/api/daily/ja990c/master")
    @ResponseBody
    public ResponseEntity<List<Ja990cMasterDto>> getMasterList(
            @AuthenticationPrincipal Object principalObj) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        boolean isAdmin = (principal != null && principal.getAuthorities() != null &&
                principal.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN")));

        List<Ja990cMasterDto> list = ja990cService.getMasterList(isAdmin);
        return ResponseEntity.ok(list);
    }

    @GetMapping("/api/daily/ja990c/detail")
    @ResponseBody
    public ResponseEntity<List<Ja990cDetailDto>> getDetailList(
            @RequestParam(name = "balhCo") String balhCo) {

        if (balhCo == null || balhCo.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja990cDetailDto> list = ja990cService.getDetailList(balhCo);
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/daily/ja990c/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(
            @RequestBody Ja990cSaveDto saveDto,
            @AuthenticationPrincipal Object principalObj) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String username = (principal != null && principal.getUsername() != null)
                ? principal.getUsername() : "USER";

        try {
            ja990cService.save(saveDto, username);
            return ResponseEntity.ok(Map.of("success", true, "message", "저장이 완료되었습니다."));
        } catch (Exception e) {
            log.error("Error saving ja990c:", e);
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
