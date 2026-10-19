package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aMasterDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja033eDetailDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja033eMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

/**
 * 포트/종목별 종가대비 행사가격 (W_JA033E) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja033eService {

    private final Ja032aService ja032aService;
    private final Ja033eMapper ja033eMapper;

    /**
     * 작업기준일 조회
     */
    public String getWorkDate(String corpGr) {
        return ja032aService.getWorkDate(corpGr);
    }

    /**
     * 1. 상단 마스터 펀드 목록 조회 (d_ja033e1.srd -> d_ja032a1 재사용)
     */
    @Transactional(readOnly = true)
    public List<Ja032aMasterDto> getMasterList(String corpGr, LocalDate ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null) {
            return Collections.emptyList();
        }
        return ja032aService.getMasterList(corpGr, ymd);
    }

    /**
     * 2. 하단 포트/종목별 종가대비 행사가격 상세 목록 조회 (d_ja033e2.srd)
     */
    @Transactional(readOnly = true)
    public List<Ja033eDetailDto> getDetailList(String corpGr, LocalDate ymd, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyList();
        }

        List<Ja033eDetailDto> list = ja033eMapper.selectDetailList(corpGr, ymd, fundCd);
        if (list != null) {
            for (int i = 0; i < list.size(); i++) {
                list.get(i).setFseq(i + 1);
            }
        }
        return list;
    }
}
