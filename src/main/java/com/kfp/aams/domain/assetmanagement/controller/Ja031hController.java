package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.RdReportService;
import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja031hController {

    private final WorkDateService workDateService;
    private final MenuService menuService;
    private final RdReportService rdReportService;

    @GetMapping({"/views/w_ja031h", "/views/assetmanagement/w_ja031h"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA031H");

        // PB w_ja031h::wue_lastopen:
        // tymd = trunc(idt_workdate, 'mm') - 1 (전월 말일)
        // fymd = add_months(trunc(idt_workdate, 'mm'), -12) (1년 전)
        String[] dates = calculateDefaultDates(workDate);
        String fymd = dates[0];
        String tymd = dates[1];

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fymd", fymd);
        model.addAttribute("tymd", tymd);
        model.addAttribute("pgmNo", menu == null ? "" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA031H" : menu.getFullpgm2());

        return "views/assetmanagement/w_ja031h";
    }

    /**
     * W_JA031H 8종 보고서 단일 엑셀 통합 내보내기 (서식/양식 100% 보존)
     * Crownix RD 엔진이 생성한 완전한 스타일의 8개 XLSX 워크북을 POI를 통해 단일 워크북으로 완벽 병합
     */
    @GetMapping({"/api/assetmanagement/ja031h/export-all-excel", "/api/assetmanagement/ja031h/export-all"})
    @ResponseBody
    public ResponseEntity<byte[]> exportAllExcel(@AuthenticationPrincipal UserPrincipal principal,
                                                 @RequestParam(required = false) String corpGr,
                                                 @RequestParam(required = false) String fymd,
                                                 @RequestParam(required = false) String tymd,
                                                 @RequestParam(required = false, defaultValue = "excel") String format,
                                                 @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        if ("pdf".equalsIgnoreCase(format)) {
            return exportAllPdf(principal, corpGr, fymd, tymd, savedCorpGr);
        }

        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);

        // 일자 정제 (RD 파라미터는 YYYY.MM.DD 형식)
        String cleanFymd = (fymd != null && !fymd.isBlank()) ? fymd.replace("-", ".").replace("/", ".").trim() : "";
        String cleanTymd = (tymd != null && !tymd.isBlank()) ? tymd.replace("-", ".").replace("/", ".").trim() : "";

        if (cleanFymd.replaceAll("[^0-9]", "").length() == 8 && !cleanFymd.contains(".")) {
            cleanFymd = cleanFymd.substring(0, 4) + "." + cleanFymd.substring(4, 6) + "." + cleanFymd.substring(6, 8);
        }
        if (cleanTymd.replaceAll("[^0-9]", "").length() == 8 && !cleanTymd.contains(".")) {
            cleanTymd = cleanTymd.substring(0, 4) + "." + cleanTymd.substring(4, 6) + "." + cleanTymd.substring(6, 8);
        }

        String fymdDigits = cleanFymd.replaceAll("[^0-9]", "");
        String tymdDigits = cleanTymd.replaceAll("[^0-9]", "");
        String downloadFilename = "운용현황(" + fymdDigits + "_" + tymdDigits + ").xlsx";

        String[][] reportDefs = {
                {"rd_ja031h_s1.mrd", "일임수익률", "single"},
                {"rd_ja031h_s2.mrd", "일임재산 설정(운용) 및 해지내역", "range"},
                {"rd_ja031h_s3.mrd", "일임자산 설정 현황", "range"},
                {"rd_ja031h_s4.mrd", "일임계좌 주식 매매거래내역", "range"},
                {"rd_ja031h_s5.mrd", "일임계좌 채권 매매거래내역", "range"},
                {"rd_ja031h_s6.mrd", "일임계좌 CD(CP) 매매거래내역", "range"},
                {"rd_ja031h_s7.mrd", "일임자산 회전율 내역", "range"},
                {"rd_ja031h_s8.mrd", "공모주 취득 및 배정내역", "range"}
        };

        XSSFWorkbook mergedWorkbook = null;

        try {
            for (int i = 0; i < reportDefs.length; i++) {
                String mrd = reportDefs[i][0];
                String title = reportDefs[i][1];
                boolean isSingle = "single".equalsIgnoreCase(reportDefs[i][2]);

                Map<String, Object> params = new LinkedHashMap<>();
                params.put("corp_gr", resolvedCorpGr);
                if (isSingle) {
                    params.put("ymd", cleanTymd);
                } else {
                    params.put("fymd", cleanFymd);
                    params.put("tymd", cleanTymd);
                }

                log.info("[W_JA031H] 단일 엑셀 통합 병합 생성 중 - ({}/8) {} (MRD: {})", (i + 1), title, mrd);
                RdReportService.ExportResult result = rdReportService.generateReport(resolvedCorpGr, mrd, params, "excel", title);
                byte[] xlsxBytes = result.getData();

                if (i == 0) {
                    // 1번째 리포트의 워크북을 베이스로 사용하여 첫 번째 시트명 지정 (100% 원본 서식 보존)
                    mergedWorkbook = new XSSFWorkbook(new ByteArrayInputStream(xlsxBytes));
                    if (mergedWorkbook.getNumberOfSheets() > 0) {
                        mergedWorkbook.setSheetName(0, title);
                    }
                } else {
                    // 2~8번째 리포트는 워크북을 열어 스타일과 함께 시트를 복사
                    try (XSSFWorkbook srcWb = new XSSFWorkbook(new ByteArrayInputStream(xlsxBytes))) {
                        if (srcWb.getNumberOfSheets() > 0) {
                            Sheet srcSheet = srcWb.getSheetAt(0);
                            Sheet destSheet = mergedWorkbook.createSheet(title);
                            copySheetWithStyles(mergedWorkbook, srcSheet, destSheet);
                        }
                    }
                }
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            mergedWorkbook.write(baos);
            mergedWorkbook.close();

            byte[] finalBytes = baos.toByteArray();
            String encodedName = URLEncoder.encode(downloadFilename, StandardCharsets.UTF_8).replace("+", "%20");

            log.info("[W_JA031H] 8종 단일 엑셀 통합 생성 완료: {} (크기: {} bytes)", downloadFilename, finalBytes.length);

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedName + "\"; filename*=UTF-8''" + encodedName)
                    .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                    .body(finalBytes);

        } catch (Exception e) {
            log.error("[W_JA031H] 8종 엑셀 통합 병합 실패: {}", e.getMessage(), e);
            if (mergedWorkbook != null) {
                try { mergedWorkbook.close(); } catch (Exception ignored) {}
            }
            throw new RuntimeException("단일 엑셀 통합 병합 생성 중 오류가 발생했습니다: " + e.getMessage(), e);
        }
    }

    /**
     * W_JA031H 8종 보고서 단일 PDF 통합 내보내기 (서식/양식 100% 보존)
     * Crownix RD 엔진이 생성한 완전한 스타일의 8개 PDF 문서를 PDFBox를 통해 단일 PDF로 완벽 병합
     */
    @GetMapping("/api/assetmanagement/ja031h/export-all-pdf")
    @ResponseBody
    public ResponseEntity<byte[]> exportAllPdf(@AuthenticationPrincipal UserPrincipal principal,
                                               @RequestParam(required = false) String corpGr,
                                               @RequestParam(required = false) String fymd,
                                               @RequestParam(required = false) String tymd,
                                               @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);

        String cleanFymd = (fymd != null && !fymd.isBlank()) ? fymd.replace("-", ".").replace("/", ".").trim() : "";
        String cleanTymd = (tymd != null && !tymd.isBlank()) ? tymd.replace("-", ".").replace("/", ".").trim() : "";

        if (cleanFymd.replaceAll("[^0-9]", "").length() == 8 && !cleanFymd.contains(".")) {
            cleanFymd = cleanFymd.substring(0, 4) + "." + cleanFymd.substring(4, 6) + "." + cleanFymd.substring(6, 8);
        }
        if (cleanTymd.replaceAll("[^0-9]", "").length() == 8 && !cleanTymd.contains(".")) {
            cleanTymd = cleanTymd.substring(0, 4) + "." + cleanTymd.substring(4, 6) + "." + cleanTymd.substring(6, 8);
        }

        String fymdDigits = cleanFymd.replaceAll("[^0-9]", "");
        String tymdDigits = cleanTymd.replaceAll("[^0-9]", "");
        String downloadFilename = "운용현황(" + fymdDigits + "_" + tymdDigits + ").pdf";

        String[][] reportDefs = {
                {"rd_ja031h_s1.mrd", "일임수익률", "single"},
                {"rd_ja031h_s2.mrd", "일임재산 설정(운용) 및 해지내역", "range"},
                {"rd_ja031h_s3.mrd", "일임자산 설정 현황", "range"},
                {"rd_ja031h_s4.mrd", "일임계좌 주식 매매거래내역", "range"},
                {"rd_ja031h_s5.mrd", "일임계좌 채권 매매거래내역", "range"},
                {"rd_ja031h_s6.mrd", "일임계좌 CD(CP) 매매거래내역", "range"},
                {"rd_ja031h_s7.mrd", "일임자산 회전율 내역", "range"},
                {"rd_ja031h_s8.mrd", "공모주 취득 및 배정내역", "range"}
        };

        try {
            org.apache.pdfbox.multipdf.PDFMergerUtility pdfMerger = new org.apache.pdfbox.multipdf.PDFMergerUtility();

            for (int i = 0; i < reportDefs.length; i++) {
                String mrd = reportDefs[i][0];
                String title = reportDefs[i][1];
                boolean isSingle = "single".equalsIgnoreCase(reportDefs[i][2]);

                Map<String, Object> params = new LinkedHashMap<>();
                params.put("corp_gr", resolvedCorpGr);
                if (isSingle) {
                    params.put("ymd", cleanTymd);
                } else {
                    params.put("fymd", cleanFymd);
                    params.put("tymd", cleanTymd);
                }

                log.info("[W_JA031H] 단일 PDF 통합 병합 생성 중 - ({}/8) {} (MRD: {})", (i + 1), title, mrd);
                RdReportService.ExportResult result = rdReportService.generateReport(resolvedCorpGr, mrd, params, "pdf", title);
                pdfMerger.addSource(new ByteArrayInputStream(result.getData()));
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            pdfMerger.setDestinationStream(baos);
            pdfMerger.mergeDocuments(null);

            byte[] finalBytes = baos.toByteArray();
            String encodedName = URLEncoder.encode(downloadFilename, StandardCharsets.UTF_8).replace("+", "%20");

            log.info("[W_JA031H] 8종 단일 PDF 통합 생성 완료: {} (크기: {} bytes)", downloadFilename, finalBytes.length);

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedName + "\"; filename*=UTF-8''" + encodedName)
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(finalBytes);

        } catch (Exception e) {
            log.error("[W_JA031H] 8종 PDF 통합 병합 실패: {}", e.getMessage(), e);
            throw new RuntimeException("단일 PDF 통합 병합 생성 중 오류가 발생했습니다: " + e.getMessage(), e);
        }
    }

    private void copySheetWithStyles(XSSFWorkbook targetWb, Sheet srcSheet, Sheet destSheet) {
        Map<Short, CellStyle> styleMap = new HashMap<>();

        // 컬럼 너비 복사 (최대 60개 컬럼)
        for (int c = 0; c <= 60; c++) {
            int w = srcSheet.getColumnWidth(c);
            if (w != srcSheet.getDefaultColumnWidth() * 256) {
                destSheet.setColumnWidth(c, w);
            }
        }
        destSheet.setDefaultColumnWidth(srcSheet.getDefaultColumnWidth());
        destSheet.setDefaultRowHeight(srcSheet.getDefaultRowHeight());
        destSheet.setDisplayGridlines(srcSheet.isDisplayGridlines());

        // 행 및 셀 복사 (스타일, 폰트, 포맷, 값 보존)
        for (int r = 0; r <= srcSheet.getLastRowNum(); r++) {
            Row srcRow = srcSheet.getRow(r);
            if (srcRow == null) continue;
            Row destRow = destSheet.createRow(r);
            destRow.setHeight(srcRow.getHeight());

            for (int c = 0; c < srcRow.getLastCellNum(); c++) {
                Cell srcCell = srcRow.getCell(c);
                if (srcCell == null) continue;
                Cell destCell = destRow.createCell(c);

                CellStyle srcStyle = srcCell.getCellStyle();
                if (srcStyle != null) {
                    short idx = srcStyle.getIndex();
                    CellStyle destStyle = styleMap.get(idx);
                    if (destStyle == null) {
                        destStyle = targetWb.createCellStyle();
                        destStyle.cloneStyleFrom(srcStyle);
                        styleMap.put(idx, destStyle);
                    }
                    destCell.setCellStyle(destStyle);
                }

                switch (srcCell.getCellType()) {
                    case Cell.CELL_TYPE_STRING:
                        destCell.setCellValue(srcCell.getStringCellValue());
                        break;
                    case Cell.CELL_TYPE_NUMERIC:
                        destCell.setCellValue(srcCell.getNumericCellValue());
                        break;
                    case Cell.CELL_TYPE_BOOLEAN:
                        destCell.setCellValue(srcCell.getBooleanCellValue());
                        break;
                    case Cell.CELL_TYPE_FORMULA:
                        destCell.setCellFormula(srcCell.getCellFormula());
                        break;
                    case Cell.CELL_TYPE_BLANK:
                        destCell.setCellType(Cell.CELL_TYPE_BLANK);
                        break;
                    default:
                        break;
                }
            }
        }

        // 병합 영역 복사
        for (int i = 0; i < srcSheet.getNumMergedRegions(); i++) {
            CellRangeAddress range = srcSheet.getMergedRegion(i);
            destSheet.addMergedRegion(range);
        }
    }

    private String[] calculateDefaultDates(String dateStr) {
        if (dateStr == null || dateStr.isBlank()) {
            return new String[]{"", ""};
        }
        try {
            String digits = dateStr.replaceAll("[^0-9]", "").trim();
            LocalDate baseDate;
            if (digits.length() == 8) {
                baseDate = LocalDate.parse(digits, DateTimeFormatter.ofPattern("yyyyMMdd"));
            } else {
                baseDate = LocalDate.parse(dateStr.replace(".", "-").trim(), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            }
            LocalDate firstDayOfCurrentMonth = baseDate.withDayOfMonth(1);
            LocalDate tymdDate = firstDayOfCurrentMonth.minusDays(1);
            LocalDate fymdDate = tymdDate.minusYears(1).withDayOfMonth(1);

            return new String[]{
                    fymdDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")),
                    tymdDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))
            };
        } catch (Exception e) {
            log.warn("[Ja031hController] calculateDefaultDates parse error: {}", dateStr);
            return new String[]{dateStr, dateStr};
        }
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }
}

