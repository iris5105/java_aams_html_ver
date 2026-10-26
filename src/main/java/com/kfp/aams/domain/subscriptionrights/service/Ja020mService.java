package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.RdReportService;
import com.kfp.aams.common.service.WorkDateService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * W_JA020M (금투협보고자료) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja020mService {

    private final WorkDateService workDateService;
    private final RdReportService rdReportService;

    /**
     * DB 기준 영업일자 조회 (SZX0AA.HYUN_YMD)
     */
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 파워빌더 w_ja020m.srw wue_lastopen 명세:
     * SELECT trunc(:idt_workdate, 'mm') - 1 FROM DUAL;
     * 영업일자가 속한 달의 직전월 (YYYY-MM 형식 반환)
     */
    public String getInitialYm(String corpGr) {
        String workDate = getWorkDate(corpGr);
        try {
            LocalDate date = LocalDate.parse(workDate);
            LocalDate prevMonthEnd = date.withDayOfMonth(1).minusDays(1);
            return prevMonthEnd.format(DateTimeFormatter.ofPattern("yyyy-MM"));
        } catch (Exception e) {
            log.warn("[Ja020mService] 기준일자 파싱 오류(기본값 사용): workDate={}, err={}", workDate, e.getMessage());
            return LocalDate.now().minusMonths(1).format(DateTimeFormatter.ofPattern("yyyy-MM"));
        }
    }

    /**
     * 금투협보고자료 MRD 리포트 생성
     * 파워빌더 ue_retrieve 명세:
     * IF dw_c.object.ym [1] >= '202506' then
     *     ole_rd.uf_fileopen ('rd_ja020m_202506.mrd', 'ym[' + dw_c.object.ym [1] + ']')
     * Else
     *     ole_rd.uf_fileopen ('rd_ja020m.mrd', 'ym[' + dw_c.object.ym [1] + ']')
     * End IF
     */
    public RdReportService.ExportResult generateReport(String corpGr, String ym, String format, String downloadName) throws Exception {
        String cleanYm = (ym != null) ? ym.replaceAll("[^0-9]", "") : "";
        if (cleanYm.length() > 6) {
            cleanYm = cleanYm.substring(0, 6);
        }

        // 파워빌더 서식 분기: 2025년 6월 이후는 rd_ja020m_202506.mrd 사용
        String mrdName = (cleanYm.compareTo("202506") >= 0)
                ? "rd_ja020m_202506.mrd"
                : "rd_ja020m.mrd";

        Map<String, Object> params = new LinkedHashMap<>();
        params.put("ym", cleanYm);

        return rdReportService.generateReport(corpGr, mrdName, params, format, downloadName);
    }
}
