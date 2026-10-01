package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010dDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja010dMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_ja010d (계좌기본정보/입출고등록)
 * - Multi-table join (SZT0IO + SZM0IA) via MyBatis (Guideline 4)
 * - Strictly adheres to Guideline 1 (no default value fallback)
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010dService {

    private final Ja010dMapper ja010dMapper;
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja010dQueryDslRepository ja010dQueryDslRepository;

    public List<Ja010dDto> getJa010dList(String corpGr, String trYmd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trYmd.isBlank()) {
            return Collections.emptyList();
        }
        return ja010dMapper.selectJa010dList(corpGr.trim(), trYmd.trim());
    }

    public List<String> getTrDates(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja010dMapper.selectJa010dTrDates(corpGr.trim());
    }

    @Transactional
    public void saveJa010d(com.kfp.aams.domain.dailyadvisory.dto.Ja010dSaveRequestDto req) {
        saveJa010d(req, "SYSTEM");
    }

    @Transactional
    public void saveJa010d(com.kfp.aams.domain.dailyadvisory.dto.Ja010dSaveRequestDto req, String modUser) {
        if (req == null || req.getCorpGr() == null || req.getCorpGr().isBlank()) {
            throw new IllegalArgumentException("회사그룹 정보가 누락되었습니다.");
        }
        String corpGr = req.getCorpGr().trim();
        String trYmd = req.getTrYmd() != null ? req.getTrYmd().trim() : "";

        // 1. 삭제 대기열(deletedList) 처리
        if (req.getDeletedList() != null) {
            for (Ja010dDto del : req.getDeletedList()) {
                if (del.getCorpGr() == null || del.getCorpGr().isBlank()) {
                    del.setCorpGr(corpGr);
                }
                if (del.getTrYmd() == null || del.getTrYmd().isBlank()) {
                    del.setTrYmd(trYmd);
                }
                ja010dQueryDslRepository.deleteIo(del);
            }
        }

        // 2. 추가 및 수정(itemList) 처리
        if (req.getItemList() != null) {
            for (Ja010dDto dto : req.getItemList()) {
                dto.setCorpGr(corpGr);
                if (dto.getTrYmd() == null || dto.getTrYmd().isBlank()) {
                    dto.setTrYmd(trYmd);
                }

                // PB dw_list::itemchanged 검증
                if (dto.isNew()) {
                    ja010dQueryDslRepository.validateFstSeoljYmd(corpGr, dto.getFundCd(), dto.getTrYmd(), dto.getInAek());
                    ja010dQueryDslRepository.insertIo(dto, modUser);
                } else if (dto.isUpdated()) {
                    ja010dQueryDslRepository.updateIo(dto, modUser);
                }
            }
        }

        if (!trYmd.isBlank()) {
            ja010dQueryDslRepository.updateGijungaYmd(corpGr, trYmd);
        }

        ja010dQueryDslRepository.flush();
    }
}
