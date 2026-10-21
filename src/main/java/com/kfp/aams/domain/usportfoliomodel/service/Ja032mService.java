package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032mDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032mFundDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032mMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * 종목별 위험값 (W_JA032M) 서비스
 */
@Service
public class Ja032mService {

    private static final Logger log = LoggerFactory.getLogger(Ja032mService.class);

    private final Ja032mMapper ja032mMapper;
    private final WorkDateService workDateService;

    // 명시적 생성자 주입 (Zero-Lombok-ECJ-Conflict 원칙, 규정 01-4)
    public Ja032mService(Ja032mMapper ja032mMapper, WorkDateService workDateService) {
        this.ja032mMapper = ja032mMapper;
        this.workDateService = workDateService;
    }

    /**
     * DB 기준 영업일자 조회 (WorkDateService 필수 연동)
     */
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 1. 펀드 목록 조회 (d_ja032m1.srd)
     */
    @Transactional(readOnly = true)
    public List<Ja032mFundDto> getFundList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032mMapper.selectFundList(corpGr, ymd);
    }

    /**
     * 2. 종목별 위험값 상세 목록 조회 (d_ja032m2.srd)
     */
    @Transactional(readOnly = true)
    public List<Ja032mDetailDto> getDetailList(String corpGr, String ymd, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank() || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032mMapper.selectDetailList(corpGr, ymd, fundCd);
    }
}
