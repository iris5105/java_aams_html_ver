package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja031gDetailDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031gMasterDto;
import com.kfp.aams.domain.assetmanagement.service.Ja031gService;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja031gController {

    private final WorkDateService workDateService;
    private final MenuService menuService;
    private final Ja031gService ja031gService;

    @GetMapping({"/views/w_ja031g", "/views/assetmanagement/w_ja031g"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA031G");

        // PB w_ja031g::wue_lastopen: fymd는 해당 월의 1일, tymd는 기준일자
        String fymd = calculateMonthFirstDay(workDate);
        String tymd = workDate;

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fymd", fymd);
        model.addAttribute("tymd", tymd);
        model.addAttribute("pgmNo", menu == null ? "" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA031G" : menu.getFullpgm2());

        return "views/assetmanagement/w_ja031g";
    }

    /**
     * 현금/단기금융 매매현황 펀드 마스터 목록 API (좌측 그리드)
     */
    @GetMapping("/api/assetmanagement/ja031g/funds")
    @ResponseBody
    public ResponseEntity<List<Ja031gMasterDto>> getFunds(
            @AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(required = false) String corpGr,
            @RequestParam String fYmd,
            @RequestParam String tYmd,
            @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        List<Ja031gMasterDto> list = ja031gService.getMasterList(resolvedCorpGr, fYmd, tYmd);
        return ResponseEntity.ok(list);
    }

    /**
     * 현금/단기금융 매매내역 상세 목록 API (우측 그리드)
     */
    @GetMapping("/api/assetmanagement/ja031g/details")
    @ResponseBody
    public ResponseEntity<List<Ja031gDetailDto>> getDetails(
            @AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(required = false) String corpGr,
            @RequestParam String fYmd,
            @RequestParam String tYmd,
            @RequestParam(defaultValue = "%") String fundCd,
            @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        List<Ja031gDetailDto> list = ja031gService.getDetailList(resolvedCorpGr, fYmd, tYmd, fundCd);
        return ResponseEntity.ok(list);
    }

    private String calculateMonthFirstDay(String dateStr) {
        if (dateStr == null || dateStr.isBlank()) return "";
        try {
            String clean = dateStr.replaceAll("[^0-9]", "");
            if (clean.length() == 8) {
                LocalDate date = LocalDate.parse(clean, DateTimeFormatter.ofPattern("yyyyMMdd"));
                return date.withDayOfMonth(1).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }
        } catch (Exception e) {
            log.warn("Failed to parse first day of month from {}: {}", dateStr, e.getMessage());
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

