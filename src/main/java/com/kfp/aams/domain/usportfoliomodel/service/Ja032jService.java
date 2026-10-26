package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032jDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032jMasterDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032jMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * 해외주식종가/업종지수 등록 (W_JA032J) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja032jService {

    private final Ja032jMapper ja032jMapper;

    /**
     * 1. 마스터 종가일자 및 주차 목록 조회 (d_ja032j1)
     */
    @Transactional(readOnly = true)
    public List<Ja032jMasterDto> getMasterList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja032jMapper.selectMasterList(corpGr);
    }

    /**
     * 2. 디테일 해외주식 종가 목록 조회 (d_ja032j2)
     */
    @Transactional(readOnly = true)
    public List<Ja032jDetailDto> getDetailList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032jMapper.selectDetailList(corpGr, ymd);
    }

    /**
     * 3. 디테일 CUD 일괄 저장
     */
    @Transactional
    public int saveDetailList(String corpGr, String ymd, List<Ja032jDetailDto> list) {
        if (list == null || list.isEmpty()) {
            return 0;
        }

        int count = 0;
        for (Ja032jDetailDto dto : list) {
            if (dto == null) continue;
            dto.setCorpGr(corpGr);
            if (dto.getYmd() == null || dto.getYmd().isBlank()) {
                dto.setYmd(ymd);
            }

            String jmCd = dto.getJmCd();
            if (jmCd == null || jmCd.isBlank()) {
                jmCd = dto.getYjCd();
            }
            if (jmCd == null || jmCd.isBlank()) {
                continue;
            }

            if (Boolean.TRUE.equals(dto.getIsDeleted()) || "D".equalsIgnoreCase(dto.getRowStatus())) {
                count += ja032jMapper.deleteDetail(corpGr, dto.getYmd(), jmCd);
            } else if (Boolean.TRUE.equals(dto.getIsNew()) || "C".equalsIgnoreCase(dto.getRowStatus())) {
                count += ja032jMapper.insertDetail(dto);
            } else if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                count += ja032jMapper.updateDetail(dto);
            }
        }

        return count;
    }
}
