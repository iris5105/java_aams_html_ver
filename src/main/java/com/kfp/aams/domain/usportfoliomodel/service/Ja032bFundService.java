package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aMasterDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bFundDetailDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032bFundMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

/**
 * 기준정보 펀드 일별현황 (W_JA032B_FUND) 비즈니스 로직 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja032bFundService {

    private final Ja032aService ja032aService;
    private final Ja032bFundMapper ja032bFundMapper;

    /**
     * 작업일자 조회 (회사그룹별)
     */
    public String getWorkDate(String corpGr) {
        return ja032aService.getWorkDate(corpGr);
    }

    /**
     * 1. 상단 마스터 펀드 목록 조회 (d_ja032a1.srd 재사용)
     */
    public List<Ja032aMasterDto> getMasterList(String corpGr, LocalDate ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null) {
            return Collections.emptyList();
        }
        return ja032aService.getMasterList(corpGr, ymd);
    }

    /**
     * 2. 하단 펀드별 일별현황 상세 목록 조회 (d_ja032b_fund2.srd)
     */
    public List<Ja032bFundDetailDto> getDetailList(String corpGr, LocalDate ymd, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyList();
        }

        List<Ja032bFundDetailDto> list = ja032bFundMapper.selectDetailList(corpGr, ymd, fundCd);
        if (list != null) {
            for (int i = 0; i < list.size(); i++) {
                Ja032bFundDetailDto dto = list.get(i);
                dto.setFseq(i + 1);
            }
        }
        return list != null ? list : Collections.emptyList();
    }
}
