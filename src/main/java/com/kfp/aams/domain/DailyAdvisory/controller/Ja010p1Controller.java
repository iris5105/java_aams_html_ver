package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.common.service.WorkDateService;
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
public class Ja010p1Controller {

    private final RdReportService rdReportService;
    private final WorkDateService workDateService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja010p1", "/views/daily/w_ja010p1"})
    public String ja010p1View(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA010P1");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010p1");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 채권/현금 만기현황";

        // 파워빌더 w_ja010p1.srw (wue_lastopen) 명세: dw_c.object.ymd [1] = idt_workdate (SZX0AA.HYUN_YMD 기준일자)
        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : workDateService.getWorkDateOrDefault(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/daily/w_ja010p1";
    }

    /**
     * 회사 변경 시 해당 회사의 기준일자 조회 API (개발지침 달력 규칙 4)
     */
    @GetMapping("/api/daily/ja010p1/workdate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String workDate = workDateService.getWorkDateOrDefault(corpGr);
        Map<String, String> response = new HashMap<>();
        response.put("workDate", workDate);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/daily/ja010p1/preview")
    public ResponseEntity<byte[]> previewReport(
            @RequestParam(value = "corpGr", required = false) String corpGr,
            @RequestParam("ymd") String ymd) {
        try {
            RdReportService.ExportResult exportResult = rdReportService.generateJa010p1Report(corpGr, ymd, "pdf");

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ja010p1_preview.pdf\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("채권/현금 만기현황 (w_ja010p1) 미리보기 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/api/daily/ja010p1/export")
    public ResponseEntity<byte[]> exportReport(
            @RequestParam(value = "corpGr", required = false) String corpGr,
            @RequestParam("ymd") String ymd,
            @RequestParam(value = "format", defaultValue = "pdf") String format) {
        try {
            RdReportService.ExportResult exportResult = rdReportService.generateJa010p1Report(corpGr, ymd, format);

            String encodedFileName = URLEncoder.encode(exportResult.getFilename(), StandardCharsets.UTF_8)
                    .replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(exportResult.getContentType()))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("채권/현금 만기현황 (w_ja010p1) 내보내기 오류: ", e);
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
