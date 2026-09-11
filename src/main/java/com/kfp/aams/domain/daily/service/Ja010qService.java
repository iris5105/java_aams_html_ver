package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010qDto;
import com.kfp.aams.domain.daily.mapper.Ja010qMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010qService {

    private final Ja010qMapper ja010qMapper;
    private final RdReportService rdReportService;

    public List<Ja010qDto> selectJa010qList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja010qMapper.selectJa010qList(corpGr, ymd);
    }

    public RdReportService.ExportResult generateReport(String fundCd, String fundNm, String ymd,
                                                      String haejiYmd, String afGyulYmd, String bfStart,
                                                      String af, String format) throws Exception {
        // 날짜 결정 로직 (PB ole_rd::ue_retrieve)
        String ldt;
        if (haejiYmd == null || haejiYmd.isBlank()) {
            if (afGyulYmd != null && !afGyulYmd.isBlank() && afGyulYmd.compareTo(ymd) < 0) {
                ldt = afGyulYmd;
            } else {
                ldt = ymd;
            }
        } else {
            ldt = (af != null && !af.isBlank()) ? af : ymd;
        }

        return rdReportService.generateJa010qReport(fundCd, fundNm, ldt, bfStart, ldt, format);
    }
}
