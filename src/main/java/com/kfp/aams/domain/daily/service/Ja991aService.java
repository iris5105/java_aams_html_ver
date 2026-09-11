package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja991aDetailDto;
import com.kfp.aams.domain.daily.dto.Ja991aMasterDto;
import com.kfp.aams.domain.daily.mapper.Ja991aMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja991aService {

    private final Ja991aMapper ja991aMapper;

    /**
     * 마스터 종목 목록 조회 (d_ja991a1)
     */
    public List<Ja991aMasterDto> getMasterList(String corpGr, String ymd) {
        List<Ja991aMasterDto> list = ja991aMapper.selectMasterList(corpGr, ymd);
        if (list != null) {
            long seq = 1;
            for (Ja991aMasterDto dto : list) {
                dto.setFseq(seq++);
            }
        }
        return list != null ? list : Collections.emptyList();
    }

    /**
     * 디테일 종목별 종가 이력 조회 (d_ja991a2)
     */
    public List<Ja991aDetailDto> getDetailList(String koscomCd, String ymd) {
        if (koscomCd == null || koscomCd.isBlank()) {
            return Collections.emptyList();
        }
        List<Ja991aDetailDto> list = ja991aMapper.selectDetailList(koscomCd, ymd);
        if (list != null) {
            long seq = 1;
            for (Ja991aDetailDto dto : list) {
                dto.setFseq(seq++);
            }
        }
        return list != null ? list : Collections.emptyList();
    }
}
