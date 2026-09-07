package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja010hMasterDto;
import com.kfp.aams.domain.daily.service.Ja010hService;
import com.kfp.aams.domain.daily.service.RdReportService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;

/**
 * Controller for w_ja010h (Asset Statement / 자산명세표)
 * Supports PDF Preview and Multi-Format Export (PDF, Excel, Word, PPT, HWP)
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010hController {

    private final Ja010hService ja010hService;
    private final MenuService menuService;

    /**
     * 뷰 템플릿 렌더링
     */
    @GetMapping({"/views/w_ja010h", "/views/daily/w_ja010h"})
    public String viewJa010h(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model,
                             HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA010H");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010h");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 자산명세표";
        List<String> trDates = (corpGr != null && !corpGr.isBlank()) ? ja010hService.getDates(corpGr) : Collections.emptyList();
        String ymd = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd
                : (!trDates.isEmpty() ? trDates.get(0) : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", ymd);
        model.addAttribute("trDates", trDates);

        return "views/daily/w_ja010h";
    }

    /**
     * 펀드 목록 API (d_szm0ia.srd)
     */
    @GetMapping("/api/daily/ja010h/list")
    @ResponseBody
    public List<Ja010hMasterDto> getList(@AuthenticationPrincipal Object principalObj,
                                         @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                         @RequestParam("ymd") String ymd,
                                         @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                         @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        return ja010hService.getFundList(corpGr, ymd);
    }

    /**
     * 캘린더 일자 목록 API
     */
    @GetMapping("/api/daily/ja010h/dates")
    @ResponseBody
    public List<String> getDates(@AuthenticationPrincipal Object principalObj,
                                 @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                 @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                 @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        return ja010hService.getDates(corpGr);
    }

    /**
     * PDF 미리보기 스트림 (화면 우측 iframe 임베드용)
     */
    @GetMapping("/api/daily/ja010h/preview")
    public ResponseEntity<byte[]> previewReport(@AuthenticationPrincipal Object principalObj,
                                                @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                @RequestParam("ymd") String ymd,
                                                @RequestParam("fundCd") String fundCd,
                                                @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                                @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        try {
            RdReportService.ExportResult res = ja010hService.previewReport(corpGr, ymd, fundCd);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDisposition(ContentDisposition.inline()
                    .filename(res.getFilename(), StandardCharsets.UTF_8)
                    .build());
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(res.getData());
        } catch (Exception e) {
            log.error("PDF 미리보기 생성 실패: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * 포맷별 리포트 파일 다운로드 API (PDF, Excel, Word, PPT, HWP)
     */
    @GetMapping("/api/daily/ja010h/export")
    public ResponseEntity<byte[]> exportReport(@AuthenticationPrincipal Object principalObj,
                                               @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                               @RequestParam("ymd") String ymd,
                                               @RequestParam("fundCd") String fundCd,
                                               @RequestParam(name = "format", defaultValue = "pdf") String format,
                                               @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                               @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        try {
            RdReportService.ExportResult res = ja010hService.exportReport(corpGr, ymd, fundCd, format);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.parseMediaType(res.getContentType()));
            headers.setContentDisposition(ContentDisposition.attachment()
                    .filename(res.getFilename(), StandardCharsets.UTF_8)
                    .build());
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(res.getData());
        } catch (Exception e) {
            log.error("리포트 다운로드 생성 실패 (format={}): {}", format, e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr;
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr;
        }
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr();
        }
        return "";
    }
}
