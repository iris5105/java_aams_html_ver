package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja010jDto;
import com.kfp.aams.domain.daily.service.Ja010jService;
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
public class Ja010jController {

    private final Ja010jService ja010jService;

    @GetMapping({"/views/w_ja010j", "/views/daily/w_ja010j"})
    public String ja010jView(Model model) {
        return "views/daily/w_ja010j";
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
}
