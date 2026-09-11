package com.kfp.aams.domain.daily.service;

import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import lombok.Builder;
import lombok.Getter;
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
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Crownix Report (MRD) 기반 자체 파일 변환 및 내보내기 서비스
 * 외부 절대경로 및 .mrq 파일 없이 클래스패스 내장 리소스(classpath:/rd/*.mrd)를 기반으로 동작
 * lib 폴더의 독립형 URLClassLoader를 통해 어떤 런타임 환경에서도 안정적으로 구동
 * 지원 포맷: PDF, Excel(XLSX), MS Word(DOC), PowerPoint(PPTX), 한글(HWP)
 */
@Slf4j
@Service
public class RdReportService {

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

    /**
     * 자산명세표 (w_ja010h) 리포트 파일 생성
     */
    public ExportResult generateJa010hReport(boolean isColl, String corpGr, String ymd, String bfYmd,
                                            String fundCd, String fundNm, String format) throws Exception {
        corpGr = resolveCorpGr(corpGr);
        String mrdName = isColl ? "rd_ja010h_coll.mrd" : "rd_ja010h.mrd";
        Path mrdPath = getTemplatePath(mrdName);

        // 일자 포맷 변환 (yyyy.mm.dd)
        String ymdDot = (ymd != null) ? ymd.replace("-", ".") : "";
        String bfYmdDot = (bfYmd != null) ? bfYmd.replace("-", ".") : "";
        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";

        // 파라미터 구성: /rv corp_gr[...] ymd[...] bf_ymd[...] fund_cd[...] /rmessageboxshow [0]
        StringBuilder param = new StringBuilder();
        param.append("/rv ");
        if (corpGr != null && !corpGr.isBlank()) param.append("corp_gr[").append(corpGr).append("] ");
        if (!ymdDot.isBlank()) param.append("ymd[").append(ymdDot).append("] ");
        if (!bfYmdDot.isBlank()) param.append("bf_ymd[").append(bfYmdDot).append("] ");
        if (fundCd != null && !fundCd.isBlank()) param.append("fund_cd[").append(fundCd).append("] ");
        param.append("/rzoom [120] /rmessageboxshow [0]");

        log.info("RD 리포트 생성 시작 - MRD: {}, Param: {}, Format: {}", mrdName, param, format);

        String normalizedFormat = (format != null) ? format.trim().toLowerCase() : "pdf";
        String ext;
        String contentType;

        switch (normalizedFormat) {
            case "excel":
            case "xlsx":
            case "xls":
                ext = ".xlsx";
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                break;
            case "word":
            case "doc":
            case "docx":
                ext = ".doc";
                contentType = "application/msword";
                break;
            case "ppt":
            case "pptx":
                ext = ".pptx";
                contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                break;
            case "hwp":
                ext = ".hwp";
                contentType = "application/x-hwp";
                break;
            case "pdf":
            default:
                ext = ".pdf";
                contentType = "application/pdf";
                break;
        }

        // 임시 출력 파일 생성
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
            Object openedObj = fileOpenMethod.invoke(rdCtrl, mrdPath.toAbsolutePath().toString(), param.toString());
            boolean opened = Boolean.TRUE.equals(openedObj);
            if (!opened) {
                throw new IllegalStateException("MRD 파일을 열 수 없습니다: " + mrdPath);
            }

            // 비동기 처리 안정성을 위한 짧은 대기
            Thread.sleep(500);

            String outFilePath = tempOut.toAbsolutePath().toString();
            String saveMethodName;
            switch (normalizedFormat) {
                case "excel":
                case "xlsx":
                case "xls":
                    saveMethodName = "SaveAsXlsxFile";
                    break;
                case "word":
                case "doc":
                case "docx":
                    saveMethodName = "SaveAsWordFile";
                    break;
                case "ppt":
                case "pptx":
                    saveMethodName = "SaveAsPptxFile";
                    break;
                case "hwp":
                    saveMethodName = "SaveAsHwpFile";
                    break;
                case "pdf":
                default:
                    saveMethodName = "SaveAsPdfFile";
                    break;
            }

            Method saveMethod = rdCtrl.getClass().getMethod(saveMethodName, String.class);
            Object savedObj = saveMethod.invoke(rdCtrl, outFilePath);
            boolean saved = Boolean.TRUE.equals(savedObj);

            if (!saved || !Files.exists(tempOut) || Files.size(tempOut) == 0) {
                throw new RuntimeException("리포트 변환 파일 생성 실패 (" + normalizedFormat + ")");
            }

            byte[] fileBytes = Files.readAllBytes(tempOut);
            String safeFundNm = (fundNm != null && !fundNm.isBlank()) ? fundNm.trim().replaceAll("[\\\\/:*?\"<>|]", "_") : "자산명세표";
            String downloadName = ymdClean + "_" + safeFundNm + "(" + fundCd + ")" + ext;

            log.info("RD 리포트 생성 성공: {} (크기: {} bytes)", downloadName, fileBytes.length);

            return ExportResult.builder()
                    .data(fileBytes)
                    .filename(downloadName)
                    .contentType(contentType)
                    .build();

        } finally {
            Thread.currentThread().setContextClassLoader(originalClassLoader);
            try {
                Files.deleteIfExists(tempOut);
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * 자산명세표 (w_ja010h1) 리포트 파일 생성 (rd_ja010h1.mrd)
     */
    public ExportResult generateJa010h1Report(String corpGr, String ymd, String fundCd, String fundNm, String format) throws Exception {
        corpGr = resolveCorpGr(corpGr);
        String mrdName = "rd_ja010h1.mrd";
        Path mrdPath = getTemplatePath(mrdName);

        String ymdDot = (ymd != null) ? ymd.replace("-", ".") : "";
        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";

        StringBuilder param = new StringBuilder();
        param.append("/rv ");
        if (corpGr != null && !corpGr.isBlank()) param.append("corp_gr[").append(corpGr).append("] ");
        if (!ymdDot.isBlank()) param.append("ymd[").append(ymdDot).append("] ");
        if (fundCd != null && !fundCd.isBlank()) param.append("fund_cd[").append(fundCd).append("] ");
        param.append("/rzoom [120] /rmessageboxshow [0]");

        log.info("RD w_ja010h1 리포트 생성 시작 - MRD: {}, Param: {}, Format: {}", mrdName, param, format);

        String normalizedFormat = (format != null) ? format.trim().toLowerCase() : "pdf";
        String ext;
        String contentType;

        switch (normalizedFormat) {
            case "excel":
            case "xlsx":
            case "xls":
                ext = ".xlsx";
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                break;
            case "word":
            case "doc":
            case "docx":
                ext = ".doc";
                contentType = "application/msword";
                break;
            case "ppt":
            case "pptx":
                ext = ".pptx";
                contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                break;
            case "hwp":
                ext = ".hwp";
                contentType = "application/x-hwp";
                break;
            case "pdf":
            default:
                ext = ".pdf";
                contentType = "application/pdf";
                break;
        }

        Path tempOut = Files.createTempFile("rd_export_h1_", ext);
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
            Object openedObj = fileOpenMethod.invoke(rdCtrl, mrdPath.toAbsolutePath().toString(), param.toString());
            boolean opened = Boolean.TRUE.equals(openedObj);

            if (!opened) {
                Method getErrMsgMethod = rdCtrl.getClass().getMethod("GetLastErrorMessage");
                String errMsg = (String) getErrMsgMethod.invoke(rdCtrl);
                throw new RuntimeException("RD FileOpen 실패: " + errMsg);
            }

            String outFilePath = tempOut.toAbsolutePath().toString();
            String saveMethodName;

            switch (normalizedFormat) {
                case "excel":
                case "xlsx":
                case "xls":
                    saveMethodName = "SaveAsXlsxFile";
                    break;
                case "word":
                case "doc":
                case "docx":
                    saveMethodName = "SaveAsWordFile";
                    break;
                case "ppt":
                case "pptx":
                    saveMethodName = "SaveAsPptxFile";
                    break;
                case "hwp":
                    saveMethodName = "SaveAsHwpFile";
                    break;
                case "pdf":
                default:
                    saveMethodName = "SaveAsPdfFile";
                    break;
            }

            Method saveMethod = rdCtrl.getClass().getMethod(saveMethodName, String.class);
            Object savedObj = saveMethod.invoke(rdCtrl, outFilePath);
            boolean saved = Boolean.TRUE.equals(savedObj);

            if (!saved || !Files.exists(tempOut) || Files.size(tempOut) == 0) {
                throw new RuntimeException("리포트 변환 파일 생성 실패 (" + normalizedFormat + ")");
            }

            byte[] fileBytes = Files.readAllBytes(tempOut);
            String safeFundNm = (fundNm != null && !fundNm.isBlank()) ? fundNm.trim().replaceAll("[\\\\/:*?\"<>|]", "_") : "자산명세표";
            String downloadName = ymdClean + "_" + safeFundNm + "(" + fundCd + ")" + ext;

            log.info("RD 리포트 생성 성공: {} (크기: {} bytes)", downloadName, fileBytes.length);

            return ExportResult.builder()
                    .data(fileBytes)
                    .filename(downloadName)
                    .contentType(contentType)
                    .build();

        } finally {
            Thread.currentThread().setContextClassLoader(originalClassLoader);
            try {
                Files.deleteIfExists(tempOut);
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * 보유자산 종합 리포트 생성 (rd_ja010h_00_2402.mrd / rd_ja010h_00.mrd)
     * 파워빌더 cb_1 보유자산종합엑셀생성 명세
     */
    public ExportResult generateJa010hTotalReport(String corpGr, String ymd, String sunJasan, String format) throws Exception {
        corpGr = resolveCorpGr(corpGr);
        String mrdName = "2402".equals(corpGr) ? "rd_ja010h_00_2402.mrd" : "rd_ja010h_00.mrd";
        Path mrdPath = getTemplatePath(mrdName);

        String ymdDot = (ymd != null) ? ymd.replace("-", ".") : "";
        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";

        StringBuilder param = new StringBuilder();
        param.append("/rv ");
        if (corpGr != null && !corpGr.isBlank()) param.append("corp_gr[").append(corpGr).append("] ");
        if (!ymdDot.isBlank()) param.append("ymd[").append(ymdDot).append("] ");
        if (sunJasan != null && !sunJasan.isBlank()) param.append("sun_jasan[").append(sunJasan).append("] ");
        param.append("/rzoom [120] /rmessageboxshow [0]");

        log.info("RD 보유자산 종합 리포트 생성 시작 - MRD: {}, Param: {}, Format: {}", mrdName, param, format);

        String normalizedFormat = (format != null) ? format.trim().toLowerCase() : "excel";
        String ext;
        String contentType;

        switch (normalizedFormat) {
            case "pdf":
                ext = ".pdf";
                contentType = "application/pdf";
                break;
            case "word":
            case "doc":
            case "docx":
                ext = ".doc";
                contentType = "application/msword";
                break;
            case "ppt":
            case "pptx":
                ext = ".pptx";
                contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                break;
            case "hwp":
                ext = ".hwp";
                contentType = "application/x-hwp";
                break;
            case "excel":
            case "xlsx":
            case "xls":
            default:
                ext = ".xlsx";
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                break;
        }

        Path tempOut = Files.createTempFile("rd_export_total_", ext);
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
            Object openedObj = fileOpenMethod.invoke(rdCtrl, mrdPath.toAbsolutePath().toString(), param.toString());
            boolean opened = Boolean.TRUE.equals(openedObj);

            if (!opened) {
                Method getErrMsgMethod = rdCtrl.getClass().getMethod("GetLastErrorMessage");
                String errMsg = (String) getErrMsgMethod.invoke(rdCtrl);
                throw new RuntimeException("RD FileOpen 실패: " + errMsg);
            }

            String outFilePath = tempOut.toAbsolutePath().toString();
            String saveMethodName;

            switch (normalizedFormat) {
                case "pdf":
                    saveMethodName = "SaveAsPdfFile";
                    break;
                case "word":
                case "doc":
                case "docx":
                    saveMethodName = "SaveAsWordFile";
                    break;
                case "ppt":
                case "pptx":
                    saveMethodName = "SaveAsPptxFile";
                    break;
                case "hwp":
                    saveMethodName = "SaveAsHwpFile";
                    break;
                case "excel":
                case "xlsx":
                case "xls":
                default:
                    saveMethodName = "SaveAsXlsxFile";
                    break;
            }

            Method saveMethod = rdCtrl.getClass().getMethod(saveMethodName, String.class);
            Object savedObj = saveMethod.invoke(rdCtrl, outFilePath);
            boolean saved = Boolean.TRUE.equals(savedObj);

            if (!saved || !Files.exists(tempOut) || Files.size(tempOut) == 0) {
                throw new RuntimeException("종합 리포트 변환 파일 생성 실패 (" + normalizedFormat + ")");
            }

            byte[] fileBytes = Files.readAllBytes(tempOut);
            String downloadName = "보유자산종합현황(" + ymdClean + ")" + ext;

            log.info("RD 종합 리포트 생성 성공: {} (크기: {} bytes)", downloadName, fileBytes.length);

            return ExportResult.builder()
                    .data(fileBytes)
                    .filename(downloadName)
                    .contentType(contentType)
                    .build();

        } finally {
            Thread.currentThread().setContextClassLoader(originalClassLoader);
            try {
                Files.deleteIfExists(tempOut);
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * 일(종목)별 운용현황 (w_ja020k) 리포트 파일 생성
     * series_gb == '1110' -> rd_ja020k1.mrd
     * series_gb == '1120' -> rd_ja020k2.mrd
     * 그 외 -> rd_ja020k3.mrd
     */
    public ExportResult generateJa020kReport(String seriesGb, String ymd, String format) throws Exception {
        return generateJa020kReport(null, seriesGb, ymd, format);
    }

    public ExportResult generateJa020kReport(String corpGr, String seriesGb, String ymd, String format) throws Exception {
        corpGr = resolveCorpGr(corpGr);

        String mrdName;
        if ("1110".equals(seriesGb)) {
            mrdName = "rd_ja020k1.mrd";
        } else if ("1120".equals(seriesGb)) {
            mrdName = "rd_ja020k2.mrd";
        } else {
            mrdName = "rd_ja020k3.mrd";
        }
        Path mrdPath = getTemplatePath(mrdName);

        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";
        String ymdDot = ymdClean;
        if (ymdClean.length() == 8) {
            ymdDot = ymdClean.substring(0, 4) + "." + ymdClean.substring(4, 6) + "." + ymdClean.substring(6, 8);
        }

        StringBuilder param = new StringBuilder();
        param.append("/rv ");
        if (corpGr != null && !corpGr.isBlank()) {
            param.append("corp_gr[").append(corpGr).append("] ");
        }
        if (seriesGb != null && !seriesGb.isBlank()) {
            param.append("series_gb[").append(seriesGb).append("] ");
            // gubun 매핑 (1110 -> 2, 1120 -> 1, 파워빌더 rd_ja020k1.mrq 호환)
            if ("1110".equals(seriesGb)) {
                param.append("gubun[2] ");
            } else if ("1120".equals(seriesGb)) {
                param.append("gubun[1] ");
            }
        }
        if (!ymdDot.isBlank()) {
            param.append("ymd[").append(ymdDot).append("] ");
        }
        param.append("/rzoom [120] /rmessageboxshow [0]");

        log.info("RD w_ja020k 리포트 생성 시작 - MRD: {}, Param: {}, Format: {}", mrdName, param, format);

        String normalizedFormat = (format != null) ? format.trim().toLowerCase() : "pdf";
        String ext;
        String contentType;

        switch (normalizedFormat) {
            case "excel":
            case "xlsx":
            case "xls":
                ext = ".xlsx";
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                break;
            case "word":
            case "doc":
            case "docx":
                ext = ".doc";
                contentType = "application/msword";
                break;
            case "ppt":
            case "pptx":
                ext = ".pptx";
                contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                break;
            case "hwp":
                ext = ".hwp";
                contentType = "application/x-hwp";
                break;
            case "pdf":
            default:
                ext = ".pdf";
                contentType = "application/pdf";
                break;
        }

        Path tempOut = Files.createTempFile("rd_export_20k_", ext);
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
            Object openedObj = fileOpenMethod.invoke(rdCtrl, mrdPath.toAbsolutePath().toString(), param.toString());
            boolean opened = Boolean.TRUE.equals(openedObj);

            if (!opened) {
                Method getErrMsgMethod = rdCtrl.getClass().getMethod("GetLastErrorMessage");
                String errMsg = (String) getErrMsgMethod.invoke(rdCtrl);
                throw new RuntimeException("RD FileOpen 실패: " + errMsg);
            }

            String outFilePath = tempOut.toAbsolutePath().toString();
            String saveMethodName;

            switch (normalizedFormat) {
                case "excel":
                case "xlsx":
                case "xls":
                    saveMethodName = "SaveAsXlsxFile";
                    break;
                case "word":
                case "doc":
                case "docx":
                    saveMethodName = "SaveAsWordFile";
                    break;
                case "ppt":
                case "pptx":
                    saveMethodName = "SaveAsPptxFile";
                    break;
                case "hwp":
                    saveMethodName = "SaveAsHwpFile";
                    break;
                case "pdf":
                default:
                    saveMethodName = "SaveAsPdfFile";
                    break;
            }

            Method saveMethod = rdCtrl.getClass().getMethod(saveMethodName, String.class);
            Object savedObj = saveMethod.invoke(rdCtrl, outFilePath);
            boolean saved = Boolean.TRUE.equals(savedObj);

            if (!saved || !Files.exists(tempOut) || Files.size(tempOut) == 0) {
                throw new RuntimeException("리포트 변환 파일 생성 실패 (" + normalizedFormat + ")");
            }

            byte[] fileBytes = Files.readAllBytes(tempOut);
            String downloadName = ymdClean + "_일별운용현황(" + seriesGb + ")" + ext;

            log.info("RD 리포트 생성 성공: {} (크기: {} bytes)", downloadName, fileBytes.length);

            return ExportResult.builder()
                    .data(fileBytes)
                    .filename(downloadName)
                    .contentType(contentType)
                    .build();

        } finally {
            Thread.currentThread().setContextClassLoader(originalClassLoader);
            try {
                Files.deleteIfExists(tempOut);
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * 계좌(종목)별 주간 운용현황 (w_ja020k1) 리포트 파일 생성
     * mrd: rd_ja020k1w.mrd, rd_ja020k2w.mrd, rd_ja020k3w.mrd
     */
    public ExportResult generateJa020k1Report(String mrdName, String fundCd, String fundNm,
                                             String guganText, String fymd, String tymd, String format) throws Exception {
        return generateJa020k1Report(null, mrdName, fundCd, fundNm, guganText, fymd, tymd, format);
    }

    public ExportResult generateJa020k1Report(String corpGr, String mrdName, String fundCd, String fundNm,
                                             String guganText, String fymd, String tymd, String format) throws Exception {
        corpGr = resolveCorpGr(corpGr);
        Path mrdPath = getTemplatePath(mrdName);

        String fymdClean = (fymd != null) ? fymd.replace("-", "").replace(".", "") : "";
        String tymdClean = (tymd != null) ? tymd.replace("-", "").replace(".", "") : "";

        StringBuilder param = new StringBuilder();
        param.append("/rv ");
        if (corpGr != null && !corpGr.isBlank()) param.append("corp_gr[").append(corpGr).append("] ");
        if (fundCd != null && !fundCd.isBlank()) param.append("fund_cd[").append(fundCd).append("] ");
        if (fundNm != null && !fundNm.isBlank()) param.append("fund_nm[").append(fundNm).append("] ");
        if (guganText != null && !guganText.isBlank()) param.append("gugan[").append(guganText).append("] ");
        if (!fymdClean.isBlank()) param.append("fymd[").append(fymdClean).append("] ");
        if (!tymdClean.isBlank()) param.append("tymd[").append(tymdClean).append("] ");
        param.append("/rzoom [120] /rmessageboxshow [0]");

        log.info("RD w_ja020k1 리포트 생성 시작 - MRD: {}, Param: {}, Format: {}", mrdName, param, format);

        String normalizedFormat = (format != null) ? format.trim().toLowerCase() : "pdf";
        String ext;
        String contentType;

        switch (normalizedFormat) {
            case "excel":
            case "xlsx":
            case "xls":
                ext = ".xlsx";
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                break;
            case "word":
            case "doc":
            case "docx":
                ext = ".doc";
                contentType = "application/msword";
                break;
            case "ppt":
            case "pptx":
                ext = ".pptx";
                contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                break;
            case "hwp":
                ext = ".hwp";
                contentType = "application/x-hwp";
                break;
            case "pdf":
            default:
                ext = ".pdf";
                contentType = "application/pdf";
                break;
        }

        Path tempOut = Files.createTempFile("rd_export_20k1_", ext);
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
            Object openedObj = fileOpenMethod.invoke(rdCtrl, mrdPath.toAbsolutePath().toString(), param.toString());
            boolean opened = Boolean.TRUE.equals(openedObj);

            if (!opened) {
                Method getErrMsgMethod = rdCtrl.getClass().getMethod("GetLastErrorMessage");
                String errMsg = (String) getErrMsgMethod.invoke(rdCtrl);
                throw new RuntimeException("RD FileOpen 실패: " + errMsg);
            }

            String outFilePath = tempOut.toAbsolutePath().toString();
            String saveMethodName;

            switch (normalizedFormat) {
                case "excel":
                case "xlsx":
                case "xls":
                    saveMethodName = "SaveAsXlsxFile";
                    break;
                case "word":
                case "doc":
                case "docx":
                    saveMethodName = "SaveAsWordFile";
                    break;
                case "ppt":
                case "pptx":
                    saveMethodName = "SaveAsPptxFile";
                    break;
                case "hwp":
                    saveMethodName = "SaveAsHwpFile";
                    break;
                case "pdf":
                default:
                    saveMethodName = "SaveAsPdfFile";
                    break;
            }

            Method saveMethod = rdCtrl.getClass().getMethod(saveMethodName, String.class);
            Object savedObj = saveMethod.invoke(rdCtrl, outFilePath);
            boolean saved = Boolean.TRUE.equals(savedObj);

            if (!saved || !Files.exists(tempOut) || Files.size(tempOut) == 0) {
                throw new RuntimeException("리포트 변환 파일 생성 실패 (" + normalizedFormat + ")");
            }

            byte[] fileBytes = Files.readAllBytes(tempOut);
            String safeFundNm = (fundNm != null && !fundNm.isBlank()) ? fundNm.trim().replaceAll("[\\\\/:*?\"<>|]", "_") : "주간운용현황";
            String downloadName = tymdClean + "_" + safeFundNm + "(" + fundCd + ")" + ext;

            log.info("RD 리포트 생성 성공: {} (크기: {} bytes)", downloadName, fileBytes.length);

            return ExportResult.builder()
                    .data(fileBytes)
                    .filename(downloadName)
                    .contentType(contentType)
                    .build();

        } finally {
            Thread.currentThread().setContextClassLoader(originalClassLoader);
            try {
                Files.deleteIfExists(tempOut);
            } catch (Exception ignored) {
            }
        }
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
        corpGr = resolveCorpGr(corpGr);
        Path mrdPath = getTemplatePath(mrdName);

        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";
        String bfDot = (bf != null) ? bf.replace("-", ".") : "";
        String afDot = (af != null) ? af.replace("-", ".") : "";

        StringBuilder param = new StringBuilder();
        param.append("/rv ");
        if (corpGr != null && !corpGr.isBlank()) param.append("corp_gr[").append(corpGr).append("] ");
        if (fundCd != null && !fundCd.isBlank()) param.append("fund_cd[").append(fundCd).append("] ");
        if (!ymdClean.isBlank()) param.append("ymd[").append(ymdClean).append("] ");
        if (!bfDot.isBlank()) param.append("bf[").append(bfDot).append("] ");
        if (!afDot.isBlank()) param.append("af[").append(afDot).append("] ");
        param.append("/rzoom [120] /rmessageboxshow [0]");

        log.info("RD w_ja010q 리포트 생성 시작 - MRD: {}, Param: {}, Format: {}", mrdName, param, format);

        String normalizedFormat = (format != null) ? format.trim().toLowerCase() : "pdf";
        String ext;
        String contentType;

        switch (normalizedFormat) {
            case "excel":
            case "xlsx":
            case "xls":
                ext = ".xlsx";
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                break;
            case "word":
            case "doc":
            case "docx":
                ext = ".doc";
                contentType = "application/msword";
                break;
            case "ppt":
            case "pptx":
                ext = ".pptx";
                contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                break;
            case "hwp":
                ext = ".hwp";
                contentType = "application/x-hwp";
                break;
            case "pdf":
            default:
                ext = ".pdf";
                contentType = "application/pdf";
                break;
        }

        Path tempOut = Files.createTempFile("rd_export_10q_", ext);
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
            Object openedObj = fileOpenMethod.invoke(rdCtrl, mrdPath.toAbsolutePath().toString(), param.toString());
            boolean opened = Boolean.TRUE.equals(openedObj);

            if (!opened) {
                Method getErrMsgMethod = rdCtrl.getClass().getMethod("GetLastErrorMessage");
                String errMsg = (String) getErrMsgMethod.invoke(rdCtrl);
                throw new RuntimeException("RD FileOpen 실패: " + errMsg);
            }

            String outFilePath = tempOut.toAbsolutePath().toString();
            String saveMethodName;

            switch (normalizedFormat) {
                case "excel":
                case "xlsx":
                case "xls":
                    saveMethodName = "SaveAsXlsxFile";
                    break;
                case "word":
                case "doc":
                case "docx":
                    saveMethodName = "SaveAsWordFile";
                    break;
                case "ppt":
                case "pptx":
                    saveMethodName = "SaveAsPptxFile";
                    break;
                case "hwp":
                    saveMethodName = "SaveAsHwpFile";
                    break;
                case "pdf":
                default:
                    saveMethodName = "SaveAsPdfFile";
                    break;
            }

            Method saveMethod = rdCtrl.getClass().getMethod(saveMethodName, String.class);
            Object savedObj = saveMethod.invoke(rdCtrl, outFilePath);
            boolean saved = Boolean.TRUE.equals(savedObj);

            if (!saved || !Files.exists(tempOut) || Files.size(tempOut) == 0) {
                throw new RuntimeException("리포트 변환 파일 생성 실패 (" + normalizedFormat + ")");
            }

            byte[] fileBytes = Files.readAllBytes(tempOut);
            String safeFundNm = (fundNm != null && !fundNm.isBlank()) ? fundNm.trim().replaceAll("[\\\\/:*?\"<>|]", "_") : "성과보수상세";
            String downloadName = ymdClean + "_" + safeFundNm + "(" + fundCd + ")" + ext;

            log.info("RD 리포트 생성 성공: {} (크기: {} bytes)", downloadName, fileBytes.length);

            return ExportResult.builder()
                    .data(fileBytes)
                    .filename(downloadName)
                    .contentType(contentType)
                    .build();

        } finally {
            Thread.currentThread().setContextClassLoader(originalClassLoader);
            try {
                Files.deleteIfExists(tempOut);
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * 채권/현금 만기현황 (w_ja010p1) 리포트 파일 생성 (rd_ja010p1.mrd)
     */
    public ExportResult generateJa010p1Report(String ymd, String format) throws Exception {
        return generateJa010p1Report(null, ymd, format);
    }

    public ExportResult generateJa010p1Report(String corpGr, String ymd, String format) throws Exception {
        corpGr = resolveCorpGr(corpGr);
        String mrdName = "rd_ja010p1.mrd";
        Path mrdPath = getTemplatePath(mrdName);

        String ymdDot = (ymd != null) ? ymd.replace("-", ".") : "";
        String ymdClean = (ymd != null) ? ymd.replace("-", "").replace(".", "") : "";

        StringBuilder param = new StringBuilder();
        param.append("/rv ");
        if (corpGr != null && !corpGr.isBlank()) param.append("corp_gr[").append(corpGr).append("] ");
        if (!ymdDot.isBlank()) param.append("ymd[").append(ymdDot).append("] ");
        param.append("/rzoom [120] /rmessageboxshow [0]");

        log.info("RD w_ja010p1 리포트 생성 시작 - MRD: {}, Param: {}, Format: {}", mrdName, param, format);

        String normalizedFormat = (format != null) ? format.trim().toLowerCase() : "pdf";
        String ext;
        String contentType;

        switch (normalizedFormat) {
            case "excel":
            case "xlsx":
            case "xls":
                ext = ".xlsx";
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                break;
            case "word":
            case "doc":
            case "docx":
                ext = ".doc";
                contentType = "application/msword";
                break;
            case "ppt":
            case "pptx":
                ext = ".pptx";
                contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                break;
            case "hwp":
                ext = ".hwp";
                contentType = "application/x-hwp";
                break;
            case "pdf":
            default:
                ext = ".pdf";
                contentType = "application/pdf";
                break;
        }

        Path tempOut = Files.createTempFile("rd_export_10p1_", ext);
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
            Object openedObj = fileOpenMethod.invoke(rdCtrl, mrdPath.toAbsolutePath().toString(), param.toString());
            boolean opened = Boolean.TRUE.equals(openedObj);

            if (!opened) {
                Method getErrMsgMethod = rdCtrl.getClass().getMethod("GetLastErrorMessage");
                String errMsg = (String) getErrMsgMethod.invoke(rdCtrl);
                throw new RuntimeException("RD FileOpen 실패: " + errMsg);
            }

            String outFilePath = tempOut.toAbsolutePath().toString();
            String saveMethodName;

            switch (normalizedFormat) {
                case "excel":
                case "xlsx":
                case "xls":
                    saveMethodName = "SaveAsXlsxFile";
                    break;
                case "word":
                case "doc":
                case "docx":
                    saveMethodName = "SaveAsWordFile";
                    break;
                case "ppt":
                case "pptx":
                    saveMethodName = "SaveAsPptxFile";
                    break;
                case "hwp":
                    saveMethodName = "SaveAsHwpFile";
                    break;
                case "pdf":
                default:
                    saveMethodName = "SaveAsPdfFile";
                    break;
            }

            Method saveMethod = rdCtrl.getClass().getMethod(saveMethodName, String.class);
            Object savedObj = saveMethod.invoke(rdCtrl, outFilePath);
            boolean saved = Boolean.TRUE.equals(savedObj);

            if (!saved || !Files.exists(tempOut) || Files.size(tempOut) == 0) {
                throw new RuntimeException("리포트 변환 파일 생성 실패 (" + normalizedFormat + ")");
            }

            byte[] fileBytes = Files.readAllBytes(tempOut);
            String downloadName = ymdClean + "_만기현황" + ext;

            log.info("RD 리포트 생성 성공: {} (크기: {} bytes)", downloadName, fileBytes.length);

            return ExportResult.builder()
                    .data(fileBytes)
                    .filename(downloadName)
                    .contentType(contentType)
                    .build();

        } finally {
            Thread.currentThread().setContextClassLoader(originalClassLoader);
            try {
                Files.deleteIfExists(tempOut);
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * 공모청약 수요예측 참여표(회사) (w_ja010j) 리포트 파일 생성
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

        Path mrdPath = getTemplatePath(mrdName);

        String fymdDot = (fymd != null) ? fymd.replace("-", ".") : "";
        String tymdDot = (tymd != null) ? tymd.replace("-", ".") : "";
        String tymdClean = (tymd != null) ? tymd.replace("-", "").replace(".", "") : "";

        StringBuilder param = new StringBuilder();
        param.append("/rv ");
        if (corpGr != null && !corpGr.isBlank()) param.append("corp_gr[").append(corpGr).append("] ");
        if (title != null && !title.isBlank()) param.append("title[").append(title).append("] ");
        if (!"0".equals(fundCd) && !"1".equals(fundCd) && !"2".equals(fundCd) && fundCd != null && !fundCd.isBlank()) {
            param.append("fund_cd[").append(fundCd).append("] ");
        }
        if (!fymdDot.isBlank()) param.append("fymd[").append(fymdDot).append("] ");
        if (!tymdDot.isBlank()) param.append("tymd[").append(tymdDot).append("] ");
        param.append("/rzoom [120] /rmessageboxshow [0]");

        log.info("RD w_ja010j 리포트 생성 시작 - MRD: {}, Param: {}, Format: {}", mrdName, param, format);

        String normalizedFormat = (format != null) ? format.trim().toLowerCase() : "pdf";
        String ext;
        String contentType;

        switch (normalizedFormat) {
            case "excel":
            case "xlsx":
            case "xls":
                ext = ".xlsx";
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                break;
            case "word":
            case "doc":
            case "docx":
                ext = ".doc";
                contentType = "application/msword";
                break;
            case "ppt":
            case "pptx":
                ext = ".pptx";
                contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                break;
            case "hwp":
                ext = ".hwp";
                contentType = "application/x-hwp";
                break;
            case "pdf":
            default:
                ext = ".pdf";
                contentType = "application/pdf";
                break;
        }

        Path tempOut = Files.createTempFile("rd_export_10j_", ext);
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
            Object openedObj = fileOpenMethod.invoke(rdCtrl, mrdPath.toAbsolutePath().toString(), param.toString());
            boolean opened = Boolean.TRUE.equals(openedObj);

            if (!opened) {
                Method getErrMsgMethod = rdCtrl.getClass().getMethod("GetLastErrorMessage");
                String errMsg = (String) getErrMsgMethod.invoke(rdCtrl);
                throw new RuntimeException("RD FileOpen 실패: " + errMsg);
            }

            String outFilePath = tempOut.toAbsolutePath().toString();
            String saveMethodName;

            switch (normalizedFormat) {
                case "excel":
                case "xlsx":
                case "xls":
                    saveMethodName = "SaveAsXlsxFile";
                    break;
                case "word":
                case "doc":
                case "docx":
                    saveMethodName = "SaveAsWordFile";
                    break;
                case "ppt":
                case "pptx":
                    saveMethodName = "SaveAsPptxFile";
                    break;
                case "hwp":
                    saveMethodName = "SaveAsHwpFile";
                    break;
                case "pdf":
                default:
                    saveMethodName = "SaveAsPdfFile";
                    break;
            }

            Method saveMethod = rdCtrl.getClass().getMethod(saveMethodName, String.class);
            Object savedObj = saveMethod.invoke(rdCtrl, outFilePath);
            boolean saved = Boolean.TRUE.equals(savedObj);

            if (!saved || !Files.exists(tempOut) || Files.size(tempOut) == 0) {
                throw new RuntimeException("리포트 변환 파일 생성 실패 (" + normalizedFormat + ")");
            }

            byte[] fileBytes = Files.readAllBytes(tempOut);
            String downloadName = tymdClean + "_수요예측참여표_" + fundCd + ext;

            log.info("RD 리포트 생성 성공: {} (크기: {} bytes)", downloadName, fileBytes.length);

            return ExportResult.builder()
                    .data(fileBytes)
                    .filename(downloadName)
                    .contentType(contentType)
                    .build();

        } finally {
            Thread.currentThread().setContextClassLoader(originalClassLoader);
            try {
                Files.deleteIfExists(tempOut);
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * 성과보수 상세내역 결산보고서 (w_ja010m3) 리포트 파일 생성
     * mrdName: d_ja010m3.srd의 gs.MRD_NM (예: rd_ja010m31_2202.mrd, rd_ja010m3_2402.mrd 등)
     */
    public ExportResult generateJa010m3Report(String corpGr, String mrdName, String fundCd, String fundNm,
                                             String gyulYmd, String format) throws Exception {
        corpGr = resolveCorpGr(corpGr);
        String targetMrd = (mrdName != null && !mrdName.isBlank()) ? mrdName.trim() : "rd_ja010m3_2402.mrd";
        Path mrdPath = getTemplatePath(targetMrd);

        String gyulYmdDot = (gyulYmd != null) ? gyulYmd.replace("-", ".") : "";
        String gyulYmdClean = (gyulYmd != null) ? gyulYmd.replace("-", "").replace(".", "") : "";

        // 파워빌더 w_ja010m3.srw 명세:
        // uf_fileopen (dw_list.object.mrd_nm [row], 'fund_cd[' + fund_cd + '] gyul_ymd[' + gyul_ymd('yyyy.mm.dd') + ']')
        StringBuilder param = new StringBuilder();
        param.append("/rv ");
        if (fundCd != null && !fundCd.isBlank()) param.append("fund_cd[").append(fundCd).append("] ");
        if (!gyulYmdDot.isBlank()) param.append("gyul_ymd[").append(gyulYmdDot).append("] ");
        if (corpGr != null && !corpGr.isBlank()) param.append("corp_gr[").append(corpGr).append("] ");
        param.append("/rzoom [120] /rmessageboxshow [0]");

        log.info("RD w_ja010m3 리포트 생성 시작 - MRD: {}, Param: {}, Format: {}", targetMrd, param, format);

        String normalizedFormat = (format != null) ? format.trim().toLowerCase() : "pdf";
        String ext;
        String contentType;

        switch (normalizedFormat) {
            case "excel":
            case "xlsx":
            case "xls":
                ext = ".xlsx";
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                break;
            case "word":
            case "doc":
            case "docx":
                ext = ".doc";
                contentType = "application/msword";
                break;
            case "ppt":
            case "pptx":
                ext = ".pptx";
                contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                break;
            case "hwp":
                ext = ".hwp";
                contentType = "application/x-hwp";
                break;
            case "pdf":
            default:
                ext = ".pdf";
                contentType = "application/pdf";
                break;
        }

        URLClassLoader classLoader = getRdClassLoader();
        ClassLoader originalClassLoader = Thread.currentThread().getContextClassLoader();
        Path tempOut = Files.createTempFile("rd_out_", ext);

        try {
            Thread.currentThread().setContextClassLoader(classLoader);
            Class<?> ssrdClass = classLoader.loadClass("m2soft.javard.gui.ServerSideRD");
            Object ssrd = ssrdClass.getDeclaredConstructor().newInstance();

            Method getRdCtrlMethod = ssrdClass.getMethod("getRdControl");
            Object rdCtrl = getRdCtrlMethod.invoke(ssrd);

            Method applyLicMethod = rdCtrl.getClass().getMethod("ApplyLicense", String.class);
            applyLicMethod.invoke(rdCtrl, "0.0.0.0");

            Method fileOpenMethod = rdCtrl.getClass().getMethod("FileOpen", String.class, String.class);
            Object openedObj = fileOpenMethod.invoke(rdCtrl, mrdPath.toAbsolutePath().toString(), param.toString());
            boolean opened = Boolean.TRUE.equals(openedObj);
            if (!opened) {
                throw new IllegalStateException("MRD 파일을 열 수 없습니다: " + mrdPath);
            }

            Thread.sleep(500);

            String outFilePath = tempOut.toAbsolutePath().toString();
            String saveMethodName;

            switch (normalizedFormat) {
                case "excel":
                case "xlsx":
                case "xls":
                    saveMethodName = "SaveAsXlsxFile";
                    break;
                case "word":
                case "doc":
                case "docx":
                    saveMethodName = "SaveAsWordFile";
                    break;
                case "ppt":
                case "pptx":
                    saveMethodName = "SaveAsPptxFile";
                    break;
                case "hwp":
                    saveMethodName = "SaveAsHwpFile";
                    break;
                case "pdf":
                default:
                    saveMethodName = "SaveAsPdfFile";
                    break;
            }

            Method saveMethod = rdCtrl.getClass().getMethod(saveMethodName, String.class);
            Object savedObj = saveMethod.invoke(rdCtrl, outFilePath);
            boolean saved = Boolean.TRUE.equals(savedObj);

            if (!saved || !Files.exists(tempOut) || Files.size(tempOut) == 0) {
                throw new RuntimeException("리포트 변환 파일 생성 실패 (" + normalizedFormat + ")");
            }

            byte[] fileBytes = Files.readAllBytes(tempOut);
            String safeFundNm = (fundNm != null && !fundNm.isBlank())
                    ? fundNm.trim().replaceAll("[\\\\/:*?\"<>|]", "_") : "결산보고서";
            String downloadName = gyulYmdClean + "_" + safeFundNm + "(" + (fundCd != null ? fundCd : "") + ")" + ext;

            log.info("RD w_ja010m3 리포트 생성 성공: {} (크기: {} bytes)", downloadName, fileBytes.length);

            return ExportResult.builder()
                    .data(fileBytes)
                    .filename(downloadName)
                    .contentType(contentType)
                    .build();

        } finally {
            Thread.currentThread().setContextClassLoader(originalClassLoader);
            try {
                Files.deleteIfExists(tempOut);
            } catch (Exception ignored) {
            }
        }
    }
}
