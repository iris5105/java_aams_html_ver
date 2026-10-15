package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bDdDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bDdFundDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bDdStockDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032bDdMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

/**
 * 기준정보 종목 일별현황 (W_JA032B_DD) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja032bDdService {

    private final Ja032bDdMapper ja032bDdMapper;

    /**
     * 조회기준일에 해당하는 포트 시작일(fymd) 조회
     */
    public String getFymd(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return ymd;
        }
        String fymd = ja032bDdMapper.selectFymd(corpGr, ymd);
        return (fymd != null && !fymd.isBlank()) ? fymd : ymd;
    }

    /**
     * 1. 펀드 목록 조회 (d_ja032n1.srd)
     */
    public List<Ja032bDdFundDto> getFundList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032bDdMapper.selectFundList(corpGr, ymd);
    }

    /**
     * 2. 종목 목록 조회 (d_ja032b.srd)
     */
    public List<Ja032bDdStockDto> getStockList(String corpGr, String fymd, String tymd, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || tymd == null || tymd.isBlank() || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyList();
        }
        String actualFymd = (fymd != null && !fymd.isBlank()) ? fymd : tymd;
        return ja032bDdMapper.selectStockList(corpGr, actualFymd, tymd, fundCd);
    }

    /**
     * 3. 종목 일별현황 조회 (d_ja032b_dd.srd / d_ja032b_dd_krx.srd 분기)
     */
    public List<Ja032bDdDetailDto> getDetailList(String corpGr, String jmCd, String fymd, String tymd) {
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank() || tymd == null || tymd.isBlank()) {
            return Collections.emptyList();
        }
        String actualFymd = (fymd != null && !fymd.isBlank()) ? fymd : tymd;

        // 파워빌더 로직: POS(yj_cd, ':') == 0 이면 KRX 양식, 콜론이 있으면 해외 양식
        boolean isKrx = !jmCd.contains(":");
        if (isKrx) {
            return ja032bDdMapper.selectKrxDetailList(corpGr, jmCd, actualFymd, tymd);
        } else {
            return ja032bDdMapper.selectOverseasDetailList(corpGr, jmCd, actualFymd, tymd);
        }
    }

    /**
     * 작업기준일 조회
     */
    public String getWorkDate(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return LocalDate.now().toString();
        }
        String workDate = ja032bDdMapper.selectWorkDate(corpGr);
        return (workDate != null && !workDate.isBlank()) ? workDate : LocalDate.now().toString();
    }
}
