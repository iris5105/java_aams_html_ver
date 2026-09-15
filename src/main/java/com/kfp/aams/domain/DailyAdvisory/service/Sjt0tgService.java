package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Sjt0tgDto;
import com.kfp.aams.domain.daily.dto.Sjt0tgSaveDto;
import com.kfp.aams.domain.daily.mapper.Sjt0tgMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class Sjt0tgService {

    private final Sjt0tgMapper sjt0tgMapper;

    /**
     * 주식 종가 목록 조회 (d_sjt0tg)
     * 파워빌더 retrieveend 로직과 연계하여, 당일 미등록 종목이 있을 경우 보강하여 반환
     */
    @Transactional(readOnly = true)
    public List<Sjt0tgDto> getSjt0tgList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return List.of();
        }

        List<Sjt0tgDto> resultList = new ArrayList<>(sjt0tgMapper.selectSjt0tgList(corpGr, ymd));

        try {
            // 당일 거래/보유 중인 미등록 종목 확인
            List<Sjt0tgDto> missingList = sjt0tgMapper.selectMissingKoscomList(corpGr, ymd);
            if (missingList != null && !missingList.isEmpty()) {
                Set<String> existingCodes = new HashSet<>();
                for (Sjt0tgDto item : resultList) {
                    if (item.getKoscomCd() != null) {
                        existingCodes.add(item.getKoscomCd().trim());
                    }
                }
                for (Sjt0tgDto missing : missingList) {
                    if (missing.getKoscomCd() != null && !existingCodes.contains(missing.getKoscomCd().trim())) {
                        missing.setIsNew(true);
                        missing.setRowStatus("C");
                        resultList.add(missing);
                    }
                }
            }
        } catch (Exception e) {
            log.warn("Missing koscom check skipped or failed: {}", e.getMessage());
        }

        return resultList;
    }

    /**
     * 주식 종가 내역 일괄 저장 (등록/수정/삭제)
     */
    @Transactional
    public void saveSjt0tg(Sjt0tgSaveDto saveDto) {
        if (saveDto == null) return;
        String corpGr = saveDto.getCorpGr();
        String ymd = saveDto.getYmd();

        // 1. 삭제 처리
        if (saveDto.getDeleteList() != null) {
            for (Sjt0tgDto dto : saveDto.getDeleteList()) {
                if (dto.getCorpGr() == null || dto.getCorpGr().isBlank()) dto.setCorpGr(corpGr);
                if (dto.getYmd() == null || dto.getYmd().isBlank()) dto.setYmd(ymd);
                sjt0tgMapper.deleteSjt0tg(dto);
            }
        }

        // 2. 신규 등록 처리
        if (saveDto.getInsertList() != null) {
            for (Sjt0tgDto dto : saveDto.getInsertList()) {
                if (dto.getCorpGr() == null || dto.getCorpGr().isBlank()) dto.setCorpGr(corpGr);
                if (dto.getYmd() == null || dto.getYmd().isBlank()) dto.setYmd(ymd);
                calculateChange(dto);
                sjt0tgMapper.mergeSjt0tg(dto);
            }
        }

        // 3. 수정 처리
        if (saveDto.getUpdateList() != null) {
            for (Sjt0tgDto dto : saveDto.getUpdateList()) {
                if (dto.getCorpGr() == null || dto.getCorpGr().isBlank()) dto.setCorpGr(corpGr);
                if (dto.getYmd() == null || dto.getYmd().isBlank()) dto.setYmd(ymd);
                calculateChange(dto);
                sjt0tgMapper.updateSjt0tg(dto);
            }
        }
    }

    private void calculateChange(Sjt0tgDto dto) {
        if (dto.getClose() != null && dto.getPreclose() != null) {
            dto.setChange(dto.getClose().subtract(dto.getPreclose()));
        } else if (dto.getClose() != null) {
            dto.setChange(dto.getClose());
        } else {
            dto.setClose(BigDecimal.ZERO);
            dto.setChange(BigDecimal.ZERO);
        }
    }
}
