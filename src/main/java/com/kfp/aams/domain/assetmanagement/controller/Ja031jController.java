package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.service.Ja031jService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja031jController {

    private final WorkDateService workDateService;
    private final MenuService menuService;
    private final Ja031jService ja031jService;

    @GetMapping({"/views/w_ja031j", "/views/assetmanagement/w_ja031j"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA031J");

        // PB w_ja031j::wue_lastopen:
        // SELECT TO_CHAR(ADD_MONTHS(f_workdate(:gaa.corp_gr), -1), 'yyyymm') INTO :is_ym FROM DUAL ;
        String initialYm = calculateInitialYm(workDate);

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYm", initialYm);
        model.addAttribute("pgmNo", menu == null ? "" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA031J" : menu.getFullpgm2());

        return "views/assetmanagement/w_ja031j";
    }

    /**
     * GA 테이블 자료 건수 확인
     */
    @GetMapping("/api/assetmanagement/ja031j/check-data")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkData(@AuthenticationPrincipal UserPrincipal principal,
                                                         @RequestParam(required = false) String corpGr,
                                                         @RequestParam String ym,
                                                         @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        int count = ja031jService.checkData(resolvedCorpGr, ym);
        return ResponseEntity.ok(Map.of("count", count, "hasData", count > 0));
    }

    /**
     * 금감원 보고서 데이터 생성 (KFP.SR_JA031J)
     */
    @PostMapping("/api/assetmanagement/ja031j/generate")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateData(@AuthenticationPrincipal UserPrincipal principal,
                                                           @RequestParam(required = false) String corpGr,
                                                           @RequestParam String ym,
                                                           @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        Map<String, Object> result = ja031jService.generateData(resolvedCorpGr, ym);
        return ResponseEntity.ok(result);
    }

    /**
     * 금감원 보고서 엑셀 다운로드 (파워빌더 cb_xls 원본 양식 100% 동일)
     */
    @GetMapping("/api/assetmanagement/ja031j/export-excel")
    @ResponseBody
    public ResponseEntity<byte[]> exportReportExcel(@AuthenticationPrincipal UserPrincipal principal,
                                                   @RequestParam(required = false) String corpGr,
                                                   @RequestParam String ym,
                                                   @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String cleanYm = ym.replaceAll("[^0-9]", "").trim();
        byte[] excelBytes = ja031jService.exportReportExcel(resolvedCorpGr, cleanYm);

        String filename = "금감원보고서_" + cleanYm + ".xlsx";
        String encodedFilename = URLEncoder.encode(filename, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFilename + "\"; filename*=UTF-8''" + encodedFilename)
                .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                .body(excelBytes);
    }

    /**
     * 점검자료 엑셀 다운로드 (GA191)
     */
    @GetMapping("/api/assetmanagement/ja031j/export-ga191")
    @ResponseBody
    public ResponseEntity<byte[]> exportGa191(@AuthenticationPrincipal UserPrincipal principal,
                                             @RequestParam(required = false) String corpGr,
                                             @RequestParam String ym,
                                             @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String cleanYm = ym.replaceAll("[^0-9]", "").trim();
        byte[] excelBytes = ja031jService.exportGa191Excel(resolvedCorpGr, cleanYm);

        String filename = "금감원보고서_" + cleanYm + "(자료점검용).xlsx";
        String encodedFilename = URLEncoder.encode(filename, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFilename + "\"; filename*=UTF-8''" + encodedFilename)
                .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                .body(excelBytes);
    }

    private String calculateInitialYm(String dateStr) {
        if (dateStr == null || dateStr.isBlank()) {
            return LocalDate.now().minusMonths(1).format(DateTimeFormatter.ofPattern("yyyy-MM"));
        }
        try {
            String digits = dateStr.replaceAll("[^0-9]", "").trim();
            LocalDate baseDate;
            if (digits.length() == 8) {
                baseDate = LocalDate.parse(digits, DateTimeFormatter.ofPattern("yyyyMMdd"));
            } else {
                baseDate = LocalDate.parse(dateStr.replace(".", "-").trim(), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }
            return baseDate.minusMonths(1).format(DateTimeFormatter.ofPattern("yyyy-MM"));
        } catch (Exception e) {
            log.warn("[Ja031jController] calculateInitialYm parse error: {}", dateStr);
            return LocalDate.now().minusMonths(1).format(DateTimeFormatter.ofPattern("yyyy-MM"));
        }
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }
}

