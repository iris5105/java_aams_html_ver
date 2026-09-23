package com.kfp.aams.domain.dailyadvisory.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.io.*;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Crownix Report (MRD) 기반 자체 파일 변환 및 내보내기 공통 서비스
 * - 가변 Key-Value(Map 또는 JSON) 파라미터를 받아 RD 규격 파라미터(/rv key[val] ...)로 동적 변환
 * - 클래스패스 내장 리소스(classpath:/rd/*.mrd) 기반으로 동작
 * - lib 폴더의 독립형 URLClassLoader를 통해 어떤 런타임 환경에서도 안정적으로 구동
 * - 지원 포맷: PDF, Excel(XLSX), MS Word(DOC), PowerPoint(PPTX), 한글(HWP)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class RdReportService {

    private final ObjectMapper objectMapper;
    private static final Map<String, Path> TEMPLATE_CACHE = new ConcurrentHashMap<>();
    private static volatile URLClassLoader rdClassLoader = null;

    @Getter
    @Builder
    public static class ExportResult {
        private byte[] data;
        private String filename;
        private String contentType;
    }

    /**
     * corpGr 파라미터가 없거나 비어있는 경우 현재 요청의 쿠키(savedCorpGr, corpGr) 및 SecurityContext에서 추출
     */
    public String resolveCorpGr(String corpGr) {
        if (corpGr != null && !corpGr.isBlank()) {
            return corpGr.trim();
        }

        // 1. 현재 HTTP 요청의 쿠키에서 조회
        try {
            ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs != null) {
                HttpServletRequest request = attrs.getRequest();
                if (request != null && request.getCookies() != null) {
                    for (Cookie c : request.getCookies()) {
                        if ("savedCorpGr".equals(c.getName()) && c.getValue() != null && !c.getValue().isBlank()) {
                            String val = URLDecoder.decode(c.getValue(), StandardCharsets.UTF_8).trim();
                            if (!val.isBlank()) return val;
                        }
                    }
                    for (Cookie c : request.getCookies()) {
                        if ("corpGr".equals(c.getName()) && c.getValue() != null && !c.getValue().isBlank()) {
                            String val = URLDecoder.decode(c.getValue(), StandardCharsets.UTF_8).trim();
                            if (!val.isBlank()) return val;
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.debug("쿠키에서 corpGr 추출 중 예외: {}", e.getMessage());
        }

        // 2. Spring SecurityContextHolder의 UserPrincipal에서 조회
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.getPrincipal() instanceof UserPrincipal p) {
                if (p.getCorpGr() != null && !p.getCorpGr().isBlank()) {
                    return p.getCorpGr().trim();
                }
            }
        } catch (Exception e) {
            log.debug("SecurityContext에서 corpGr 추출 중 예외: {}", e.getMessage());
        }

        return "";
    }

    /**
     * lib 폴더의 JAR들을 독립적으로 로드하는 격리된 URLClassLoader 반환
     */
    private static synchronized URLClassLoader getRdClassLoader() {
        if (rdClassLoader != null) {
            return rdClassLoader;
        }

        try {
            Path baseLib = Paths.get(System.getProperty("user.dir"), "lib");
            if (!Files.exists(baseLib)) {
                baseLib = Paths.get("d:/work/java_aams_html_ver/lib");
            }

            File[] jarFiles = baseLib.toFile().listFiles((dir, name) -> name.toLowerCase().endsWith(".jar"));
            if (jarFiles == null || jarFiles.length == 0) {
                log.warn("lib 폴더에서 JAR 파일을 찾을 수 없습니다: {}", baseLib);
                rdClassLoader = (URLClassLoader) RdReportService.class.getClassLoader();
                return rdClassLoader;
            }

            URL[] urls = new URL[jarFiles.length];
            for (int i = 0; i < jarFiles.length; i++) {
                urls[i] = jarFiles[i].toURI().toURL();
            }

            rdClassLoader = new URLClassLoader(urls, RdReportService.class.getClassLoader());
            log.info("Crownix RD 전용 독립 ClassLoader 생성 완료 (JAR 개수: {})", urls.length);
            return rdClassLoader;
        } catch (Exception e) {
            log.error("RD ClassLoader 생성 실패: {}", e.getMessage(), e);
            throw new RuntimeException("RD ClassLoader 생성 실패", e);
        }
    }

    /**
     * 클래스패스 리소스의 MRD 템플릿 파일을 로컬 임시 캐시 디렉터리로 추출하여 파일 경로 반환
     */
    public synchronized Path getTemplatePath(String mrdFileName) throws IOException {
        Path cached = TEMPLATE_CACHE.get(mrdFileName);
        if (cached != null && Files.exists(cached) && Files.size(cached) > 0) {
            return cached;
        }

        ClassPathResource resource = new ClassPathResource("rd/" + mrdFileName);
        Path target;
        Path tempDir = Path.of(System.getProperty("java.io.tmpdir"), "aams_rd_templates");
        if (!Files.exists(tempDir)) {
            Files.createDirectories(tempDir);
        }
        target = tempDir.resolve(mrdFileName);

        if (resource.exists()) {
            try (InputStream in = resource.getInputStream()) {
                Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
            }
        } else {
            Path fallback = Paths.get("pb_recource/02. RD", mrdFileName);
            if (!Files.exists(fallback)) {
                fallback = Paths.get(System.getProperty("user.dir"), "pb_recource/02. RD", mrdFileName);
            }
            if (Files.exists(fallback)) {
                Files.copy(fallback, target, StandardCopyOption.REPLACE_EXISTING);
            } else {
                throw new FileNotFoundException("리포트 템플릿 파일을 찾을 수 없습니다: classpath:rd/" + mrdFileName + " 또는 " + fallback.toAbsolutePath());
            }
        }

        TEMPLATE_CACHE.put(mrdFileName, target);
        log.info("RD 템플릿 추출 완료: {} -> {}", mrdFileName, target.toAbsolutePath());
        return target;
    }

    // =========================================================================
    // 1. 가변 Key-Value 파라미터 기반 범용 RD 리포트 생성 코어 (Universal Engine)
    // =========================================================================

    /**
     * Map 또는 JSON 기반 Key-Value 데이터를 RD 파라미터 문자열(/rv key[val] ...)로 동적 변환
     */
    public String buildRdParam(String corpGr, Map<String, Object> params) {
        corpGr = resolveCorpGr(corpGr);
        StringBuilder sb = new StringBuilder();
        sb.append("/rv ");

        boolean hasCorpGr = false;
        boolean hasZoom = false;
        boolean hasMessageBoxShow = false;

        if (params != null) {
            for (Map.Entry<String, Object> entry : params.entrySet()) {
                String key = entry.getKey();
                Object valObj = entry.getValue();
                if (key == null || key.isBlank() || valObj == null) continue;

                String k = key.trim();
                String v = String.valueOf(valObj).trim();

                // 예약어 및 시스템 제어 옵션 처리
                if ("corp_gr".equalsIgnoreCase(k)) {
                    hasCorpGr = true;
                    String targetCorp = (corpGr != null && !corpGr.isBlank()) ? corpGr : v;
                    sb.append("corp_gr[").append(targetCorp).append("] ");
                    continue;
                }
                if ("/rzoom".equalsIgnoreCase(k) || "rzoom".equalsIgnoreCase(k)) {
                    hasZoom = true;
                    sb.append("/rzoom [").append(v).append("] ");
                    continue;
                }
                if ("/rmessageboxshow".equalsIgnoreCase(k) || "rmessageboxshow".equalsIgnoreCase(k)) {
                    hasMessageBoxShow = true;
                    sb.append("/rmessageboxshow [").append(v).append("] ");
                    continue;
                }

                // 일반 RD 파라미터
                sb.append(k).append("[").append(v).append("] ");
            }
        }

        if (!hasCorpGr && corpGr != null && !corpGr.isBlank()) {
            sb.append("corp_gr[").append(corpGr).append("] ");
        }
        if (!hasZoom) {
            sb.append("/rzoom [120] ");
        }
        if (!hasMessageBoxShow) {
            sb.append("/rmessageboxshow [0]");
        }

        return sb.toString().trim();
    }

    /**
     * 가변 파라미터(Map) 기반 범용 RD 리포트 생성
     * @param corpGr 회사 그룹 코드 (null이면 자동 해석)
     * @param mrdName 대상 MRD 파일명 (예: "rd_ja010q.mrd")
     * @param params 가변 Key-Value 파라미터 맵
     * @param format 변환 포맷 (pdf, excel/xlsx, word/doc, ppt/pptx, hwp)
     * @param downloadFilename 저장/다운로드 파일명
     */
    public ExportResult generateReport(String corpGr, String mrdName, Map<String, Object> params,
                                       String format, String downloadFilename) throws Exception {
        if (mrdName == null || mrdName.isBlank()) {
            throw new IllegalArgumentException("MRD 파일명이 지정되지 않았습니다.");
        }
        corpGr = resolveCorpGr(corpGr);
        String targetMrd = mrdName.trim();

        // rd_ja010j.mrd 요청 시 fund_cd 및 corp_gr에 따라 실제 존재하는 MRD 파일로 매핑
        if ("rd_ja010j.mrd".equalsIgnoreCase(targetMrd)) {
            String fundCd = "0";
            if (params != null) {
                if (params.containsKey("fund_cd")) fundCd = String.valueOf(params.get("fund_cd"));
                else if (params.containsKey("fundCd")) fundCd = String.valueOf(params.get("fundCd"));
            }
            if ("0".equals(fundCd)) {
                targetMrd = "rd_ja010j_0.mrd";
            } else if ("1".equals(fundCd)) {
                targetMrd = "2202".equals(corpGr) ? "rd_ja010j_2202.mrd" : "rd_ja010j_1.mrd";
            } else if ("2".equals(fundCd)) {
                targetMrd = "rd_ja010j_2.mrd";
            } else {
                targetMrd = "rd_ja010j_6.mrd";
            }
        }

        Path mrdPath = getTemplatePath(targetMrd);
        String paramStr = buildRdParam(corpGr, params);

        log.info("RD 범용 리포트 생성 - MRD: {} (요청: {}), Param: {}, Format: {}", targetMrd, mrdName, paramStr, format);
        return executeRdEngine(mrdPath, paramStr, format, downloadFilename);
    }

    /**
     * 가변 파라미터(JSON 문자열) 기반 범용 RD 리포트 생성
     */
    @SuppressWarnings("unchecked")
    public ExportResult generateReportFromJson(String corpGr, String mrdName, String jsonParams,
                                               String format, String downloadFilename) throws Exception {
        Map<String, Object> params = new LinkedHashMap<>();
        if (jsonParams != null && !jsonParams.isBlank()) {
            params = objectMapper.readValue(jsonParams, LinkedHashMap.class);
        }
        return generateReport(corpGr, mrdName, params, format, downloadFilename);
    }

    /**
     * Crownix RD 엔진 구동 및 멀티 포맷 파일 변환 공통 실행 메소드
     */
    private ExportResult executeRdEngine(Path mrdPath, String paramStr, String format, String downloadFilename) throws Exception {
        String normalizedFormat = (format != null) ? format.trim().toLowerCase() : "pdf";
        String ext;
        String contentType;
        String saveMethodName;

        switch (normalizedFormat) {
            case "excel":
            case "xlsx":
            case "xls":
                ext = ".xlsx";
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                saveMethodName = "SaveAsXlsxFile";
                break;
            case "word":
            case "doc":
            case "docx":
                ext = ".doc";
                contentType = "application/msword";
                saveMethodName = "SaveAsWordFile";
                break;
            case "ppt":
            case "pptx":
                ext = ".pptx";
                contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                saveMethodName = "SaveAsPptxFile";
                break;
            case "hwp":
                ext = ".hwp";
                contentType = "application/x-hwp";
                saveMethodName = "SaveAsHwpFile";
                break;
            case "pdf":
            default:
                ext = ".pdf";
                contentType = "application/pdf";
                saveMethodName = "SaveAsPdfFile";
                break;
        }

        Path tempOut = Files.createTempFile("rd_export_", ext);
        ClassLoader originalClassLoader = Thread.currentThread().getContextClassLoader();
        try {
            URLClassLoader classLoader = getRdClassLoader();
            Thread.currentThread().setContextClassLoader(classLoader);

            Class<?> ssrdClass = classLoader.loadClass("m2soft.javard.gui.ServerSideRD");
            Object ssrd = ssrdClass.getDeclaredConstructor().newInstance();

            Method getRdCtrlMethod = ssrdClass.getMethod("getRdControl");
            Object rdCtrl = getRdCtrlMethod.invoke(ssrd);

            Method applyLicMethod = rdCtrl.getClass().getMethod("ApplyLicense", String.class);
            applyLicMethod.invoke(rdCtrl, "0.0.0.0");

            Method fileOpenMethod = rdCtrl.getClass().getMethod("FileOpen", String.class, String.class);
            Object openedObj = fileOpenMethod.invoke(rdCtrl, mrdPath.toAbsolutePath().toString(), paramStr);
            if (!Boolean.TRUE.equals(openedObj)) {
                Method getErrMsgMethod = rdCtrl.getClass().getMethod("GetLastErrorMessage");
                String errMsg = (String) getErrMsgMethod.invoke(rdCtrl);
                throw new RuntimeException("RD FileOpen 실패 (" + mrdPath.getFileName() + "): " + errMsg);
            }

            String outFilePath = tempOut.toAbsolutePath().toString();
            Method saveMethod = rdCtrl.getClass().getMethod(saveMethodName, String.class);
            Object savedObj = saveMethod.invoke(rdCtrl, outFilePath);
            if (!Boolean.TRUE.equals(savedObj) || !Files.exists(tempOut) || Files.size(tempOut) == 0) {
                throw new RuntimeException("리포트 파일 변환 실패 (" + normalizedFormat + ")");
            }

            byte[] fileBytes = Files.readAllBytes(tempOut);
            String finalName = (downloadFilename != null && !downloadFilename.isBlank())
                    ? (downloadFilename.endsWith(ext) ? downloadFilename : downloadFilename + ext)
                    : ("report_" + System.currentTimeMillis() + ext);

            log.info("RD 리포트 생성 성공: {} (크기: {} bytes)", finalName, fileBytes.length);

            return ExportResult.builder()
                    .data(fileBytes)
                    .filename(finalName)
                    .contentType(contentType)
                    .build();
        } finally {
            Thread.currentThread().setContextClassLoader(originalClassLoader);
            try {
                Files.deleteIfExists(tempOut);
            } catch (Exception ignored) {}
        }
    }

    // =========================================================================
    // 2. 기존 화면별 개별 메소드 (하위 호환성 100% 유지 위임 메소드)
    // =========================================================================

    /**
     * 자산명세표 (w_ja010h) 리포트 파일 생성
     */
    public ExportResult generateJa010hReport(boolean isColl, String corpGr, String ymd, String bfYmd,
                                            String fundCd, String fundNm, String format) throws Exception {
        String mrdName = isColl ? "rd_ja010h_coll.mrd" : "rd_ja010h.mrd";
        String ymdDot = (ymd != null) ? ymd.replace("-", ".") : "";
        String bfYmdDot = (bfYmd != null) ? bfYmd.replace("-", ".") : "";
        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";

        Map<String, Object> params = new LinkedHashMap<>();
        if (!ymdDot.isBlank()) params.put("ymd", ymdDot);
        if (!bfYmdDot.isBlank()) params.put("bf_ymd", bfYmdDot);
        if (fundCd != null && !fundCd.isBlank()) params.put("fund_cd", fundCd);

        String safeFundNm = (fundNm != null && !fundNm.isBlank()) ? fundNm.trim().replaceAll("[\\\\/:*?\"<>|]", "_") : "자산명세서";
        String downloadName = ymdClean + "_" + safeFundNm + "(" + fundCd + ")";

        return generateReport(corpGr, mrdName, params, format, downloadName);
    }

    /**
     * 자산명세표 (w_ja010h1) 리포트 파일 생성 (rd_ja010h1.mrd)
     */
    public ExportResult generateJa010h1Report(String corpGr, String ymd, String fundCd, String fundNm, String format) throws Exception {
        String ymdDot = (ymd != null) ? ymd.replace("-", ".") : "";
        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";

        Map<String, Object> params = new LinkedHashMap<>();
        if (!ymdDot.isBlank()) params.put("ymd", ymdDot);
        if (fundCd != null && !fundCd.isBlank()) params.put("fund_cd", fundCd);

        String safeFundNm = (fundNm != null && !fundNm.isBlank()) ? fundNm.trim().replaceAll("[\\\\/:*?\"<>|]", "_") : "자산명세표";
        String downloadName = ymdClean + "_" + safeFundNm + "(" + fundCd + ")";

        return generateReport(corpGr, "rd_ja010h1.mrd", params, format, downloadName);
    }

    /**
     * 파워빌더 cb_1 보유자산종합엑셀생성 명세
     */
    public ExportResult generateJa010hTotalReport(String corpGr, String ymd, String sunJasan, String format) throws Exception {
        corpGr = resolveCorpGr(corpGr);
        String mrdName = "2402".equals(corpGr) ? "rd_ja010h_00_2402.mrd" : "rd_ja010h_00.mrd";
        String ymdDot = (ymd != null) ? ymd.replace("-", ".") : "";
        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";

        Map<String, Object> params = new LinkedHashMap<>();
        if (!ymdDot.isBlank()) params.put("ymd", ymdDot);
        if (sunJasan != null && !sunJasan.isBlank()) params.put("sun_jasan", sunJasan);

        String downloadName = ymdClean + "_보유자산종합";
        return generateReport(corpGr, mrdName, params, format, downloadName);
    }

    /**
     * 주간 운용현황 (w_ja020k) 리포트 파일 생성
     */
    public ExportResult generateJa020kReport(String seriesGb, String ymd, String format) throws Exception {
        return generateJa020kReport(null, seriesGb, ymd, format);
    }

    public ExportResult generateJa020kReport(String corpGr, String seriesGb, String ymd, String format) throws Exception {
        String mrdName;
        if ("1110".equals(seriesGb)) {
            mrdName = "rd_ja020k1.mrd";
        } else if ("1120".equals(seriesGb)) {
            mrdName = "rd_ja020k2.mrd";
        } else {
            mrdName = "rd_ja020k3.mrd";
        }

        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";
        String ymdDot = ymdClean;
        if (ymdClean.length() == 8) {
            ymdDot = ymdClean.substring(0, 4) + "." + ymdClean.substring(4, 6) + "." + ymdClean.substring(6, 8);
        }

        Map<String, Object> params = new LinkedHashMap<>();
        if (seriesGb != null && !seriesGb.isBlank()) {
            params.put("series_gb", seriesGb);
            if ("1110".equals(seriesGb)) {
                params.put("gubun", "2");
            } else if ("1120".equals(seriesGb)) {
                params.put("gubun", "1");
            }
        }
        if (!ymdDot.isBlank()) {
            params.put("ymd", ymdDot);
        }

        String reportTitle = "1110".equals(seriesGb) ? "주간운용현황(공모)" : ("1120".equals(seriesGb) ? "주간운용현황(사모)" : "주간운용현황(일임)");
        String downloadName = ymdClean + "_" + reportTitle;

        return generateReport(corpGr, mrdName, params, format, downloadName);
    }

    /**
     * 계좌(종목)별 주간 운용현황 (w_ja020k1) 리포트 파일 생성
     */
    public ExportResult generateJa020k1Report(String mrdName, String fundCd, String fundNm,
                                             String guganText, String fymd, String tymd, String format) throws Exception {
        return generateJa020k1Report(null, mrdName, fundCd, fundNm, guganText, fymd, tymd, format);
    }

    public ExportResult generateJa020k1Report(String corpGr, String mrdName, String fundCd, String fundNm,
                                             String guganText, String fymd, String tymd, String format) throws Exception {
        String fymdClean = (fymd != null) ? fymd.replace("-", "").replace(".", "") : "";
        String tymdClean = (tymd != null) ? tymd.replace("-", "").replace(".", "") : "";

        Map<String, Object> params = new LinkedHashMap<>();
        if (fundCd != null && !fundCd.isBlank()) params.put("fund_cd", fundCd);
        if (fundNm != null && !fundNm.isBlank()) params.put("fund_nm", fundNm);
        if (guganText != null && !guganText.isBlank()) params.put("gugan", guganText);
        if (!fymdClean.isBlank()) params.put("fymd", fymdClean);
        if (!tymdClean.isBlank()) params.put("tymd", tymdClean);

        String safeFundNm = (fundNm != null && !fundNm.isBlank()) ? fundNm.trim().replaceAll("[\\\\/:*?\"<>|]", "_") : "주간운용현황";
        String downloadName = tymdClean + "_" + safeFundNm + "(" + fundCd + ")";

        return generateReport(corpGr, mrdName, params, format, downloadName);
    }

    /**
     * 성과보수 상세내역 (w_ja010q) 리포트 파일 생성 (rd_ja010q.mrd)
     */
    public ExportResult generateJa010qReport(String fundCd, String fundNm, String ymd,
                                            String bf, String af, String format) throws Exception {
        return generateJa010qReport(null, fundCd, fundNm, ymd, bf, af, format);
    }

    public ExportResult generateJa010qReport(String corpGr, String fundCd, String fundNm, String ymd,
                                            String bf, String af, String format) throws Exception {
        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";
        String bfDot = (bf != null) ? bf.replace("-", ".") : "";
        String afDot = (af != null) ? af.replace("-", ".") : "";

        Map<String, Object> params = new LinkedHashMap<>();
        if (fundCd != null && !fundCd.isBlank()) params.put("fund_cd", fundCd);
        if (!ymdClean.isBlank()) params.put("ymd", ymdClean);
        if (!bfDot.isBlank()) params.put("bf", bfDot);
        if (!afDot.isBlank()) params.put("af", afDot);

        String safeFundNm = (fundNm != null && !fundNm.isBlank()) ? fundNm.trim().replaceAll("[\\\\/:*?\"<>|]", "_") : "성과보수상세";
        String downloadName = ymdClean + "_" + safeFundNm + "(" + fundCd + ")";

        return generateReport(corpGr, "rd_ja010q.mrd", params, format, downloadName);
    }

    /**
     * 일별수익률현황 (w_ja010p1) 리포트 파일 생성 (rd_ja010p1.mrd)
     */
    public ExportResult generateJa010p1Report(String ymd, String format) throws Exception {
        return generateJa010p1Report(null, ymd, format);
    }

    public ExportResult generateJa010p1Report(String corpGr, String ymd, String format) throws Exception {
        String ymdDot = (ymd != null) ? ymd.replace("-", ".") : "";
        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";

        Map<String, Object> params = new LinkedHashMap<>();
        if (!ymdDot.isBlank()) params.put("ymd", ymdDot);

        String downloadName = ymdClean + "_일별수익률";
        return generateReport(corpGr, "rd_ja010p1.mrd", params, format, downloadName);
    }

    /**
     * 일보 (w_ja010j) 리포트 파일 생성
     */
    public ExportResult generateJa010jReport(String corpGr, String fundCd, String title,
                                            String fymd, String tymd, String format) throws Exception {
        corpGr = resolveCorpGr(corpGr);
        String mrdName;
        if ("0".equals(fundCd)) {
            mrdName = "rd_ja010j_0.mrd";
        } else if ("1".equals(fundCd)) {
            mrdName = "2202".equals(corpGr) ? "rd_ja010j_2202.mrd" : "rd_ja010j_1.mrd";
        } else if ("2".equals(fundCd)) {
            mrdName = "rd_ja010j_2.mrd";
        } else {
            mrdName = "rd_ja010j_6.mrd";
        }

        String fymdDot = (fymd != null) ? fymd.replace("-", ".") : "";
        String tymdDot = (tymd != null) ? tymd.replace("-", ".") : "";
        String tymdClean = (tymd != null) ? tymd.replace("-", "").replace(".", "") : "";

        Map<String, Object> params = new LinkedHashMap<>();
        if (fundCd != null && !fundCd.isBlank()) params.put("fund_cd", fundCd);
        if (title != null && !title.isBlank()) params.put("title", title);
        if (!fymdDot.isBlank()) params.put("fymd", fymdDot);
        if (!tymdDot.isBlank()) params.put("tymd", tymdDot);

        String safeTitle = (title != null && !title.isBlank()) ? title.trim().replaceAll("[\\\\/:*?\"<>|]", "_") : "일보";
        String downloadName = tymdClean + "_" + safeTitle;

        return generateReport(corpGr, mrdName, params, format, downloadName);
    }

    /**
     * 주식매매(매도)내역 (w_ja010m3) 리포트 파일 생성
     */
    public ExportResult generateJa010m3Report(String corpGr, String mrdName, String fundCd, String fundNm,
                                             String gyulYmd, String format) throws Exception {
        corpGr = resolveCorpGr(corpGr);
        String targetMrd = (mrdName != null && !mrdName.isBlank()) ? mrdName : ("2402".equals(corpGr) ? "rd_ja010m3_2402.mrd" : "rd_ja010m3_2201.mrd");
        String gyulYmdClean = (gyulYmd != null) ? gyulYmd.replace("-", "").replace(".", "") : "";

        Map<String, Object> params = new LinkedHashMap<>();
        if (fundCd != null && !fundCd.isBlank()) params.put("fund_cd", fundCd);
        if (fundNm != null && !fundNm.isBlank()) params.put("fund_nm", fundNm);
        if (!gyulYmdClean.isBlank()) params.put("gyul_ymd", gyulYmdClean);

        String safeFundNm = (fundNm != null && !fundNm.isBlank()) ? fundNm.trim().replaceAll("[\\\\/:*?\"<>|]", "_") : "체결내역";
        String downloadName = gyulYmdClean + "_" + safeFundNm + "(" + fundCd + ")";

        return generateReport(corpGr, targetMrd, params, format, downloadName);
    }
}
