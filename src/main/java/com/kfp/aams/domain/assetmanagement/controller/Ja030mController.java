package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja030mDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030mCopyDateDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030mSaveRequest;
import com.kfp.aams.domain.assetmanagement.service.Ja030mService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class Ja030mController {
    private final WorkDateService workDateService;
    private final MenuService menuService;
    private final Ja030mService service;

    @GetMapping({"/views/w_ja030m", "/views/assetmanagement/w_ja030m"})
    public String view(@AuthenticationPrincipal UserPrincipal principal, @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr, Model model) {
        String resolved = resolveCorpGr(principal, corpGr, savedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA030M");
        model.addAttribute("corpGr", resolved);
        model.addAttribute("workDate", workDateService.getWorkDateOrDefault(resolved));
        model.addAttribute("adminYn", principal != null && "Y".equalsIgnoreCase(principal.getAdminYn()) ? "Y" : "N");
        model.addAttribute("pgmNo", menu == null ? "W_JA030M" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA030M" : menu.getFullpgm2());
        return "views/assetmanagement/w_ja030m";
    }

    @GetMapping("/api/assetmanagement/ja030m/list")
    @ResponseBody
    public List<Ja030mDto> list(@AuthenticationPrincipal UserPrincipal principal, @RequestParam String corpGr,
                                 @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        boolean allCorp = principal != null && "Y".equalsIgnoreCase(principal.getAdminYn()) && "%".equals(corpGr);
        String workCorpGr = resolveCorpGr(principal, null, savedCorpGr);
        String resolvedCorpGr = allCorp ? "%" : resolveCorpGr(principal, corpGr, savedCorpGr);
        return service.list(resolvedCorpGr, getWorkDate(allCorp ? workCorpGr : resolvedCorpGr), allCorp);
    }

    @PostMapping("/api/assetmanagement/ja030m/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@AuthenticationPrincipal UserPrincipal principal,
                                                      @RequestBody Ja030mSaveRequest request) {
        fillCorpGr(principal, request);
        return ResponseEntity.ok(service.save(request));
    }

    @GetMapping("/api/assetmanagement/ja030m/sanghw-ymd")
    @ResponseBody
    public Map<String, LocalDate> sanghwYmd(@RequestParam LocalDate balhYmd) {
        return Map.of("sanghwYmd", service.getSanghwYmdForBalhYmd(balhYmd));
    }

    @GetMapping("/api/assetmanagement/ja030m/copy-dates")
    @ResponseBody
    public Ja030mCopyDateDto copyDates(@RequestParam LocalDate balhYmd, @RequestParam LocalDate sanghwYmd) {
        return service.getCopyDates(balhYmd, sanghwYmd);
    }

    private void fillCorpGr(UserPrincipal principal, Ja030mSaveRequest request) {
        if (request == null) throw new IllegalArgumentException("저장 요청이 없습니다.");
        boolean admin = principal != null && "Y".equalsIgnoreCase(principal.getAdminYn());
        String principalCorpGr = resolveCorpGr(principal, null, null);
        if (request.getRows() != null) request.getRows().forEach(row -> {
            if (row != null && (!admin || row.getCorpGr() == null || row.getCorpGr().isBlank())) row.setCorpGr(principalCorpGr);
        });
        if (request.getDeletedRows() != null) request.getDeletedRows().forEach(row -> {
            if (row != null && (!admin || row.getCorpGr() == null || row.getCorpGr().isBlank())) row.setCorpGr(principalCorpGr);
        });
    }
    private String resolveCorpGr(UserPrincipal principal, String requested, String saved) {
        boolean admin = principal != null && "Y".equalsIgnoreCase(principal.getAdminYn());
        if (admin && isTargetCorpGr(requested)) return requested.trim();
        if (admin && isTargetCorpGr(saved)) return saved.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }

    private boolean isTargetCorpGr(String corpGr) {
        return corpGr != null && !corpGr.isBlank() && !"%".equals(corpGr.trim());
    }

    private LocalDate getWorkDate(String corpGr) {
        String value = workDateService.getWorkDateOrDefault(corpGr);
        return LocalDate.parse(value.replaceAll("[^0-9]", ""), DateTimeFormatter.BASIC_ISO_DATE);
    }
}
