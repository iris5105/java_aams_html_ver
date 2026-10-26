package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.common.service.RdReportService;
import com.kfp.aams.domain.subscriptionrights.service.Ja020mService;
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
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 * W_JA020M (금투협보고자료) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja020mController {

    private final Ja020mService ja020mService;
    private final MenuService menuService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja020m", "/views/subscriptionrights/w_ja020m"})
    public String viewJa020m(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ym", required = false) String paramYm,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA020M");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja020m");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 공모청약(권리) > 공모청약(권리)관리 > 금투협보고자료";

        // 파워빌더 w_ja020m.srw wue_lastopen 명세: :idt_workdate의 전월
        String workDate = ja020mService.getWorkDate(corpGr);
        String initialYm = (paramYm != null && !paramYm.isBlank())
                ? paramYm
                : ja020mService.getInitialYm(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYm", initialYm);
        model.addAttribute("ym", initialYm);

        return "views/subscriptionrights/w_ja020m";
    }

    /**
     * 회사그룹 변경 시 초기 보고월 조회 API
     */
    @GetMapping("/api/subscriptionrights/ja020m/initial-ym")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getInitialYm(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        String workDate = ja020mService.getWorkDate(corpGr);
        String initialYm = ja020mService.getInitialYm(corpGr);

        Map<String, Object> result = new HashMap<>();
        result.put("workDate", workDate);
        result.put("initialYm", initialYm);

        return ResponseEntity.ok(result);
    }

    /**
     * 금투협보고자료 리포트 미리보기 API (GET /api/subscriptionrights/ja020m/preview)
     */
    @GetMapping("/api/subscriptionrights/ja020m/preview")
    public ResponseEntity<byte[]> preview(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ym") String ym,
            @RequestParam(name = "format", defaultValue = "pdf") String format,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
            jakarta.servlet.http.HttpServletResponse response) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        try {
            String cleanYm = (ym != null) ? ym.replaceAll("[^0-9]", "") : "";
            String downloadName = "금투협보고자료_" + cleanYm;
            RdReportService.ExportResult result = ja020mService.generateReport(corpGr, ym, format, downloadName);

            if ("html".equalsIgnoreCase(format)) {
                response.setContentType("text/html; charset=UTF-8");
                response.setContentLength(result.getData().length);
                response.getOutputStream().write(result.getData());
                response.getOutputStream().flush();
                return null;
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + encodeFilename(result.getFilename()) + "\"")
                    .body(result.getData());
        } catch (Exception e) {
            log.error("[Ja020mController] 미리보기 오류: corpGr={}, ym={}, err={}", corpGr, ym, e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * 금투협보고자료 리포트 다운로드 내보내기 API (GET /api/subscriptionrights/ja020m/export)
     */
    @GetMapping("/api/subscriptionrights/ja020m/export")
    public ResponseEntity<byte[]> export(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ym") String ym,
            @RequestParam(name = "format", defaultValue = "pdf") String format,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        try {
            String cleanYm = (ym != null) ? ym.replaceAll("[^0-9]", "") : "";
            String downloadName = "금투협보고자료_" + cleanYm;
            RdReportService.ExportResult result = ja020mService.generateReport(corpGr, ym, format, downloadName);

            MediaType mediaType = MediaType.parseMediaType(result.getContentType());
            return ResponseEntity.ok()
                    .contentType(mediaType)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodeFilename(result.getFilename()) + "\"")
                    .body(result.getData());
        } catch (Exception e) {
            log.error("[Ja020mController] 내보내기 오류: corpGr={}, ym={}, format={}, err={}", corpGr, ym, format, e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    private String encodeFilename(String filename) {
        if (filename == null) return "report";
        return URLEncoder.encode(filename, StandardCharsets.UTF_8).replaceAll("\\+", "%20");
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr.trim();
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr.trim();
        }
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return "";
    }
}
