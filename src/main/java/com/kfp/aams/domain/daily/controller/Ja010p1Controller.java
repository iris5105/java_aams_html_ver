package com.kfp.aams.domain.daily.controller;

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

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010p1Controller {

    private final RdReportService rdReportService;

    @GetMapping({"/views/w_ja010p1", "/views/daily/w_ja010p1"})
    public String ja010p1View(Model model) {
        return "views/daily/w_ja010p1";
    }

    @GetMapping("/api/daily/ja010p1/preview")
    public ResponseEntity<byte[]> previewReport(@RequestParam("ymd") String ymd) {
        try {
            RdReportService.ExportResult exportResult = rdReportService.generateJa010p1Report(ymd, "pdf");

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
            @RequestParam("ymd") String ymd,
            @RequestParam(value = "format", defaultValue = "pdf") String format) {
        try {
            RdReportService.ExportResult exportResult = rdReportService.generateJa010p1Report(ymd, format);

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
}
