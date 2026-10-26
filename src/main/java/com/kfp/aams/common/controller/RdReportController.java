package com.kfp.aams.common.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kfp.aams.common.service.RdReportService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
 * - GET: iframe 인라인 미리보기 (/api/common/rd/preview) 및 파일 다운로드
 * (/api/common/rd/export)
 * - POST: JSON Body 기반 리포트 생성 지원
 */
@Slf4j
@RestController
@RequestMapping("/api/common/rd")
public class RdReportController {

    private final RdReportService rdReportService;
    private final ObjectMapper objectMapper;

    public RdReportController(RdReportService rdReportService, ObjectMapper objectMapper) {
        this.rdReportService = rdReportService;
        this.objectMapper = objectMapper;
    }

    // 예약어 키 목록 (RD 파라미터가 아닌 컨트롤러 제어용 파라미터)
    private static final Set<String> RESERVED_KEYS = new HashSet<>(Arrays.asList(
            "mrdname", "corpgr", "corp_gr", "format", "downloadname", "params", "t", "_"));

    private String sanitizeCorpGr(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) return null;
        corpGr = corpGr.trim();
        if (corpGr.contains(",")) {
            corpGr = corpGr.split(",")[0].trim();
        }
        return corpGr.isBlank() ? null : corpGr;
    }

    public static class RdReportRequest {
        private String mrdName;
        private String corpGr;
        private String format = "pdf";
        private String downloadName;
        private Map<String, Object> params = new LinkedHashMap<>();

        public RdReportRequest() {}

        public String getMrdName() {
            return mrdName;
        }

        public void setMrdName(String mrdName) {
            this.mrdName = mrdName;
        }

        public String getCorpGr() {
            return corpGr;
        }

        public void setCorpGr(String corpGr) {
            this.corpGr = corpGr;
        }

        public String getFormat() {
            return format;
        }

        public void setFormat(String format) {
            this.format = format;
        }

        public String getDownloadName() {
            return downloadName;
        }

        public void setDownloadName(String downloadName) {
            this.downloadName = downloadName;
        }

        public Map<String, Object> getParams() {
            return params;
        }

        public void setParams(Map<String, Object> params) {
            this.params = params;
        }
    }

    /**
     * 범용 리포트 미리보기 (GET /api/common/rd/preview)
     * - 데스크톱: PDF 브라우저 인라인 스트림 반환
     * - 모바일(User-Agent 감지 또는 format=html): M2soft HTML5 인라인 스트림 반환 (브라우저 PDF 차단 문제 완전 해결)
     */
    @GetMapping("/preview")
    public ResponseEntity<byte[]> preview(
            @RequestParam("mrdName") String mrdName,
            @RequestParam(value = "corpGr", required = false) String corpGr,
            @RequestParam(value = "format", defaultValue = "pdf") String format,
            @RequestParam(value = "downloadName", required = false) String downloadName,
            @RequestParam(value = "params", required = false) String paramsJson,
            @RequestHeader(value = "User-Agent", required = false) String userAgent,
            @RequestParam Map<String, String> allParams,
            jakarta.servlet.http.HttpServletResponse response) {

        try {
            corpGr = sanitizeCorpGr(corpGr);
            Map<String, Object> mergedParams = extractDynamicParams(allParams, paramsJson);
            String effectiveFormat = resolvePreviewFormat(format, userAgent);
            RdReportService.ExportResult result = rdReportService.generateReport(
                    corpGr, mrdName, mergedParams, effectiveFormat, downloadName);

            if (isHtmlFormat(effectiveFormat)) {
                response.setContentType("text/html; charset=UTF-8");
                response.setContentLength(result.getData().length);
                response.getOutputStream().write(result.getData());
                response.getOutputStream().flush();
                return null;
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, buildContentDisposition("inline", result.getFilename()))
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
            corpGr = sanitizeCorpGr(corpGr);
            Map<String, Object> mergedParams = extractDynamicParams(allParams, paramsJson);
            RdReportService.ExportResult result = rdReportService.generateReport(
                    corpGr, mrdName, mergedParams, format, downloadName);

            MediaType mediaType = MediaType.parseMediaType(result.getContentType());

            return ResponseEntity.ok()
                    .contentType(mediaType)
                    .header(HttpHeaders.CONTENT_DISPOSITION, buildContentDisposition("attachment", result.getFilename()))
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
    public ResponseEntity<byte[]> previewPost(
            @RequestBody RdReportRequest req,
            @RequestHeader(value = "User-Agent", required = false) String userAgent,
            jakarta.servlet.http.HttpServletResponse response) {
        try {
            String effectiveFormat = resolvePreviewFormat(req.getFormat(), userAgent);
            RdReportService.ExportResult result = rdReportService.generateReport(
                    sanitizeCorpGr(req.getCorpGr()), req.getMrdName(), req.getParams(), effectiveFormat, req.getDownloadName());

            if (isHtmlFormat(effectiveFormat)) {
                response.setContentType("text/html; charset=UTF-8");
                response.setContentLength(result.getData().length);
                response.getOutputStream().write(result.getData());
                response.getOutputStream().flush();
                return null;
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .header(HttpHeaders.CONTENT_DISPOSITION, buildContentDisposition("inline", result.getFilename()))
                    .body(result.getData());
        } catch (Exception e) {
            log.error("RD 공통 POST 미리보기 실패: mrdName={}, error={}", req.getMrdName(), e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * RFC 6266 / RFC 5987 호환 안전한 Content-Disposition 헤더 생성
     * - ASCII filename fallback을 제공하여 Tomcat의 ISO-8859-1 직렬화 시 UnmappableCharacterException 원천 방지
     * - filename*=UTF-8''... 표준 인코딩으로 모든 브라우저에서 한글 파일명 정상 표출
     */
    public static String buildContentDisposition(String dispositionType, String filename) {
        if (filename == null || filename.isBlank()) {
            filename = "report.pdf";
        }
        String ext = "";
        int dotIdx = filename.lastIndexOf('.');
        if (dotIdx >= 0) {
            ext = filename.substring(dotIdx);
        }
        String asciiFallback = "report" + ext;
        String encodedFilename = URLEncoder.encode(filename, StandardCharsets.UTF_8).replace("+", "%20");
        return dispositionType + "; filename=\"" + asciiFallback + "\"; filename*=UTF-8''" + encodedFilename;
    }

    private String resolvePreviewFormat(String format, String userAgent) {
        if (format != null && isHtmlFormat(format)) {
            return "html";
        }
        if (userAgent != null) {
            String ua = userAgent.toLowerCase();
            if (ua.contains("mobile") || ua.contains("android") || ua.contains("iphone") || ua.contains("ipad")) {
                return "html";
            }
        }
        return (format != null && !format.isBlank()) ? format : "pdf";
    }

    private boolean isHtmlFormat(String format) {
        if (format == null) return false;
        String f = format.trim().toLowerCase();
        return "html".equals(f) || "htm".equals(f) || "html5".equals(f);
    }

    /**
     * JSON 바디 기반 내보내기 (POST /api/common/rd/export)
     */
    @PostMapping("/export")
    public ResponseEntity<byte[]> exportPost(@RequestBody RdReportRequest req) {
        try {
            RdReportService.ExportResult result = rdReportService.generateReport(
                    sanitizeCorpGr(req.getCorpGr()), req.getMrdName(), req.getParams(), req.getFormat(), req.getDownloadName());

            MediaType mediaType = MediaType.parseMediaType(result.getContentType());

            return ResponseEntity.ok()
                    .contentType(mediaType)
                    .header(HttpHeaders.CONTENT_DISPOSITION, buildContentDisposition("attachment", result.getFilename()))
                    .body(result.getData());
        } catch (Exception e) {
            log.error("RD 공통 POST 내보내기 실패: mrdName={}, format={}, error={}", req.getMrdName(), req.getFormat(),
                    e.getMessage(), e);
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
                if (key == null || key.isBlank())
                    continue;
                if (RESERVED_KEYS.contains(key.trim().toLowerCase()))
                    continue;

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
