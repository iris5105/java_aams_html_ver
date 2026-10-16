package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032pDayDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032pDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032pFundDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032pMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

/**
 * 기준정보 옵션종목 일별현황 (W_JA032P) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja032pService {

    private final Ja032pMapper ja032pMapper;
    private final WorkDateService workDateService;

    /**
     * 1. 펀드 목록 조회 (d_ja032m1.srd)
     */
    public List<Ja032pFundDto> getFundList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032pMapper.selectFundList(corpGr, ymd);
    }

    /**
     * 2. 옵션종목 보유현황 조회 (d_ja032p2.srd)
     */
    public List<Ja032pDetailDto> getDetailList(String corpGr, String ymd, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank() || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032pMapper.selectDetailList(corpGr, ymd, fundCd);
    }

    /**
     * 3. 옵션종목 일별추이 조회 (d_ja032p3.srd)
     */
    public List<Ja032pDayDto> getDayList(String corpGr, String ymd, String fundCd, String jmCd, String trustee) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()
                || fundCd == null || fundCd.isBlank() || jmCd == null || jmCd.isBlank()
                || trustee == null || trustee.isBlank()) {
            return Collections.emptyList();
        }
        return ja032pMapper.selectDayList(corpGr, ymd, fundCd, jmCd, trustee);
    }

    /**
     * 작업기준일 조회 (SZX0AA.HYUN_YMD 기준)
     */
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }
}
