package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja030eDetailDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030eMasterDto;
import com.kfp.aams.domain.assetmanagement.mapper.Ja030eMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * W_JA030E 채권 종목정보 및 보유현황 비즈니스 로직 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja030eService {

    private final Ja030eMapper ja030eMapper;

    /**
     * 상단 보유 채권 종목 목록 조회 (파워빌더 wue_retrieve -> dw_List)
     */
    public List<Ja030eMasterDto> getMasterList(String corpGr, String ymd) {
        String cleanCorpGr = corpGr != null ? corpGr.trim() : "";
        String cleanYmd = ymd != null ? ymd.replaceAll("[^0-9]", "") : "";

        return ja030eMapper.selectJa030eMasterList(cleanCorpGr, cleanYmd);
    }

    /**
     * 하단 채권 종목 기본 정보 및 펀드별 보유현황 조회 (파워빌더 dw_detail::ue_retrieve)
     * 종목 헤더 정보(selectJa030eHeaderInfo) 및 펀드별 보유현황(selectJa030eDetailList) 직접 조회
     */
    public Map<String, Object> getDetailInfo(String corpGr, String jmCd, String ymd) {
        String cleanCorpGr = corpGr != null ? corpGr.trim() : "";
        String cleanJmCd = jmCd != null ? jmCd.trim() : "";
        String cleanYmd = ymd != null ? ymd.replaceAll("[^0-9]", "") : "";

        Map<String, Object> result = new HashMap<>();

        // 1. 채권 종목 기본 헤더 정보 조회 (단건)
        Ja030eDetailDto header = null;
        try {
            header = ja030eMapper.selectJa030eHeaderInfo(cleanCorpGr, cleanJmCd, cleanYmd);
        } catch (Exception e) {
            log.error("[Ja030eService] selectJa030eHeaderInfo 조회 실패: {}", e.getMessage());
        }

        // 2. 펀드별 보유현황 목록 조회 (다건)
        List<Ja030eDetailDto> list = null;
        try {
            list = ja030eMapper.selectJa030eDetailList(cleanCorpGr, cleanJmCd, cleanYmd);
        } catch (Exception e) {
            log.error("[Ja030eService] selectJa030eDetailList 조회 실패: {}", e.getMessage());
            list = new ArrayList<>();
        }

        result.put("header", header);
        result.put("list", list != null ? list : new ArrayList<>());
        return result;
    }

    /**
     * 운용사명 조회 (SZX0AA.COMPANY_NAME)
     */
    public String getCompanyName(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return "";
        }
        try {
            String name = ja030eMapper.selectCompanyName(corpGr.trim());
            return name != null ? name.trim() : "";
        } catch (Exception e) {
            log.error("[Ja030eService] getCompanyName 조회 실패: {}", e.getMessage());
            return "";
        }
    }
}

