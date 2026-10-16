package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bOptDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bOptFundDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bOptStockDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032bOptMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

/**
 * 기준정보 옵션위험값 일별현황 (W_JA032B_OPT) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja032bOptService {

    private final Ja032bOptMapper ja032bOptMapper;
    private final WorkDateService workDateService;

    /**
     * 조회기준일에 해당하는 포트 시작일(fymd) 조회
     */
    public String getFymd(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return ymd;
        }
        String fymd = ja032bOptMapper.selectFymd(corpGr, ymd);
        return (fymd != null && !fymd.isBlank()) ? fymd : ymd;
    }

    /**
     * 1. 펀드 목록 조회 (d_ja032n1.srd)
     */
    public List<Ja032bOptFundDto> getFundList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032bOptMapper.selectFundList(corpGr, ymd);
    }

    /**
     * 2. 종목 목록 조회 (d_ja032b.srd)
     */
    public List<Ja032bOptStockDto> getStockList(String corpGr, String fymd, String tymd, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || tymd == null || tymd.isBlank() || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyList();
        }
        String actualFymd = (fymd != null && !fymd.isBlank()) ? fymd : tymd;
        return ja032bOptMapper.selectStockList(corpGr, actualFymd, tymd, fundCd);
    }

    /**
     * 3. 옵션위험값 일별현황 조회 (d_ja032b_opt.srd / d_ja032b_opt_krx.srd 분기)
     */
    public List<Ja032bOptDetailDto> getDetailList(String corpGr, String fundCd, String jmCd, String fymd, String tymd) {
        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank()
                || jmCd == null || jmCd.isBlank() || tymd == null || tymd.isBlank()) {
            return Collections.emptyList();
        }
        String actualFymd = (fymd != null && !fymd.isBlank()) ? fymd : tymd;

        // 파워빌더 로직: POS(yj_cd, ':') == 0 이면 KRX 양식, 콜론이 있으면 해외 양식
        boolean isKrx = !jmCd.contains(":");
        if (isKrx) {
            return ja032bOptMapper.selectDetailKrxList(corpGr, fundCd, jmCd, actualFymd, tymd);
        } else {
            return ja032bOptMapper.selectDetailList(corpGr, fundCd, jmCd, actualFymd, tymd);
        }
    }

    /**
     * 작업기준일 조회 (SZX0AA.HYUN_YMD 기준)
     */
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }
}
