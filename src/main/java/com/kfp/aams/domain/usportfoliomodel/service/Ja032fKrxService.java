package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032fKrxDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja991a2Dto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032fKrxMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.Collections;
import java.util.List;

/**
 * KRX 주식종목정보 서비스 (W_JA032F_KRX)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja032fKrxService {

    private final Ja032fKrxMapper ja032fKrxMapper;

    /**
     * KRX 주식 종목정보 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Ja032fKrxDto> getKrxStockList() {
        return ja032fKrxMapper.selectKrxStockList();
    }

    /**
     * 특정 종목의 일별 시세 목록 조회 (최근 1년)
     */
    @Transactional(readOnly = true)
    public List<Ja991a2Dto> getDailyPriceList(String koscomCd, String ymd) {
        if (koscomCd == null || koscomCd.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032fKrxMapper.selectDailyPriceList(koscomCd.trim(), ymd.trim());
    }

    /**
     * USPM 등록여부 변경사항 일괄 저장
     * 파워빌더 w_ja032f_krx.srw::itemchanged 로직 반영
     */
    @Transactional
    public void saveKrxStockUspmList(String corpGr, String ymd, List<Ja032fKrxDto> list) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank() || list == null || list.isEmpty()) {
            return;
        }

        String validCorpGr = corpGr.trim();
        String validYmd = ymd.trim();

        for (Ja032fKrxDto dto : list) {
            if (dto.getJmCd() == null || dto.getJmCd().isBlank()) {
                continue;
            }

            if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                String uspmVal = ("1".equals(dto.getUspm()) || "Y".equalsIgnoreCase(dto.getUspm()) || Boolean.TRUE.toString().equalsIgnoreCase(dto.getUspm())) ? "1" : "0";

                // 1) SJM0JJ.USPM 업데이트
                ja032fKrxMapper.updateSjm0jjUspm(dto.getJmCd().trim(), uspmVal);

                // 2) USPM_DD 등록/삭제
                if ("1".equals(uspmVal)) {
                    ja032fKrxMapper.insertUspmDd(validCorpGr, validYmd, dto.getJmCd().trim(), "KRX");
                } else {
                    ja032fKrxMapper.deleteUspmDd(validCorpGr, validYmd, dto.getJmCd().trim(), "KRX");
                }
            }
        }
    }

    /**
     * 특정 종목 일별 시세(d_ja991a2) 인라인 편집 변경사항 일괄 저장
     */
    @Transactional
    public void saveDailyPriceList(List<Ja991a2Dto> list) {
        if (list == null || list.isEmpty()) {
            return;
        }

        for (Ja991a2Dto dto : list) {
            if (dto.getKoscomCd() == null || dto.getKoscomCd().isBlank()
                    || dto.getYmd() == null || dto.getYmd().isBlank()) {
                continue;
            }

            if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                ja032fKrxMapper.updateDailyPrice(dto);
            }
        }
    }
}
