package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.domain.assetmanagement.dto.Ja031bDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031bSaveRequest;
import com.kfp.aams.domain.assetmanagement.service.Ja031bService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja031bController {

    private final Ja031bService service;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja031b", "/views/assetmanagement/w_ja031b", "/views/usportfoliomodel/w_ja031b"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA031B");
        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("pgmNo", menu == null ? "" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA031B" : menu.getFullpgm2());
        return "views/assetmanagement/w_ja031b";
    }

    @GetMapping("/api/assetmanagement/ja031b/list")
    @ResponseBody
    public List<Ja031bDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                 @RequestParam(required = false) String corpGr,
                                 @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        return service.list(resolveCorpGr(principal, corpGr, savedCorpGr));
    }

    @PostMapping("/api/assetmanagement/ja031b/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@AuthenticationPrincipal UserPrincipal principal,
                                                     @RequestBody Ja031bSaveRequest request) {
        try {
            request.setCorpGr(resolveCorpGr(principal, request.getCorpGr(), null));
            return ResponseEntity.ok(service.save(request));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", ex.getMessage()));
        } catch (Exception ex) {
            log.error("W_JA031B 저장 오류", ex);
            return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "저장 중 오류가 발생했습니다."));
        }
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }
}

