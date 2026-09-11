package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.common.service.WorkDateService;
import com.kfp.aams.domain.daily.dto.Ja010jDto;
import com.kfp.aams.domain.daily.service.Ja010jService;
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
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010jController {

    private final Ja010jService ja010jService;
    private final WorkDateService workDateService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja010j", "/views/daily/w_ja010j"})
    public String ja010jView(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "fymd", required = false) String paramFymd,
                             @RequestParam(name = "tymd", required = false) String paramTymd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA010J");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010j");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 공모청약 수요예측 참여표(회사)";

        // 파워빌더 w_ja010j.srw (wue_lastopen) 명세:
        // tymd = 기준일자(작업일자), fymd = 기준일자 기준 3개월 전 + 1일 (ADD_MONTHS(tymd, -3) + 1)
        String tymd = (paramTymd != null && !paramTymd.isBlank()) ? paramTymd : workDateService.getWorkDateOrDefault(corpGr);
        String fymd;
        try {
            LocalDate tDate = LocalDate.parse(tymd);
            fymd = (paramFymd != null && !paramFymd.isBlank()) ? paramFymd : tDate.minusMonths(3).plusDays(1).toString();
        } catch (Exception e) {
            fymd = LocalDate.now().minusMonths(3).plusDays(1).toString();
            tymd = LocalDate.now().toString();
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialTymd", tymd);
        model.addAttribute("initialFymd", fymd);
        model.addAttribute("tymd", tymd);
        model.addAttribute("fymd", fymd);

        return "views/daily/w_ja010j";
    }

    /**
     * 회사 변경 시 해당 회사의 기준일자 및 3개월 전 일자 조회 API (개발지침 달력 규칙 4)
     */
    @GetMapping("/api/daily/ja010j/workdate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String tymd = workDateService.getWorkDateOrDefault(corpGr);
        String fymd;
        try {
            LocalDate tDate = LocalDate.parse(tymd);
            fymd = tDate.minusMonths(3).plusDays(1).toString();
        } catch (Exception e) {
            fymd = LocalDate.now().minusMonths(3).plusDays(1).toString();
            tymd = LocalDate.now().toString();
        }

        Map<String, String> response = new HashMap<>();
        response.put("workDate", tymd);
        response.put("tymd", tymd);
        response.put("fymd", fymd);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/daily/ja010j/list")
    @ResponseBody
    public ResponseEntity<List<Ja010jDto>> getList(
            @RequestParam("corpGr") String corpGr,
            @RequestParam("ymd") String ymd) {
        List<Ja010jDto> list = ja010jService.selectJa010jList(corpGr, ymd);
        return ResponseEntity.ok(list);
    }

    @GetMapping("/api/daily/ja010j/preview")
    public ResponseEntity<byte[]> previewReport(
            @RequestParam("corpGr") String corpGr,
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "companyName", required = false) String companyName,
            @RequestParam(value = "fundNm", required = false) String fundNm,
            @RequestParam("fymd") String fymd,
            @RequestParam("tymd") String tymd) {
        try {
            RdReportService.ExportResult exportResult = ja010jService.generateReport(
                    corpGr, fundCd, companyName, fundNm, fymd, tymd, "pdf");

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ja010j_preview.pdf\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("공모청약 수요예측 참여표 (w_ja010j) 미리보기 오류: ", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/api/daily/ja010j/export")
    public ResponseEntity<byte[]> exportReport(
            @RequestParam("corpGr") String corpGr,
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "companyName", required = false) String companyName,
            @RequestParam(value = "fundNm", required = false) String fundNm,
            @RequestParam("fymd") String fymd,
            @RequestParam("tymd") String tymd,
            @RequestParam(value = "format", defaultValue = "pdf") String format) {
        try {
            RdReportService.ExportResult exportResult = ja010jService.generateReport(
                    corpGr, fundCd, companyName, fundNm, fymd, tymd, format);

            String encodedFileName = URLEncoder.encode(exportResult.getFilename(), StandardCharsets.UTF_8)
                    .replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(exportResult.getContentType()))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
                    .body(exportResult.getData());
        } catch (Exception e) {
            log.error("공모청약 수요예측 참여표 (w_ja010j) 내보내기 오류: ", e);
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
