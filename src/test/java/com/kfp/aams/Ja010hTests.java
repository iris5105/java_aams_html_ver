package com.kfp.aams;

import com.kfp.aams.domain.daily.dto.Ja010hMasterDto;
import com.kfp.aams.domain.daily.service.Ja010hService;
import com.kfp.aams.domain.daily.service.RdReportService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class Ja010hTests {

    @Autowired
    private Ja010hService ja010hService;

    @Test
    @DisplayName("가이드라인 1: corpGr 또는 ymd 누락 시 빈 리스트 반환 (기본값 하드코딩 금지)")
    void testGuideline1NoDefaults() {
        List<Ja010hMasterDto> list1 = ja010hService.getFundList(null, null);
        assertThat(list1).isEmpty();

        List<Ja010hMasterDto> list2 = ja010hService.getFundList("2402", null);
        assertThat(list2).isEmpty();

        List<Ja010hMasterDto> list3 = ja010hService.getFundList(null, "2026-06-08");
        assertThat(list3).isEmpty();
    }

    @Test
    @DisplayName("가이드라인 4: d_szm0ia 펀드 목록 MyBatis 조회 테스트")
    void testSelectFundList() {
        List<Ja010hMasterDto> list = ja010hService.getFundList("2402", "2026-06-08");
        assertThat(list).isNotNull();
        System.out.println("조회된 펀드 건수: " + list.size());
        if (!list.isEmpty()) {
            Ja010hMasterDto first = list.get(0);
            System.out.println("첫번째 펀드: " + first.getFundNm() + " (" + first.getFundCd() + ")");
            assertThat(first.getFundCd()).isNotBlank();
        }
    }

    @Test
    @DisplayName("캘린더 데이터 일자 목록 조회 테스트")
    void testGetDates() {
        List<String> dates = ja010hService.getDates("2402");
        assertThat(dates).isNotNull();
        System.out.println("조회 가능 일자 수: " + dates.size());
    }

    @Test
    @DisplayName("자산명세표 다중 포맷(PDF, Excel, Word, PPT, HWP) 변환 생성 검증")
    void testReportExportAllFormats() throws Exception {
        String corpGr = "2402";
        String ymd = "2026-06-08";
        String fundCd = "2601";

        // 1. PDF
        RdReportService.ExportResult pdfRes = ja010hService.exportReport(corpGr, ymd, fundCd, "pdf");
        assertThat(pdfRes).isNotNull();
        assertThat(pdfRes.getData()).isNotEmpty();
        assertThat(pdfRes.getContentType()).isEqualTo("application/pdf");
        System.out.println("PDF 생성 완료: " + pdfRes.getFilename() + " (" + pdfRes.getData().length + " bytes)");

        // 2. Excel (XLSX)
        RdReportService.ExportResult xlsxRes = ja010hService.exportReport(corpGr, ymd, fundCd, "xlsx");
        assertThat(xlsxRes).isNotNull();
        assertThat(xlsxRes.getData()).isNotEmpty();
        assertThat(xlsxRes.getContentType()).contains("spreadsheetml");
        System.out.println("Excel 생성 완료: " + xlsxRes.getFilename() + " (" + xlsxRes.getData().length + " bytes)");

        // 3. Word (DOC)
        RdReportService.ExportResult wordRes = ja010hService.exportReport(corpGr, ymd, fundCd, "doc");
        assertThat(wordRes).isNotNull();
        assertThat(wordRes.getData()).isNotEmpty();
        assertThat(wordRes.getContentType()).isEqualTo("application/msword");
        System.out.println("Word 생성 완료: " + wordRes.getFilename() + " (" + wordRes.getData().length + " bytes)");

        // 4. PPT (PPTX)
        RdReportService.ExportResult pptRes = ja010hService.exportReport(corpGr, ymd, fundCd, "pptx");
        assertThat(pptRes).isNotNull();
        assertThat(pptRes.getData()).isNotEmpty();
        assertThat(pptRes.getContentType()).contains("presentationml");
        System.out.println("PPT 생성 완료: " + pptRes.getFilename() + " (" + pptRes.getData().length + " bytes)");

        // 5. HWP
        RdReportService.ExportResult hwpRes = ja010hService.exportReport(corpGr, ymd, fundCd, "hwp");
        assertThat(hwpRes).isNotNull();
        assertThat(hwpRes.getData()).isNotEmpty();
        assertThat(hwpRes.getContentType()).isEqualTo("application/x-hwp");
        System.out.println("HWP 생성 완료: " + hwpRes.getFilename() + " (" + hwpRes.getData().length + " bytes)");
    }
}
