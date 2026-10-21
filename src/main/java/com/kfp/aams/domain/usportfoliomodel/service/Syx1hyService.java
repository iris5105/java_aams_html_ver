package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Syx1hyDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Syx1hyMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.Collections;
import java.util.List;

/**
 * 환율등록 서비스 (W_SYX1HY)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Syx1hyService {

    private final Syx1hyMapper syx1hyMapper;

    /**
     * 통화별 기준환율 목록 조회 (최근 1년)
     */
    @Transactional(readOnly = true)
    public List<Syx1hyDto> getExchangeRateList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return syx1hyMapper.selectExchangeRateList(corpGr.trim(), ymd.trim());
    }

    /**
     * 통화별 기준환율 일괄 저장 (UPSERT)
     * 파워빌더 w_syx1hy.srw::updatestart 로직 100% 반영
     */
    @Transactional
    public void saveExchangeRateList(String corpGr, List<Syx1hyDto> list) {
        if (corpGr == null || corpGr.isBlank() || list == null || list.isEmpty()) {
            return;
        }

        String validCorpGr = corpGr.trim();

        for (Syx1hyDto dto : list) {
            String ymd = dto.getYmd();
            if (ymd == null || ymd.isBlank()) {
                continue;
            }

            // 수정된 행만 처리 (또는 값이 존재하는 통화별 환율 갱신)
            if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                // 1) USD
                if (dto.getUsdGijunRt() != null) {
                    syx1hyMapper.mergeExchangeRate(validCorpGr, ymd, "USD", dto.getUsdGijunRt());
                }
                // 2) GBP
                if (dto.getGbpGijunRt() != null) {
                    syx1hyMapper.mergeExchangeRate(validCorpGr, ymd, "GBP", dto.getGbpGijunRt());
                }
                // 3) HKD
                if (dto.getHkdGijunRt() != null) {
                    syx1hyMapper.mergeExchangeRate(validCorpGr, ymd, "HKD", dto.getHkdGijunRt());
                }
                // 4) VND
                if (dto.getVndGijunRt() != null) {
                    syx1hyMapper.mergeExchangeRate(validCorpGr, ymd, "VND", dto.getVndGijunRt());
                }
                // 5) SGD
                if (dto.getSgdGijunRt() != null) {
                    syx1hyMapper.mergeExchangeRate(validCorpGr, ymd, "SGD", dto.getSgdGijunRt());
                }
            }
        }
    }
}
