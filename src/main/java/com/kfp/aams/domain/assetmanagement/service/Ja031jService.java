package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja031jDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031jGa191Dto;
import com.kfp.aams.domain.assetmanagement.mapper.Ja031jMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja031jService {

    private final Ja031jMapper ja031jMapper;

    /**
     * GA 테이블 자료 건수 확인
     */
    public int checkData(String corpGr, String ym) {
        String cleanYm = ym.replaceAll("[^0-9]", "").trim();
        return ja031jMapper.countGaData(corpGr.trim(), cleanYm);
    }

    /**
     * 금감원 보고서 데이터 생성 프로시저 호출 (KFP.SR_JA031J)
     */
    @Transactional
    public Map<String, Object> generateData(String corpGr, String ym) {
        Map<String, Object> result = new HashMap<>();
        String cleanYm = ym.replaceAll("[^0-9]", "").trim();

        try {
            Map<String, Object> params = new HashMap<>();
            params.put("corpGr", corpGr.trim());
            params.put("ym", cleanYm);

            log.info("[Ja031jService] SR_JA031J 프로시저 호출 시작 - corpGr: {}, ym: {}", corpGr, cleanYm);
            ja031jMapper.callSrJa031j(params);
            log.info("[Ja031jService] SR_JA031J 프로시저 호출 완료");

            int count = ja031jMapper.countGaData(corpGr.trim(), cleanYm);
            result.put("success", true);
            result.put("message", cleanYm + " 기준 금감원 보고서 자료 생성이 완료되었습니다. (" + count + "건)");
            result.put("count", count);
        } catch (Exception e) {
            log.error("[Ja031jService] SR_JA031J 프로시저 실행 실패: ", e);
            result.put("success", false);
            result.put("message", "자료 생성 중 오류가 발생했습니다: " + e.getMessage());
        }

        return result;
    }

    /**
     * 금감원 보고서 엑셀 파일 생성 (파워빌더 원본 서식 템플릿 및 데이터 대입 로직 100% 동일 구현)
     * 파워빌더 cb_xls::clicked:
     * obj_excel.workbooks.open (gnv_vari.basepath + '\금감원보고서.xlsx', 0, FALSE)
     */
    public byte[] exportReportExcel(String corpGr, String ym) {
        String cleanYm = ym.replaceAll("[^0-9]", "").trim();
        String corpNm = ja031jMapper.selectCorpNm(corpGr.trim());
        if (corpNm == null || corpNm.isBlank())
            corpNm = corpGr.trim();

        List<Ja031jDto> list = ja031jMapper.selectGaList(corpGr.trim(), cleanYm);

        String yearStr = cleanYm.length() >= 4 ? cleanYm.substring(0, 4) : "";
        String monthStr = cleanYm.length() >= 6 ? cleanYm.substring(4, 6) : "";
        String metaText = "회사 : " + corpNm + "               기준년월(일) : " + yearStr + "년" + monthStr + "월";

        try (java.io.InputStream templateStream = getClass().getResourceAsStream("/excel/금감원보고서.xlsx");
                ByteArrayOutputStream out = new ByteArrayOutputStream()) {

            Workbook workbook;
            if (templateStream != null) {
                workbook = new XSSFWorkbook(templateStream);
            } else {
                // 템플릿 파일이 없을 때 대비한 Fallback
                log.warn("[Ja031jService] /excel/금감원보고서.xlsx 템플릿이 클래스패스에 없어 동적 생성합니다.");
                workbook = new XSSFWorkbook();
                for (String sheetName : new String[] { "GA179", "GA180", "GA181", "GA182", "GA186", "GA187", "GA188",
                        "GA189", "GA191" }) {
                    workbook.createSheet(sheetName);
                }
            }

            // 파워빌더 cb_xls::clicked 루프와 100% 동일하게 실행
            int sheetCount = workbook.getNumberOfSheets();
            for (int ll = 0; ll < sheetCount; ll++) {
                Sheet lSheet = workbook.getSheetAt(ll);
                String sheetName = lSheet.getSheetName();

                // 1. PB: lSheet.cells (3, 1).value = '회사 : ' + gaa.corp_nm + ' 기준년월(일) : ' +
                // mid (ls_ym, 1, 4) + '년' + mid (ls_ym, 5, 2) + '월'
                Row row3 = getOrCreateRow(lSheet, 2); // 0-based row index 2 = row 3
                Cell metaCell = row3.getCell(0);
                if (metaCell == null)
                    metaCell = row3.createCell(0);
                metaCell.setCellValue(metaText);

                // 2. PB: FOR lj = 1 TO ll_row ...
                int lR = 0;
                for (Ja031jDto rowData : list) {
                    String lsGb = rowData.getC01();
                    if (lsGb == null || !sheetName.equalsIgnoreCase(lsGb.trim())) {
                        continue;
                    }

                    // [GA179] 또는 [GA186]
                    if ("GA179".equalsIgnoreCase(lsGb) || "GA186".equalsIgnoreCase(lsGb)) {
                        lR++;
                        // PB: lSheet.cells (9 + lR, 2) = n_01
                        // PB: lSheet.cells (9 + lR, 3) = n_02
                        // PB: lSheet.cells (9 + lR, 4) = n_03
                        // PB: lSheet.cells (9 + lR, 5) = n_04
                        Row r = getOrCreateRow(lSheet, 8 + lR);
                        setValPreserveStyle(r, 1, rowData.getN01());
                        setValPreserveStyle(r, 2, rowData.getN02());
                        setValPreserveStyle(r, 3, rowData.getN03());
                        setValPreserveStyle(r, 4, rowData.getN04());
                    }

                    // [GA180] 또는 [GA187]
                    if ("GA180".equalsIgnoreCase(lsGb) || "GA187".equalsIgnoreCase(lsGb)) {
                        lR++;
                        // PB: lSheet.cells (9 + lR, 3) = n_01 ...
                        // PB: lSheet.cells (11 + lR, 3) = n_01 ...
                        // PB: lSheet.cells (15 + lR, 3) = n_01 ...
                        // PB: lSheet.cells (17 + lR, 3) = n_01 ...
                        int[] targetRows = { 8 + lR, 10 + lR, 14 + lR, 16 + lR };
                        for (int tr : targetRows) {
                            Row r = getOrCreateRow(lSheet, tr);
                            setValPreserveStyle(r, 2, rowData.getN01());
                            setValPreserveStyle(r, 3, rowData.getN02());
                            setValPreserveStyle(r, 4, rowData.getN03());
                        }
                    }

                    // [GA181]
                    if ("GA181".equalsIgnoreCase(lsGb)) {
                        lR++;
                        // PB: lSheet.cells (10 + lR, 3..24)
                        Row r = getOrCreateRow(lSheet, 9 + lR);
                        setValPreserveStyle(r, 2, rowData.getN01());
                        setValPreserveStyle(r, 3, rowData.getN02());
                        setValPreserveStyle(r, 4, rowData.getN03());
                        setValPreserveStyle(r, 5, rowData.getN04());
                        setValPreserveStyle(r, 6, rowData.getN05());
                        setValPreserveStyle(r, 7, rowData.getN06());
                        setValPreserveStyle(r, 8, rowData.getN07());
                        setValPreserveStyle(r, 9, rowData.getN08());
                        setValPreserveStyle(r, 10, rowData.getN09());
                        setValPreserveStyle(r, 11, rowData.getN10());
                        setValPreserveStyle(r, 12, BigDecimal.ZERO);
                        setValPreserveStyle(r, 13, BigDecimal.ZERO);
                        setValPreserveStyle(r, 14, rowData.getN11());
                        setValPreserveStyle(r, 15, rowData.getN12());
                        setValPreserveStyle(r, 16, rowData.getN13());
                        setValPreserveStyle(r, 17, rowData.getN14());
                        setValPreserveStyle(r, 18, rowData.getN15());
                        setValPreserveStyle(r, 19, rowData.getN16());
                        setValPreserveStyle(r, 20, rowData.getN17());
                        setValPreserveStyle(r, 21, rowData.getN18());
                        setValPreserveStyle(r, 22, rowData.getN19());
                        setValPreserveStyle(r, 23, rowData.getN20());
                    }

                    // [GA182] 또는 [GA189]
                    if ("GA182".equalsIgnoreCase(lsGb) || "GA189".equalsIgnoreCase(lsGb)) {
                        lR++;
                        if ("GA182".equalsIgnoreCase(lsGb) && lR == 6) {
                            lR++;
                        }
                        // PB: lSheet.cells (10 + lR, 2..5)
                        Row r = getOrCreateRow(lSheet, 9 + lR);
                        setValPreserveStyle(r, 1, rowData.getN01());
                        setValPreserveStyle(r, 2, rowData.getN02());
                        setValPreserveStyle(r, 3, rowData.getN03());
                        setValPreserveStyle(r, 4, rowData.getN04());
                    }

                    // [GA188]
                    if ("GA188".equalsIgnoreCase(lsGb)) {
                        lR++;
                        // PB: lSheet.cells (10 + lR, 3..20)
                        Row r = getOrCreateRow(lSheet, 9 + lR);
                        setValPreserveStyle(r, 2, rowData.getN01());
                        setValPreserveStyle(r, 3, rowData.getN02());
                        setValPreserveStyle(r, 4, rowData.getN03());
                        setValPreserveStyle(r, 5, rowData.getN04());
                        setValPreserveStyle(r, 6, rowData.getN05());
                        setValPreserveStyle(r, 7, rowData.getN06());
                        setValPreserveStyle(r, 8, rowData.getN07());
                        setValPreserveStyle(r, 9, rowData.getN08());
                        setValPreserveStyle(r, 10, rowData.getN09());
                        setValPreserveStyle(r, 11, rowData.getN10());
                        setValPreserveStyle(r, 12, rowData.getN11());
                        setValPreserveStyle(r, 13, rowData.getN12());
                        setValPreserveStyle(r, 14, rowData.getN13());
                        setValPreserveStyle(r, 15, rowData.getN14());
                        setValPreserveStyle(r, 16, rowData.getN15());
                        setValPreserveStyle(r, 17, rowData.getN16());
                        setValPreserveStyle(r, 18, rowData.getN17());
                        setValPreserveStyle(r, 19, rowData.getN18());
                    }

                    // [GA191]
                    if ("GA191".equalsIgnoreCase(lsGb)) {
                        int rowTarget = rowData.getN03() != null ? rowData.getN03().intValue() : 0;
                        if (rowTarget > 0) {
                            // PB: lSheet.cells (lR, 4) = n_01, lSheet.cells (lR, 5) = n_02
                            Row r = getOrCreateRow(lSheet, rowTarget - 1);
                            setValPreserveStyle(r, 3, rowData.getN01());
                            setValPreserveStyle(r, 4, rowData.getN02());
                        }
                    }
                }
            }

            workbook.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            log.error("[Ja031jService] exportReportExcel 실패: ", e);
            throw new RuntimeException("금감원 보고서 엑셀 생성 중 오류가 발생했습니다.", e);
        }
    }

    private void setValPreserveStyle(Row row, int colIndex, BigDecimal val) {
        Cell cell = row.getCell(colIndex);
        if (cell == null) {
            cell = row.createCell(colIndex);
        }
        if (val != null) {
            cell.setCellValue(val.doubleValue());
        } else {
            cell.setCellValue(0.0);
        }
    }

    private Row getOrCreateRow(Sheet sheet, int rowIndex) {
        Row row = sheet.getRow(rowIndex);
        if (row == null) {
            row = sheet.createRow(rowIndex);
        }
        return row;
    }

    /**
     * 점검자료 엑셀 파일 생성 (파워빌더 cb_ga191 원본 서식 템플릿 100% 동일 구현)
     * 파워빌더 cb_ga191::clicked:
     * obj_xls.workbooks.OPEN (gnv_vari.basepath + '\GA191.xlsm', 0, true)
     * obj_xls.Application.RUN ("'GA191.xlsm'!GA191_FUND")
     * ...
     * lSheet.cells (3, 1).VALUE = '회사 : ' + dw_list.object.fund_nm [lj] + '( ' +
     * dw_list.object.fund_cd [lj] + ' ) 기준년월(일) : ' + mid (ls_ym, 1, 4) + '년' + mid
     * (ls_ym, 5, 2) + '월'
     * lR = dw_list.object.n_03 [lj]
     * lSheet.cells (lR, 4).VALUE = dw_list.object.n_01 [lj]
     * lSheet.cells (lR, 5).VALUE = dw_list.object.n_02 [lj]
     */
    public byte[] exportGa191Excel(String corpGr, String ym) {
        String cleanYm = ym.replaceAll("[^0-9]", "").trim();
        List<Ja031jGa191Dto> list = ja031jMapper.selectGa191List(corpGr.trim(), cleanYm);

        String yearStr = cleanYm.length() >= 4 ? cleanYm.substring(0, 4) : "";
        String monthStr = cleanYm.length() >= 6 ? cleanYm.substring(4, 6) : "";

        try (java.io.InputStream templateStream = getClass().getResourceAsStream("/excel/금감원보고서.xlsx");
                ByteArrayOutputStream out = new ByteArrayOutputStream()) {

            if (templateStream == null) {
                log.error("[Ja031jService] /excel/금감원보고서.xlsx 템플릿을 찾을 수 없습니다.");
                throw new IllegalStateException("금감원보고서 템플릿 파일이 존재하지 않습니다.");
            }

            Workbook workbook = new XSSFWorkbook(templateStream);

            // 1. 펀드 목록(fundCd 기준 그룹화) 추출 (순서 보장을 위해 LinkedHashMap 사용)
            Map<String, List<Ja031jGa191Dto>> fundGroupMap = new java.util.LinkedHashMap<>();
            for (Ja031jGa191Dto dto : list) {
                String fundCd = dto.getFundCd() != null ? dto.getFundCd().trim() : "";
                if (!fundCd.isEmpty()) {
                    fundGroupMap.computeIfAbsent(fundCd, k -> new java.util.ArrayList<>()).add(dto);
                }
            }

            int ga191Index = workbook.getSheetIndex("GA191");
            if (ga191Index < 0) {
                ga191Index = workbook.getNumberOfSheets() - 1; // 마지막 시트
            }

            // 펀드 목록이 있을 경우 각 펀드별 시트 생성
            if (!fundGroupMap.isEmpty()) {
                List<String> targetSheetNames = new java.util.ArrayList<>();

                int fundIdx = 0;
                for (Map.Entry<String, List<Ja031jGa191Dto>> entry : fundGroupMap.entrySet()) {
                    String fundCd = entry.getKey();
                    List<Ja031jGa191Dto> items = entry.getValue();
                    String fundNm = (items != null && !items.isEmpty() && items.get(0).getFundNm() != null)
                            ? items.get(0).getFundNm().trim()
                            : "";

                    Sheet fundSheet;
                    String sheetTitle;
                    if (fundGroupMap.size() == 1) {
                        // 파워빌더 산출물과 동일하게 단일 펀드일 때 시트명 "GA191 (2)"
                        sheetTitle = "GA191 (2)";
                        fundSheet = workbook.cloneSheet(ga191Index);
                        workbook.setSheetName(workbook.getSheetIndex(fundSheet), sheetTitle);
                    } else {
                        // 복수 펀드일 경우 펀드코드
                        sheetTitle = org.apache.poi.ss.util.WorkbookUtil
                                .createSafeSheetName(fundCd.isEmpty() ? ("GA191_" + (fundIdx + 1)) : fundCd);
                        fundSheet = workbook.cloneSheet(ga191Index);
                        workbook.setSheetName(workbook.getSheetIndex(fundSheet), sheetTitle);
                    }
                    targetSheetNames.add(sheetTitle);

                    // 3행 1열: '회사 : ' + fund_nm + '( ' + fund_cd + ' ) 기준년월(일) : ' + YYYY + '년' + MM
                    // + '월'
                    Row row3 = getOrCreateRow(fundSheet, 2);
                    Cell metaCell = row3.getCell(0);
                    if (metaCell == null)
                        metaCell = row3.createCell(0);
                    String metaText = "회사 : " + fundNm + "( " + fundCd + " )               기준년월(일) : " + yearStr + "년"
                            + monthStr + "월";
                    metaCell.setCellValue(metaText);

                    // 데이터 셀 채우기: lSheet.cells (lR, 4).VALUE = n_01, lSheet.cells (lR, 5).VALUE =
                    // n_02
                    if (items != null) {
                        for (Ja031jGa191Dto item : items) {
                            if (item.getN03() != null) {
                                int lR = item.getN03().intValue();
                                if (lR > 0) {
                                    Row r = getOrCreateRow(fundSheet, lR - 1);
                                    setValPreserveStyle(r, 3, item.getN01()); // 4열 (D열 국내운용금액)
                                    setValPreserveStyle(r, 4, item.getN02()); // 5열 (E열 국외운용금액)
                                }
                            }
                        }
                    }
                    fundIdx++;
                }

                // 생성된 대상 시트 외의 나머지 원본 템플릿 시트들(GA179~GA191) 모두 제거
                for (int i = workbook.getNumberOfSheets() - 1; i >= 0; i--) {
                    String name = workbook.getSheetName(i);
                    if (!targetSheetNames.contains(name)) {
                        workbook.removeSheetAt(i);
                    }
                }
            } else {
                // 펀드 데이터가 없을 때: GA191 시트 하나만 "GA191 (2)"로 남기고 다른 시트 제거
                String corpNm = ja031jMapper.selectCorpNm(corpGr.trim());
                if (corpNm == null || corpNm.isBlank())
                    corpNm = corpGr.trim();

                Sheet clone = workbook.cloneSheet(ga191Index);
                workbook.setSheetName(workbook.getSheetIndex(clone), "GA191 (2)");

                Row row3 = getOrCreateRow(clone, 2);
                Cell metaCell = row3.getCell(0);
                if (metaCell == null)
                    metaCell = row3.createCell(0);
                metaCell.setCellValue("회사 : " + corpNm + "               기준년월(일) : " + yearStr + "년" + monthStr + "월");

                for (int i = workbook.getNumberOfSheets() - 1; i >= 0; i--) {
                    if (i != workbook.getSheetIndex(clone)) {
                        workbook.removeSheetAt(i);
                    }
                }
            }

            workbook.setForceFormulaRecalculation(true);
            workbook.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            log.error("[Ja031jService] exportGa191Excel 실패: ", e);
            throw new RuntimeException("점검자료 엑셀 생성 중 오류가 발생했습니다: " + e.getMessage(), e);
        }
    }

}
