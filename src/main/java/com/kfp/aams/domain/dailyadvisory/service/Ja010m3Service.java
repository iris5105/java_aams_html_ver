package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010m3Dto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010m3SaveDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja010m3Mapper;
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
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja010m3QueryDslRepository ja010m3QueryDslRepository;
    private final RdReportService rdReportService;

    public RdReportService.ExportResult generateReport(String corpGr, String mrdName, String fundCd, String fundNm,
                                                       String gyulYmd, String format) throws Exception {
        return rdReportService.generateJa010m3Report(corpGr, mrdName, fundCd, fundNm, gyulYmd, format);
    }

    @Transactional(readOnly = true)
    public List<Ja010m3Dto> getList(String corpGr, java.time.LocalDate gyulYmd, String sortGb, boolean isAdmin) {
        if (corpGr == null || corpGr.trim().isEmpty()) {
            return Collections.emptyList();
        }

        String chk = isAdmin ? "b" : "a";
        String normalizedSortGb = (sortGb != null && !sortGb.trim().isEmpty()) ? sortGb.trim() : "1";

        return ja010m3Mapper.selectJa010m3List(corpGr, gyulYmd, normalizedSortGb, chk);
    }

    @Transactional
    public void save(Ja010m3SaveDto saveDto) {
        if (saveDto == null || saveDto.getUpdatedList() == null || saveDto.getUpdatedList().isEmpty()) {
            return;
        }

        for (Ja010m3SaveDto.Ja010m3ItemSaveDto item : saveDto.getUpdatedList()) {
            // 'a' 테이블 (SKT1GS_INDATA) 항목만 저장 대상
            if (!"b".equals(item.getTblGb())) {
                ja010m3QueryDslRepository.updateJa010m3(item);
            }
        }
    }
}
