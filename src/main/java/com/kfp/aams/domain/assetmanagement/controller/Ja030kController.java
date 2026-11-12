package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.dto.ApiResponse;
import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja030kDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030kSaveRequest;
import com.kfp.aams.domain.assetmanagement.service.Ja030kService;
import com.kfp.aams.menu.service.MenuService;
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
import java.util.List;

/**
 * 원리금 상환 명세표 (W_JA030K) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja030kController {

    private final WorkDateService workDateService;
    private final MenuService menuService;
    private final Ja030kService ja030kService;

    @GetMapping({"/views/w_ja030k", "/views/assetmanagement/w_ja030k"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA030K");

        // PB wue_lastopen: fymd는 해당 월의 1일, tymd는 기준일자
        String fymd = calculateMonthFirstDay(workDate);
        String tymd = workDate;

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fymd", fymd);
        model.addAttribute("tymd", tymd);
        model.addAttribute("pgmNo", menu == null ? "00078" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA030K" : menu.getFullpgm2());

        return "views/assetmanagement/w_ja030k";
    }

    @GetMapping("/api/assetmanagement/ja030k/list")
    @ResponseBody
    public ResponseEntity<List<Ja030kDto>> getList(@RequestParam String corpGr,
                                                   @RequestParam String fymd,
                                                   @RequestParam String tymd) {
        List<Ja030kDto> list = ja030kService.getList(corpGr, fymd, tymd);
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/assetmanagement/ja030k/save")
    @ResponseBody
    public ResponseEntity<ApiResponse<Integer>> save(@AuthenticationPrincipal UserPrincipal principal,
                                                     @RequestBody Ja030kSaveRequest request) {
        String userNm = principal != null ? principal.getUsername() : "SYSTEM";
        int savedCount = ja030kService.saveList(request, userNm);
        return ResponseEntity.ok(ApiResponse.ok(savedCount));
    }

    private String calculateMonthFirstDay(String dateStr) {
        if (dateStr == null || dateStr.isBlank()) {
            return LocalDate.now().withDayOfMonth(1).toString();
        }
        String clean = dateStr.trim().replaceAll("[^0-9]", "");
        if (clean.length() == 8) {
            try {
                LocalDate date = LocalDate.parse(clean, DateTimeFormatter.ofPattern("yyyyMMdd"));
                return date.withDayOfMonth(1).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            } catch (Exception e) {
                log.warn("[Ja030kController] calculateMonthFirstDay error: {}", dateStr, e);
            }
        }
        return dateStr;
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }
}

