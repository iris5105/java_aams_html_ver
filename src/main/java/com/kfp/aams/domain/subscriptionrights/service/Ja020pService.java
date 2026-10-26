package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.RdReportService;
import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.dailyadvisory.dto.Szx0seDto;
import com.kfp.aams.domain.dailyadvisory.service.Szx0seService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

/**
 * W_JA020P (채권비율보고) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja020pService {

    private final WorkDateService workDateService;
    private final Szx0seService szx0seService;
    private final RdReportService rdReportService;

    /**
     * DB 기준 영업일자 조회 (SZX0AA.HYUN_YMD)
     */
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * DB 기준 전영업일자 조회 (SZX0AA.JUNYONG_YMD 또는 idt_workdate - 1)
     */
    public String getJunyongDate(String corpGr) {
        return workDateService.getJunyongDateOrDefault(corpGr);
    }

    /**
     * 계좌관리그룹 안내 문자열 조회 (파워빌더 w_ja020p.srw wue_lastopen 명세)
     * SELECT LISTAGG (SERIES_GB || '-' || SERIES_NM, ', ') FROM SZX0SE WHERE corp_gr = :corpGr AND dp_used = '1' ORDER BY SERIES_GB
     */
    public String getSeriesGroupInfo(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return "";
        }
        try {
            List<Szx0seDto> list = szx0seService.getSzx0seList(corpGr.trim());
            if (list == null || list.isEmpty()) {
                return "";
            }
            return list.stream()
                    .filter(dto -> "1".equals(dto.getDpUsed()))
                    .sorted(Comparator.comparing(dto -> dto.getSeriesGb() != null ? dto.getSeriesGb() : ""))
                    .map(dto -> (dto.getSeriesGb() != null ? dto.getSeriesGb().trim() : "") + "-" +
                            (dto.getSeriesNm() != null ? dto.getSeriesNm().trim() : ""))
                    .collect(Collectors.joining(", "));
        } catch (Exception e) {
            log.error("[Ja020pService] 계좌관리그룹 조회 오류: corpGr={}, msg={}", corpGr, e.getMessage());
            return "";
        }
    }

    /**
     * rd_ja020p.mrd 리포트 생성
     */
    public RdReportService.ExportResult generateReport(String corpGr, String ymd, String format, String downloadName) throws Exception {
        Map<String, Object> params = new LinkedHashMap<>();
        // 파워빌더: 'ymd[' + string (dw_c.object.ymd [1],'yyyy.mm.dd') + ']'
        String formattedYmd = (ymd != null) ? ymd.replace("-", ".").trim() : "";
        params.put("ymd", formattedYmd);

        return rdReportService.generateReport(corpGr, "rd_ja020p.mrd", params, format, downloadName);
    }
}
