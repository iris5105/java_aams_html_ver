package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032nDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032nJisuDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032nMasterDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032nMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

/**
 * 포트별 옵션수익실현현황 (W_JA032N) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja032nService {

    private final Ja032nMapper ja032nMapper;
    private final WorkDateService workDateService;

    /**
     * 작업기준일 조회
     */
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 1. 좌측 마스터 펀드 운용손익 현황 목록 조회 (d_ja032n1.srd)
     */
    @Transactional(readOnly = true)
    public List<Ja032nMasterDto> getMasterList(String corpGr, LocalDate ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null) {
            return Collections.emptyList();
        }
        return ja032nMapper.selectMasterList(corpGr, ymd);
    }

    /**
     * 2. 우측 상단 지수 및 펀드 수익률 요약 조회 (d_ja032n3.srd - F_JA032N)
     */
    @Transactional(readOnly = true)
    public Ja032nJisuDto getJisuSummary(String corpGr, LocalDate ymd, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || fundCd == null || fundCd.isBlank()) {
            return null;
        }
        return ja032nMapper.selectJisuSummary(corpGr, ymd, fundCd);
    }

    /**
     * 3. 우측 하단 포트별 옵션수익실현 상세 목록 조회 (d_ja032n2.srd)
     */
    @Transactional(readOnly = true)
    public List<Ja032nDetailDto> getDetailList(String corpGr, LocalDate ymd, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032nMapper.selectDetailList(corpGr, ymd, fundCd);
    }
}
