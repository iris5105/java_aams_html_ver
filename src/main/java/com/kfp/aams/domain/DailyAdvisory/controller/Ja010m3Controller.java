package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.common.service.WorkDateService;
import com.kfp.aams.domain.daily.dto.Ja010m3Dto;
import com.kfp.aams.domain.daily.dto.Ja010m3SaveDto;
import com.kfp.aams.domain.daily.service.Ja010m3Service;
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
import org.springframework.web.bind.annotation.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010m3Controller {

    private final Ja010m3Service ja010m3Service;
    private final WorkDateService workDateService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja010m3", "/views/daily/w_ja010m3"})
    public String viewJa010m3(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @RequestParam(name = "dddw", required = false) String paramDddw,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA010M3");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010m3");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 자문일일 > 일일작업";

        // 파워빌더 w_ja010m3.srw (wue_lastopen) 명세:
        // dw_c.object.ymd [1] = f_add_months (idt_workdate, -36, null_dt)
        String workDate = workDateService.getWorkDateOrDefault(corpGr);
        String ymd;
        try {
            LocalDate wDate = LocalDate.parse(workDate);
            ymd = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : wDate.minusMonths(36).toString();
        } catch (Exception e) {
            ymd = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : LocalDate.now().minusMonths(36).toString();
        }
        String dddw = (paramDddw != null && !paramDddw.isBlank()) ? paramDddw : "1";

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", ymd);
        model.addAttribute("dddw", dddw);

        return "views/daily/w_ja010m3";
    }

    @GetMapping("/api/daily/ja010m3/list")
    @ResponseBody
    public ResponseEntity<List<Ja010m3Dto>> getList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "gyulYmd", required = false) String gyulYmd,
            @RequestParam(name = "sortGb", required = false, defaultValue = "1") String sortGb,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        boolean isAdmin = (principal != null && principal.getAuthorities() != null &&
                principal.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN")));

        List<Ja010m3Dto> list = ja010m3Service.getList(corpGr, gyulYmd, sortGb, isAdmin);
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/daily/ja010m3/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(
            @RequestBody Ja010m3SaveDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(null, cookieCorpGr, principal);

        if (saveDto != null && saveDto.getUpdatedList() != null) {
            for (Ja010m3SaveDto.Ja010m3ItemSaveDto item : saveDto.getUpdatedList()) {
                if (item.getCorpGr() == null || item.getCorpGr().isBlank()) {
                    item.setCorpGr(corpGr);
                }
            }
        }

        try {
            ja010m3Service.save(saveDto);
            return ResponseEntity.ok(Map.of("success", true, "message", "저장이 완료되었습니다."));
        } catch (Exception e) {
            log.error("Error saving ja010m3 detail:", e);
            return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "저장 중 오류가 발생했습니다: " + e.getMessage()));
        }
    }

    /**
     * 회사 변경 시 해당 회사의 기준일자 및 36개월 전 결산기준일 조회 API (개발지침 달력 규칙 4)
     */
    @GetMapping("/api/daily/ja010m3/workdate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWorkDate(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        String workDate = workDateService.getWorkDateOrDefault(corpGr);
        String ymd;
        try {
            LocalDate wDate = LocalDate.parse(workDate);
            ymd = wDate.minusMonths(36).toString();
        } catch (Exception e) {
            ymd = LocalDate.now().minusMonths(36).toString();
        }

        Map<String, String> response = new HashMap<>();
        response.put("workDate", workDate);
        response.put("ymd", ymd);
        return ResponseEntity.ok(response);
    }

    /**
     * 리포트 뷰어 표준 규격: 결산보고서 미리보기 API (PDF 브라우저 인라인 스트림)
     */
    @GetMapping("/api/daily/ja010m3/preview")
    public ResponseEntity<byte[]> previewReport(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam("mrdName") String mrdName,
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "fundNm", required = false) String fundNm,
            @RequestParam("gyulYmd") String gyulYmd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        try {
            RdReportService.ExportResult exportResult = ja010m3Service.generateReport(
                    corpGr, mrdName, fundCd, fundNm, gyulYmd, "pdf");

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ja010m3_preview.pdf\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("성과보수 상세내역 (w_ja010m3) 미리보기 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * 리포트 뷰어 표준 규격: 결산보고서 멀티 포맷 내보내기 API (PDF, Excel, Word, PPT, HWP)
     */
    @GetMapping("/api/daily/ja010m3/export")
    public ResponseEntity<byte[]> exportReport(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam("mrdName") String mrdName,
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "fundNm", required = false) String fundNm,
            @RequestParam("gyulYmd") String gyulYmd,
            @RequestParam(value = "format", defaultValue = "pdf") String format,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        try {
            RdReportService.ExportResult exportResult = ja010m3Service.generateReport(
                    corpGr, mrdName, fundCd, fundNm, gyulYmd, format);

            String encodedFileName = URLEncoder.encode(exportResult.getFilename(), StandardCharsets.UTF_8)
                    .replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(exportResult.getContentType()))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("성과보수 상세내역 (w_ja010m3) 내보내기 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr;
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr;
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr();
        }
        return "";
    }
}
