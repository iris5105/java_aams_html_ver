package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.common.service.RdReportService;
import com.kfp.aams.domain.subscriptionrights.service.Ja020pService;
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
 * W_JA020P (채권비율보고) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja020pController {

    private final Ja020pService ja020pService;
    private final MenuService menuService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja020p", "/views/subscriptionrights/w_ja020p"})
    public String viewJa020p(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA020P");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja020p");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 공모청약(권리) > 공모청약(권리)관리 > 채권비율보고";

        // 파워빌더 w_ja020p.srw wue_lastopen 명세: :idt_workdate - 1 (전영업일자)
        String workDate = ja020pService.getWorkDate(corpGr);
        String junyongDate = ja020pService.getJunyongDate(corpGr);
        String initialYmd = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : ((junyongDate != null && !junyongDate.isBlank()) ? junyongDate : workDate);

        // 계좌관리그룹 안내 텍스트 (SZX0SE LISTAGG)
        String seriesGroupText = ja020pService.getSeriesGroupInfo(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", initialYmd);
        model.addAttribute("ymd", initialYmd);
        model.addAttribute("seriesGroupText", seriesGroupText);

        return "views/subscriptionrights/w_ja020p";
    }

    /**
     * 계좌관리그룹 안내 문자열 조회 API (회사그룹 변경 시 실시간 갱신용)
     */
    @GetMapping("/api/subscriptionrights/ja020p/series-info")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getSeriesInfo(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        String info = ja020pService.getSeriesGroupInfo(corpGr);
        String workDate = ja020pService.getWorkDate(corpGr);
        String junyongDate = ja020pService.getJunyongDate(corpGr);

        Map<String, Object> result = new HashMap<>();
        result.put("seriesGroupText", info);
        result.put("workDate", workDate);
        result.put("junyongDate", junyongDate);

        return ResponseEntity.ok(result);
    }

    /**
     * 채권비율보고 리포트 미리보기 API (GET /api/subscriptionrights/ja020p/preview)
     */
    @GetMapping("/api/subscriptionrights/ja020p/preview")
    public ResponseEntity<byte[]> preview(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "format", defaultValue = "pdf") String format,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
            jakarta.servlet.http.HttpServletResponse response) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        try {
            String downloadName = "채권비율보고_" + (ymd != null ? ymd.replace("-", "") : "");
            RdReportService.ExportResult result = ja020pService.generateReport(corpGr, ymd, format, downloadName);

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
            log.error("[Ja020pController] 미리보기 오류: corpGr={}, ymd={}, err={}", corpGr, ymd, e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * 채권비율보고 리포트 다운로드 내보내기 API (GET /api/subscriptionrights/ja020p/export)
     */
    @GetMapping("/api/subscriptionrights/ja020p/export")
    public ResponseEntity<byte[]> export(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "format", defaultValue = "pdf") String format,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        try {
            String downloadName = "채권비율보고_" + (ymd != null ? ymd.replace("-", "") : "");
            RdReportService.ExportResult result = ja020pService.generateReport(corpGr, ymd, format, downloadName);

            MediaType mediaType = MediaType.parseMediaType(result.getContentType());
            return ResponseEntity.ok()
                    .contentType(mediaType)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodeFilename(result.getFilename()) + "\"")
                    .body(result.getData());
        } catch (Exception e) {
            log.error("[Ja020pController] 내보내기 오류: corpGr={}, ymd={}, format={}, err={}", corpGr, ymd, format, e.getMessage(), e);
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
