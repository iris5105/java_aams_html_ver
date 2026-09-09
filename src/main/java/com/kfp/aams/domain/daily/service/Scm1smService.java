package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Scm1smDto;
import com.kfp.aams.domain.daily.dto.Scm1smSaveDto;
import com.kfp.aams.domain.daily.mapper.Scm1smMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class Scm1smService {

    private final Scm1smMapper scm1smMapper;

    /**
     * 채권 단가 목록 조회 (d_scm1sm)
     * 파워빌더 retrieveend 로직과 연계하여, 당일 미등록 종목이 있을 경우 보강하여 반환
     */
    @Transactional(readOnly = true)
    public List<Scm1smDto> getScm1smList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return List.of();
        }

        List<Scm1smDto> resultList = new ArrayList<>(scm1smMapper.selectScm1smList(corpGr, ymd));

        try {
            // 당일 거래/보유 중인 미등록 종목 확인
            List<Scm1smDto> missingList = scm1smMapper.selectMissingBondList(corpGr, ymd);
            if (missingList != null && !missingList.isEmpty()) {
                Set<String> existingCodes = new HashSet<>();
                for (Scm1smDto item : resultList) {
                    if (item.getJmCd() != null) {
                        existingCodes.add(item.getJmCd().trim());
                    }
                }
                for (Scm1smDto missing : missingList) {
                    if (missing.getJmCd() != null && !existingCodes.contains(missing.getJmCd().trim())) {
                        missing.setIsNew(true);
                        missing.setRowStatus("C");
                        resultList.add(missing);
                    }
                }
            }
        } catch (Exception e) {
            log.warn("Missing bond check skipped or failed: {}", e.getMessage());
        }

        return resultList;
    }

    /**
     * 채권 단가 저장 (신규, 수정, 삭제 일괄 처리)
     */
    @Transactional
    public int saveScm1sm(Scm1smSaveDto saveDto) {
        if (saveDto == null) return 0;

        int count = 0;
        String defaultCorpGr = saveDto.getCorpGr();
        String defaultYmd = saveDto.getYmd();

        // 1. 삭제 대상 처리
        if (saveDto.getDeleteList() != null && !saveDto.getDeleteList().isEmpty()) {
            for (Scm1smDto item : saveDto.getDeleteList()) {
                if (item.getCorpGr() == null || item.getCorpGr().isBlank()) item.setCorpGr(defaultCorpGr);
                if (item.getYmd() == null || item.getYmd().isBlank()) item.setYmd(defaultYmd);
                count += scm1smMapper.deleteScm1sm(item);
            }
        }

        // 2. 신규/수정 대상 처리 (MERGE)
        List<Scm1smDto> upsertList = new ArrayList<>();
        if (saveDto.getInsertList() != null) {
            upsertList.addAll(saveDto.getInsertList());
        }
        if (saveDto.getUpdateList() != null) {
            upsertList.addAll(saveDto.getUpdateList());
        }

        for (Scm1smDto item : upsertList) {
            if (item.getCorpGr() == null || item.getCorpGr().isBlank()) item.setCorpGr(defaultCorpGr);
            if (item.getYmd() == null || item.getYmd().isBlank()) item.setYmd(defaultYmd);
            if (item.getAsCjCd() == null || item.getAsCjCd().isBlank()) item.setAsCjCd(item.getJmCd());
            count += scm1smMapper.mergeScm1sm(item);
        }

        log.info("Saved Scm1sm (채권단가): {} rows processed for corpGr={}, ymd={}", count, defaultCorpGr, defaultYmd);
        return count;
    }
}
