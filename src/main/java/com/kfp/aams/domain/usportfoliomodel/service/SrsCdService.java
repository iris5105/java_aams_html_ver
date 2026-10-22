package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.SrsCdDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.SrsCdMasterDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.SrsCdMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

/**
 * 해외파생 생성종목 (W_SRS_CD) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SrsCdService {

    private final SrsCdMapper srsCdMapper;

    /**
     * 해외파생 생성종목 마스터 목록 조회 (d_srs_cd1)
     */
    public List<SrsCdMasterDto> getMasterList(String isinCd) {
        String searchParam = (isinCd != null && !isinCd.isBlank() && !isinCd.equals("%")) ? isinCd.trim() : null;
        return srsCdMapper.selectMasterList(searchParam);
    }

    /**
     * 해외옵션 일별 시세 내역 조회 (d_srs_cd2)
     */
    public List<SrsCdDetailDto> getDetailList(String corpGr, String jmCd, String ymd) {
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return srsCdMapper.selectDetailList(corpGr.trim(), jmCd.trim(), ymd.trim());
    }

    /**
     * SZX0YM 참조 파생종목코드 자동 계산
     */
    public String calcDerivedCode(String exprDate, String blbgTckr, BigDecimal stkprc, String isCallPut) {
        if (exprDate == null || exprDate.isBlank() || blbgTckr == null || blbgTckr.isBlank() || stkprc == null) {
            return "";
        }
        try {
            String derived = srsCdMapper.calcDerivedSrsCd(exprDate.trim(), blbgTckr.trim(), stkprc, isCallPut);
            return (derived != null) ? derived.trim() : "";
        } catch (Exception e) {
            log.warn("파생코드 자동 계산 실패: {}", e.getMessage());
            return "";
        }
    }

    /**
     * 마스터 일괄 저장 (CUD)
     */
    @Transactional
    public int saveMasterList(List<SrsCdMasterDto> list) {
        if (list == null || list.isEmpty()) {
            return 0;
        }

        int affected = 0;
        for (SrsCdMasterDto dto : list) {
            if (Boolean.TRUE.equals(dto.getIsDeleted())) {
                affected += srsCdMapper.deleteMaster(dto);
            } else if (Boolean.TRUE.equals(dto.getIsNew())) {
                if (dto.getSrsCd() == null || dto.getSrsCd().isBlank()) {
                    throw new IllegalArgumentException("파생종목코드는 필수 입력 항목입니다.");
                }
                affected += srsCdMapper.insertMaster(dto);
            } else if (Boolean.TRUE.equals(dto.getIsUpdated())) {
                affected += srsCdMapper.updateMaster(dto);
            }
        }
        return affected;
    }
}
