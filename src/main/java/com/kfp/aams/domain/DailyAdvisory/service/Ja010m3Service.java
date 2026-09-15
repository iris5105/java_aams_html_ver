package com.kfp.aams.domain.DailyAdvisory.service;

import com.kfp.aams.domain.DailyAdvisory.dto.Ja010m3Dto;
import com.kfp.aams.domain.DailyAdvisory.dto.Ja010m3SaveDto;
import com.kfp.aams.domain.DailyAdvisory.mapper.Ja010m3Mapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja010m3Service {

    private final Ja010m3Mapper ja010m3Mapper;
    private final RdReportService rdReportService;

    public RdReportService.ExportResult generateReport(String corpGr, String mrdName, String fundCd, String fundNm,
                                                       String gyulYmd, String format) throws Exception {
        return rdReportService.generateJa010m3Report(corpGr, mrdName, fundCd, fundNm, gyulYmd, format);
    }

    @Transactional(readOnly = true)
    public List<Ja010m3Dto> getList(String corpGr, String gyulYmd, String sortGb, boolean isAdmin) {
        if (corpGr == null || corpGr.trim().isEmpty()) {
            return Collections.emptyList();
        }

        String chk = isAdmin ? "b" : "a";
        String normalizedSortGb = (sortGb != null && !sortGb.trim().isEmpty()) ? sortGb.trim() : "1";

        // Mapper의 TO_DATE(#{gyulYmd}, 'YYYY-MM-DD')에 맞추어 YYYY-MM-DD 포맷 유지
        String formattedYmd = (gyulYmd != null && !gyulYmd.trim().isEmpty()) ? gyulYmd.trim() : "";
        if (formattedYmd.length() == 8 && !formattedYmd.contains("-")) {
            formattedYmd = formattedYmd.substring(0, 4) + "-" + formattedYmd.substring(4, 6) + "-" + formattedYmd.substring(6, 8);
        }

        return ja010m3Mapper.selectJa010m3List(corpGr, formattedYmd, normalizedSortGb, chk);
    }

    @Transactional
    public void save(Ja010m3SaveDto saveDto) {
        if (saveDto == null || saveDto.getUpdatedList() == null || saveDto.getUpdatedList().isEmpty()) {
            return;
        }

        for (Ja010m3SaveDto.Ja010m3ItemSaveDto item : saveDto.getUpdatedList()) {
            // 'a' 테이블 (SKT1GS_INDATA) 항목만 저장 대상
            if (!"b".equals(item.getTblGb())) {
                if (item.getGyulYmd() != null) {
                    item.setGyulYmd(item.getGyulYmd().replace("-", ""));
                }
                ja010m3Mapper.updateJa010m3(item);
            }
        }
    }
}
