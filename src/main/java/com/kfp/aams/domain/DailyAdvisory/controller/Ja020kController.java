package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.service.Ja020kService;
import com.kfp.aams.domain.daily.service.RdReportService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja020kController {

    private final Ja020kService ja020kService;
    private final RdReportService rdReportService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja020k", "/views/daily/w_ja020k"})
    public String ja020kView(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA020K");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja020k");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 일(종목)별 운용현황";

        // 파워빌더 w_ja020k.srw (wue_lastopen) 명세: SZX0AA.JUNYONG_YMD(2402) 또는 HYUN_YMD(기타) 작업일자 반영
        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja020kService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = java.time.LocalDate.now().toString();
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/daily/w_ja020k";
    }

    /**
     * 회사 변경 시 해당 회사의 기준일자 조회 API
     */
    @GetMapping("/api/daily/ja020k/workdate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String workDate = ja020kService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = java.time.LocalDate.now().toString();
        }
        Map<String, String> response = new HashMap<>();
        response.put("workDate", workDate);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/daily/ja020k/preview")
    public ResponseEntity<byte[]> previewReport(
            @RequestParam(value = "corpGr", required = false) String corpGr,
            @RequestParam(value = "seriesGb", defaultValue = "1110") String seriesGb,
            @RequestParam("ymd") String ymd) {
        try {
            RdReportService.ExportResult exportResult = rdReportService.generateJa020kReport(
                    corpGr, seriesGb, ymd, "pdf");

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ja020k_report.pdf\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("일(종목)별 운용현황 (w_ja020k) 리포트 미리보기 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/api/daily/ja020k/export")
    public ResponseEntity<byte[]> exportReport(
            @RequestParam(value = "corpGr", required = false) String corpGr,
            @RequestParam(value = "seriesGb", defaultValue = "1110") String seriesGb,
            @RequestParam("ymd") String ymd,
            @RequestParam(value = "format", defaultValue = "pdf") String format) {
        try {
            RdReportService.ExportResult exportResult = rdReportService.generateJa020kReport(
                    corpGr, seriesGb, ymd, format);

            String encodedFileName = URLEncoder.encode(exportResult.getFilename(), StandardCharsets.UTF_8)
                    .replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(exportResult.getContentType()))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("일(종목)별 운용현황 (w_ja020k) 리포트 내보내기 오류: ", e);
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
