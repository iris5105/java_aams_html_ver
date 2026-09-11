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
public class Ja020kController {

    private final RdReportService rdReportService;

    @GetMapping({"/views/w_ja020k", "/views/daily/w_ja020k"})
    public String ja020kView(Model model) {
        return "views/daily/w_ja020k";
    }

    @GetMapping("/api/daily/ja020k/preview")
    public ResponseEntity<byte[]> previewReport(
            @RequestParam(value = "seriesGb", defaultValue = "1110") String seriesGb,
            @RequestParam("ymd") String ymd) {
        try {
            RdReportService.ExportResult exportResult = rdReportService.generateJa020kReport(
                    seriesGb, ymd, "pdf");

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
            @RequestParam(value = "seriesGb", defaultValue = "1110") String seriesGb,
            @RequestParam("ymd") String ymd,
            @RequestParam(value = "format", defaultValue = "pdf") String format) {
        try {
            RdReportService.ExportResult exportResult = rdReportService.generateJa020kReport(
                    seriesGb, ymd, format);

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
}
