package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010oMasterDto;
import com.kfp.aams.domain.daily.dto.Ja010oSaveDto;
import com.kfp.aams.domain.daily.mapper.Ja010oMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * Service for w_ja010o (Stock Credit/Loan Balance LOAD / 주식 신용/대출잔고 LOAD)
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010oService {

    private final Ja010oMapper ja010oMapper;

    /**
     * 주식 신용/대출 잔고 내역 조회 (d_ja010o1.srd)
     */
    public List<Ja010oMasterDto> getJa010oList(String corpGr, String ymd, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank() || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyList();
        }
        return ja010oMapper.selectJa010oList(corpGr, ymd, fundCd);
    }

    /**
     * 운용사별 펀드 목록 조회
     */
    public List<Map<String, Object>> getFundList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja010oMapper.selectFundList(corpGr);
    }

    /**
     * SJM0JM_COLL 신용/대출 담보 내역 일괄 저장 및 삭제
     */
    @Transactional
    public void saveCollateral(Ja010oSaveDto saveDto) {
        if (saveDto == null) return;

        String corpGr = saveDto.getCorpGr();
        String ymd = saveDto.getYmd();
        String fundCd = saveDto.getFundCd();

        // 1. 수정/저장 대상 처리
        if (saveDto.getSaveList() != null) {
            for (Ja010oMasterDto dto : saveDto.getSaveList()) {
                if (dto.getCorpGr() == null || dto.getCorpGr().isBlank()) dto.setCorpGr(corpGr);
                if (dto.getYmd() == null || dto.getYmd().isBlank()) dto.setYmd(ymd);
                if (dto.getFundCd() == null || dto.getFundCd().isBlank()) dto.setFundCd(fundCd);

                ja010oMapper.mergeCollateral(dto);
            }
        }

        // 2. 삭제 대상 처리
        if (saveDto.getDeleteList() != null) {
            for (Ja010oMasterDto dto : saveDto.getDeleteList()) {
                if (dto.getCorpGr() == null || dto.getCorpGr().isBlank()) dto.setCorpGr(corpGr);
                if (dto.getYmd() == null || dto.getYmd().isBlank()) dto.setYmd(ymd);
                if (dto.getFundCd() == null || dto.getFundCd().isBlank()) dto.setFundCd(fundCd);

                ja010oMapper.deleteCollateral(dto);
            }
        }
    }
}
