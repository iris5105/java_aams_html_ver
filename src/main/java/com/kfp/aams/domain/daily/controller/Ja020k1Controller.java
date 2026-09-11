package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Uzm0hyDto;
import com.kfp.aams.domain.daily.service.Ja020k1Service;
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
public class Ja020k1Controller {

    private final Ja020k1Service ja020k1Service;

    @GetMapping({"/views/w_ja020k1", "/views/daily/w_ja020k1"})
    public String ja020k1View(Model model) {
        return "views/daily/w_ja020k1";
    }

    @GetMapping("/api/daily/ja020k1/funds")
    @ResponseBody
    public ResponseEntity<List<Uzm0hyDto>> getFunds(
            @RequestParam("corpGr") String corpGr,
            @RequestParam("ymd") String ymd) {
        List<Uzm0hyDto> list = ja020k1Service.selectUzm0hyList(corpGr, ymd);
        return ResponseEntity.ok(list);
    }

    @GetMapping("/api/daily/ja020k1/preview")
    public ResponseEntity<byte[]> previewReport(
            @RequestParam("corpGr") String corpGr,
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "fundNm", required = false) String fundNm,
            @RequestParam("ymd") String ymd,
            @RequestParam(value = "gugan", defaultValue = "1") String gugan) {
        try {
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
            @RequestParam("corpGr") String corpGr,
            @RequestParam("fundCd") String fundCd,
            @RequestParam(value = "fundNm", required = false) String fundNm,
            @RequestParam("ymd") String ymd,
            @RequestParam(value = "gugan", defaultValue = "1") String gugan,
            @RequestParam(value = "format", defaultValue = "pdf") String format) {
        try {
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
}
