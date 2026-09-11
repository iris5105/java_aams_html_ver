package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010jDto;
import com.kfp.aams.domain.daily.mapper.Ja010jMapper;
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
public class Ja010jService {

    private final Ja010jMapper ja010jMapper;
    private final RdReportService rdReportService;

    public List<Ja010jDto> selectJa010jList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja010jMapper.selectJa010jList(corpGr, ymd);
    }

    public RdReportService.ExportResult generateReport(String corpGr, String fundCd, String companyName,
                                                      String fundNm, String fymd, String tymd, String format) throws Exception {
        String title;
        if ("0".equals(fundCd)) {
            title = companyName + " 3개월 평잔현황";
        } else if ("1".equals(fundCd) || "2".equals(fundCd)) {
            title = (fundNm != null && !fundNm.isBlank()) ? fundNm + " 3개월 평잔현황" : companyName + " 3개월 평잔현황";
        } else {
            title = (fundNm != null && !fundNm.isBlank()) ? fundNm + " 3개월 평잔현황" : "3개월 평잔현황";
        }

        return rdReportService.generateJa010jReport(corpGr, fundCd, title, fymd, tymd, format);
    }
}
