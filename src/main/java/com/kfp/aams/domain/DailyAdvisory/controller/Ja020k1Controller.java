package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Uzm0hyDto;
import com.kfp.aams.domain.daily.service.Ja020k1Service;
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
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja020k1Controller {

    private final Ja020k1Service ja020k1Service;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja020k1", "/views/daily/w_ja020k1"})
    public String ja020k1View(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA020K1");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja020k1");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 계좌(종목)별 주간 운용현황";

        // 기준일자 조회 (w_ja020k1.srw wue_lastopen 명세: 작업일자 idt_workdate)
        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja020k1Service.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = java.time.LocalDate.now().toString();
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/daily/w_ja020k1";
    }

    /**
     * 회사 변경 시 해당 회사의 기준일자 조회 API
     */
    @GetMapping("/api/daily/ja020k1/workdate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String workDate = ja020k1Service.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = java.time.LocalDate.now().toString();
        }
        Map<String, String> response = new HashMap<>();
        response.put("workDate", workDate);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/daily/ja020k1/funds")
    @ResponseBody
    public ResponseEntity<List<Uzm0hyDto>> getFunds(
            @AuthenticationPrincipal Object principalObj,
            @RequestParam(value = "corpGr", required = false) String corpGr,
            @RequestParam("ymd") String ymd,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        corpGr = resolveCorpGr(corpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Uzm0hyDto> list = ja020k1Service.selectUzm0hyList(corpGr, ymd);
        return ResponseEntity.ok(list);
    }

    @GetMapping("/api/daily/ja020k1/preview")
    public ResponseEntity<byte[]> previewReport(
            @AuthenticationPrincipal Object principalObj,
            @RequestParam(value = "corpGr", required = false) String corpGr,
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "fundNm", required = false) String fundNm,
            @RequestParam("ymd") String ymd,
            @RequestParam(value = "gugan", defaultValue = "1") String gugan,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        try {
            UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
            String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
            corpGr = resolveCorpGr(corpGr, cookieCorpGr, principal);

            RdReportService.ExportResult exportResult = ja020k1Service.generateReport(
                    corpGr, fundCd, fundNm, ymd, gugan, "pdf");

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ja020k1_preview.pdf\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("계좌(종목)별 주간 운용현황 미리보기 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/api/daily/ja020k1/export")
    public ResponseEntity<byte[]> exportReport(
            @AuthenticationPrincipal Object principalObj,
            @RequestParam(value = "corpGr", required = false) String corpGr,
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "fundNm", required = false) String fundNm,
            @RequestParam("ymd") String ymd,
            @RequestParam(value = "gugan", defaultValue = "1") String gugan,
            @RequestParam(value = "format", defaultValue = "pdf") String format,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        try {
            UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
            String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
            corpGr = resolveCorpGr(corpGr, cookieCorpGr, principal);

            RdReportService.ExportResult exportResult = ja020k1Service.generateReport(
                    corpGr, fundCd, fundNm, ymd, gugan, format);

            String encodedFileName = URLEncoder.encode(exportResult.getFilename(), StandardCharsets.UTF_8)
                    .replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(exportResult.getContentType()))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("계좌(종목)별 주간 운용현황 내보내기 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * 회사그룹 식별 헬퍼 (기본값 하드코딩 배제, 개발지침 1번 준수)
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
