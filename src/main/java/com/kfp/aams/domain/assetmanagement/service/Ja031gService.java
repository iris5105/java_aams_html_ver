package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja031gDetailDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031gMasterDto;
import com.kfp.aams.domain.assetmanagement.mapper.Ja031gMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja031gService {

    private final Ja031gMapper ja031gMapper;

    /**
     * 현금/단기금융 매매현황 펀드 목록 조회
     * 파워빌더 d_ja031g.srd retrieveend: 1행에 '%' / '전체' 삽입
     */
    public List<Ja031gMasterDto> getMasterList(String corpGr, String fYmd, String tYmd) {
        String safeFymd = normalizeDate(fYmd);
        String safeTymd = normalizeDate(tYmd);

        List<Ja031gMasterDto> rawList = ja031gMapper.selectMasterList(corpGr, safeFymd, safeTymd);
        List<Ja031gMasterDto> result = new ArrayList<>();

        // PB d_ja031g retrieveend: 첫 번째 행에 '전체' 행 자동 삽입
        result.add(Ja031gMasterDto.builder()
                .fundCd("%")
                .fundNm("전체")
                .xxFundCd("전체")
                .build());

        if (rawList != null && !rawList.isEmpty()) {
            result.addAll(rawList);
        }

        return result;
    }

    /**
     * 현금/단기금융 매매내역 상세 목록 조회
     */
    public List<Ja031gDetailDto> getDetailList(String corpGr, String fYmd, String tYmd, String fundCd) {
        String safeFymd = normalizeDate(fYmd);
        String safeTymd = normalizeDate(tYmd);
        String safeFundCd = (fundCd != null && !fundCd.isBlank()) ? fundCd.trim() : "%";

        List<Ja031gDetailDto> list = ja031gMapper.selectDetailList(corpGr, safeFymd, safeTymd, safeFundCd);
        return list != null ? list : Collections.emptyList();
    }

    private String normalizeDate(String ymd) {
        if (ymd == null || ymd.isBlank()) return "";
        String clean = ymd.replaceAll("[^0-9]", "");
        if (clean.length() == 8) {
            return clean.substring(0, 4) + "-" + clean.substring(4, 6) + "-" + clean.substring(6, 8);
        }
        return ymd.trim();
    }
}

