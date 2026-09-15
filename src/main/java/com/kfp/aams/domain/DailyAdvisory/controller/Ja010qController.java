package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja010qDto;
import com.kfp.aams.domain.daily.service.Ja010qService;
import com.kfp.aams.domain.daily.service.RdReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010qController {

    private final Ja010qService ja010qService;
    private final com.kfp.aams.domain.menu.service.MenuService menuService;

    @GetMapping({"/views/w_ja010q", "/views/daily/w_ja010q"})
    public String ja010qView(@org.springframework.security.core.annotation.AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @org.springframework.web.bind.annotation.CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @org.springframework.web.bind.annotation.CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        com.kfp.aams.security.UserPrincipal principal = (principalObj instanceof com.kfp.aams.security.UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA010Q");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010q");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 일일작업";

        // 파워빌더 w_ja010q.srw (wue_lastopen) 명세: SZX0AA.JUNYONG_YMD(2402) 또는 HYUN_YMD(기타)
        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja010qService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = java.time.LocalDate.now().toString();
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", workDate);
        model.addAttribute("initialYmd", workDate);

        return "views/daily/w_ja010q";
    }

    /**
     * API: 기준 작업일자 조회 (회사그룹 변경 시)
     */
    @GetMapping("/api/daily/ja010q/workdate")
    @ResponseBody
    public java.util.Map<String, String> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String workDate = ja010qService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = java.time.LocalDate.now().toString();
        }
        return java.util.Map.of("workDate", workDate);
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, com.kfp.aams.security.UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return null;
    }

    @GetMapping("/api/daily/ja010q/funds")
    @ResponseBody
    public ResponseEntity<List<Ja010qDto>> getFunds(
            @RequestParam("corpGr") String corpGr,
            @RequestParam("ymd") String ymd) {
        List<Ja010qDto> list = ja010qService.selectJa010qList(corpGr, ymd);
        return ResponseEntity.ok(list);
    }

    @GetMapping("/api/daily/ja010q/preview")
    public ResponseEntity<byte[]> previewReport(
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "fundNm", required = false) String fundNm,
            @RequestParam("ymd") String ymd,
            @RequestParam(value = "haejiYmd", required = false) String haejiYmd,
            @RequestParam(value = "afGyulYmd", required = false) String afGyulYmd,
            @RequestParam(value = "bfStart", required = false) String bfStart,
            @RequestParam(value = "af", required = false) String af) {
        try {
            RdReportService.ExportResult exportResult = ja010qService.generateReport(
                    fundCd, fundNm, ymd, haejiYmd, afGyulYmd, bfStart, af, "pdf");

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ja010q_preview.pdf\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("성과보수 상세내역 (w_ja010q) 미리보기 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/api/daily/ja010q/export")
    public ResponseEntity<byte[]> exportReport(
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "fundNm", required = false) String fundNm,
            @RequestParam("ymd") String ymd,
            @RequestParam(value = "haejiYmd", required = false) String haejiYmd,
            @RequestParam(value = "afGyulYmd", required = false) String afGyulYmd,
            @RequestParam(value = "bfStart", required = false) String bfStart,
            @RequestParam(value = "af", required = false) String af,
            @RequestParam(value = "format", defaultValue = "pdf") String format) {
        try {
            RdReportService.ExportResult exportResult = ja010qService.generateReport(
                    fundCd, fundNm, ymd, haejiYmd, afGyulYmd, bfStart, af, format);

            String encodedFileName = URLEncoder.encode(exportResult.getFilename(), StandardCharsets.UTF_8)
                    .replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(exportResult.getContentType()))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("성과보수 상세내역 (w_ja010q) 내보내기 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }
}
