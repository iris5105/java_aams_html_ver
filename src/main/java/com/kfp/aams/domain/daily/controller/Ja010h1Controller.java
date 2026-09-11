package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja010hMasterDto;
import com.kfp.aams.domain.daily.service.Ja010hService;
import com.kfp.aams.domain.daily.service.RdReportService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.HttpSession;
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
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010h1Controller {

    private final Ja010hService ja010hService;
    private final RdReportService rdReportService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja010h1", "/views/daily/w_ja010h1"})
    public String ja010h1View(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model,
                             HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA010H1");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010h1");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 자산명세표1";

        // 파워빌더 w_ja010h1.srw (wue_lastopen) 명세: SZX0AA.JUNYONG_YMD(2402) 또는 HYUN_YMD(기타) 작업일자 반영
        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja010hService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = java.time.LocalDate.now().toString();
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);

        return "views/daily/w_ja010h1";
    }

    /**
     * 회사 변경 시 해당 회사의 기준일자 조회 API
     */
    @GetMapping("/api/daily/ja010h1/workdate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String workDate = ja010hService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = java.time.LocalDate.now().toString();
        }
        Map<String, String> response = new HashMap<>();
        response.put("workDate", workDate);
        return ResponseEntity.ok(response);
    }

    /**
     * 2402 회사 원장생성 정합성 체크 API (w_ja010h1.srw ole_rd::ue_retrieve)
     */
    @GetMapping("/api/daily/ja010h1/check-ledger")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkLedger(@RequestParam("corpGr") String corpGr,
                                                           @RequestParam("ymd") String ymd) {
        Map<String, Object> result = new HashMap<>();
        String errorMsg = ja010hService.checkLedgerValidation(corpGr, ymd);
        if (errorMsg != null) {
            result.put("valid", false);
            result.put("message", errorMsg);
        } else {
            result.put("valid", true);
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/api/daily/ja010h1/funds")
    @ResponseBody
    public ResponseEntity<List<Ja010hMasterDto>> getFunds(
            @RequestParam("corpGr") String corpGr,
            @RequestParam("ymd") String ymd) {
        List<Ja010hMasterDto> list = ja010hService.getFundList(corpGr, ymd);
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/daily/ja010h1/pyungjan")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> executePyungjan(@RequestBody Map<String, String> req) {
        Map<String, Object> result = new HashMap<>();
        try {
            String corpGr = req.get("corpGr");
            String fundCd = req.get("fundCd");
            String ymd = req.get("ymd");
            ja010hService.executePyungjan(corpGr, fundCd, ymd);
            result.put("success", true);
            result.put("message", "평잔 재계산 작업을 완료 했습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("평잔 재계산 오류: ", e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }

    @GetMapping("/api/daily/ja010h1/export")
    public ResponseEntity<byte[]> exportReport(
            @RequestParam("corpGr") String corpGr,
            @RequestParam("ymd") String ymd,
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "fundNm", required = false) String fundNm,
            @RequestParam(value = "format", defaultValue = "pdf") String format) {
        try {
            RdReportService.ExportResult exportResult = rdReportService.generateJa010h1Report(
                    corpGr, ymd, fundCd, fundNm, format);

            String encodedFileName = URLEncoder.encode(exportResult.getFilename(), StandardCharsets.UTF_8)
                    .replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(exportResult.getContentType()))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("자산명세표1 (w_ja010h1) 리포트 다운로드 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * 보유자산 종합 엑셀 리포트 다운로드 (w_ja010h1.srw cb_1)
     */
    @GetMapping("/api/daily/ja010h1/export-total-excel")
    public ResponseEntity<byte[]> exportTotalExcel(
            @RequestParam("corpGr") String corpGr,
            @RequestParam("ymd") String ymd) {
        try {
            RdReportService.ExportResult exportResult = ja010hService.exportTotalExcel(corpGr, ymd);

            String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";
            String fileName = "보유자산종합현황(" + ymdClean + ").xlsx";
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8)
                    .replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(exportResult.getContentType()))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("보유자산종합 엑셀 다운로드 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/api/daily/ja010h1/preview")
    public ResponseEntity<byte[]> previewReport(
            @RequestParam("corpGr") String corpGr,
            @RequestParam("ymd") String ymd,
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "fundNm", required = false) String fundNm) {
        try {
            RdReportService.ExportResult exportResult = rdReportService.generateJa010h1Report(
                    corpGr, ymd, fundCd, fundNm, "pdf");

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"report.pdf\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("자산명세표1 (w_ja010h1) 리포트 미리보기 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Helper to resolve corporate group (Guideline 1: no default value)
     */
    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return null;
    }
}
