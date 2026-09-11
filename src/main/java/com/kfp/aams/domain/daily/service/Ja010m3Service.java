package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010m3Dto;
import com.kfp.aams.domain.daily.dto.Ja010m3SaveDto;
import com.kfp.aams.domain.daily.mapper.Ja010m3Mapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja010m3Service {

    private final Ja010m3Mapper ja010m3Mapper;

    @Transactional(readOnly = true)
    public List<Ja010m3Dto> getList(String corpGr, String gyulYmd, String sortGb, boolean isAdmin) {
        if (corpGr == null || corpGr.trim().isEmpty()) {
            return Collections.emptyList();
        }

        String chk = isAdmin ? "b" : "a";
        String formattedYmd = (gyulYmd != null && !gyulYmd.trim().isEmpty())
                ? gyulYmd.replace("-", "") : null;

        // 고객명순(sortGb='1')일 때 pb 스크립트에서는 날짜를 null로 주어 최초설정일부터 전수조회
        if ("1".equals(sortGb)) {
            formattedYmd = null;
        }

        return ja010m3Mapper.selectJa010m3List(corpGr, formattedYmd, sortGb, chk);
    }

    @Transactional
    public void save(Ja010m3SaveDto saveDto) {
        if (saveDto == null || saveDto.getUpdatedList() == null || saveDto.getUpdatedList().isEmpty()) {
            return;
        }

        for (Ja010m3SaveDto.Ja010m3ItemSaveDto item : saveDto.getUpdatedList()) {
            // 'a' 테이블 (SKT1GS_INDATA) 항목만 저장 대상
            if (!"b".equals(item.getTblGb())) {
                if (item.getGyulYmd() != null) {
                    item.setGyulYmd(item.getGyulYmd().replace("-", ""));
                }
                ja010m3Mapper.updateJa010m3(item);
            }
        }
    }
}
