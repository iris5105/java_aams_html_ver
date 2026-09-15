package com.kfp.aams.domain.dailyadvisory.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kfp.aams.domain.dailyadvisory.service.RdReportService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * Crownix Report (MRD) 범용 API 컨트롤러
 * - 어떤 MRD 파일명이든, 몇 개의 가변 파라미터가 오든 단일 엔드포인트로 리포트 생성 및 내보내기 처리
 * - GET: iframe 인라인 미리보기 (/api/common/rd/preview) 및 파일 다운로드 (/api/common/rd/export)
 * - POST: JSON Body 기반 리포트 생성 지원
 */
@Slf4j
@RestController
@RequestMapping("/api/common/rd")
@RequiredArgsConstructor
public class RdReportController {

    private final RdReportService rdReportService;
    private final ObjectMapper objectMapper;

    // 예약어 키 목록 (RD 파라미터가 아닌 컨트롤러 제어용 파라미터)
    private static final Set<String> RESERVED_KEYS = new HashSet<>(Arrays.asList(
            "mrdname", "corpgr", "format", "downloadname", "params", "t", "_"
    ));

    @Data
    public static class RdReportRequest {
        private String mrdName;
        private String corpGr;
        private String format = "pdf";
        private String downloadName;
        private Map<String, Object> params = new LinkedHashMap<>();
    }

    /**
     * 범용 리포트 미리보기 (GET /api/common/rd/preview)
     * - iframe src 바인딩용 인라인 PDF 스트림 반환
     */
    @GetMapping("/preview")
    public ResponseEntity<byte[]> preview(
            @RequestParam("mrdName") String mrdName,
            @RequestParam(value = "corpGr", required = false) String corpGr,
            @RequestParam(value = "format", defaultValue = "pdf") String format,
            @RequestParam(value = "downloadName", required = false) String downloadName,
            @RequestParam(value = "params", required = false) String paramsJson,
            @RequestParam Map<String, String> allParams) {

        try {
            Map<String, Object> mergedParams = extractDynamicParams(allParams, paramsJson);
            RdReportService.ExportResult result = rdReportService.generateReport(
                    corpGr, mrdName, mergedParams, "pdf", downloadName);

            String encodedFilename = URLEncoder.encode(result.getFilename(), StandardCharsets.UTF_8).replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + encodedFilename + "\"; filename*=UTF-8''" + encodedFilename)
                    .body(result.getData());
        } catch (Exception e) {
            log.error("RD 공통 미리보기 실패: mrdName={}, error={}", mrdName, e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * 범용 리포트 파일 내보내기 (GET /api/common/rd/export)
     * - PDF, Excel, Word, PPT, HWP 다운로드 스트림 반환
     */
    @GetMapping("/export")
    public ResponseEntity<byte[]> export(
            @RequestParam("mrdName") String mrdName,
            @RequestParam(value = "corpGr", required = false) String corpGr,
            @RequestParam(value = "format", defaultValue = "pdf") String format,
            @RequestParam(value = "downloadName", required = false) String downloadName,
            @RequestParam(value = "params", required = false) String paramsJson,
            @RequestParam Map<String, String> allParams) {

        try {
            Map<String, Object> mergedParams = extractDynamicParams(allParams, paramsJson);
            RdReportService.ExportResult result = rdReportService.generateReport(
                    corpGr, mrdName, mergedParams, format, downloadName);

            String encodedFilename = URLEncoder.encode(result.getFilename(), StandardCharsets.UTF_8).replaceAll("\\+", "%20");
            MediaType mediaType = MediaType.parseMediaType(result.getContentType());

            return ResponseEntity.ok()
                    .contentType(mediaType)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFilename + "\"; filename*=UTF-8''" + encodedFilename)
                    .body(result.getData());
        } catch (Exception e) {
            log.error("RD 공통 내보내기 실패: mrdName={}, format={}, error={}", mrdName, format, e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * JSON 바디 기반 미리보기 (POST /api/common/rd/preview)
     */
    @PostMapping("/preview")
    public ResponseEntity<byte[]> previewPost(@RequestBody RdReportRequest req) {
        try {
            RdReportService.ExportResult result = rdReportService.generateReport(
                    req.getCorpGr(), req.getMrdName(), req.getParams(), "pdf", req.getDownloadName());

            String encodedFilename = URLEncoder.encode(result.getFilename(), StandardCharsets.UTF_8).replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + encodedFilename + "\"; filename*=UTF-8''" + encodedFilename)
                    .body(result.getData());
        } catch (Exception e) {
            log.error("RD 공통 POST 미리보기 실패: mrdName={}, error={}", req.getMrdName(), e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * JSON 바디 기반 내보내기 (POST /api/common/rd/export)
     */
    @PostMapping("/export")
    public ResponseEntity<byte[]> exportPost(@RequestBody RdReportRequest req) {
        try {
            RdReportService.ExportResult result = rdReportService.generateReport(
                    req.getCorpGr(), req.getMrdName(), req.getParams(), req.getFormat(), req.getDownloadName());

            String encodedFilename = URLEncoder.encode(result.getFilename(), StandardCharsets.UTF_8).replaceAll("\\+", "%20");
            MediaType mediaType = MediaType.parseMediaType(result.getContentType());

            return ResponseEntity.ok()
                    .contentType(mediaType)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFilename + "\"; filename*=UTF-8''" + encodedFilename)
                    .body(result.getData());
        } catch (Exception e) {
            log.error("RD 공통 POST 내보내기 실패: mrdName={}, format={}, error={}", req.getMrdName(), req.getFormat(), e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * 쿼리 파라미터 및 JSON 파라미터에서 가변 RD 파라미터들을 안전하게 추출/병합
     */
    @SuppressWarnings("unchecked")
    private Map<String, Object> extractDynamicParams(Map<String, String> allParams, String paramsJson) {
        Map<String, Object> merged = new LinkedHashMap<>();

        // 1. URL 쿼리 파라미터 중 예약어 외 모든 키를 RD 변수로 수집
        if (allParams != null) {
            for (Map.Entry<String, String> entry : allParams.entrySet()) {
                String key = entry.getKey();
                if (key == null || key.isBlank()) continue;
                if (RESERVED_KEYS.contains(key.trim().toLowerCase())) continue;

                merged.put(key.trim(), entry.getValue());
            }
        }

        // 2. params 파라미터로 별도 JSON이 넘어온 경우 병합
        if (paramsJson != null && !paramsJson.isBlank()) {
            try {
                Map<String, Object> jsonMap = objectMapper.readValue(paramsJson, LinkedHashMap.class);
                if (jsonMap != null) {
                    merged.putAll(jsonMap);
                }
            } catch (Exception e) {
                log.warn("params JSON 파싱 오류: {}", e.getMessage());
            }
        }

        return merged;
    }
}
