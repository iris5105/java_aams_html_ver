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

    @GetMapping({"/views/w_ja010q", "/views/daily/w_ja010q"})
    public String ja010qView(Model model) {
        return "views/daily/w_ja010q";
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
