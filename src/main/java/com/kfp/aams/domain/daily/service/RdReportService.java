package com.kfp.aams.domain.daily.service;

import lombok.Builder;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.*;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
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
        if (!resource.exists()) {
            throw new FileNotFoundException("리포트 템플릿 파일을 찾을 수 없습니다: classpath:rd/" + mrdFileName);
        }

        Path tempDir = Path.of(System.getProperty("java.io.tmpdir"), "aams_rd_templates");
        if (!Files.exists(tempDir)) {
            Files.createDirectories(tempDir);
        }

        Path target = tempDir.resolve(mrdFileName);
        try (InputStream in = resource.getInputStream()) {
            Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
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
        param.append("/rmessageboxshow [0]");

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
}
