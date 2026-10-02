package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010fDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja010fMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_ja010f (예수금잔액LOAD)
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010fService {

    private final Ja010fMapper ja010fMapper;
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja010fQueryDslRepository ja010fQueryDslRepository;

    /**
     * Retrieve Deposit Balance Load List (d_ja010f1.srd)
     */
    public List<Ja010fDto> getList(String corpGr, java.time.LocalDate trYmd, String trCoCd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null) {
            return Collections.emptyList();
        }
        String coCd = (trCoCd != null && !trCoCd.isBlank() && !"%".equals(trCoCd.trim())) ? trCoCd.trim() : null;
        return ja010fMapper.selectJa010fList(corpGr.trim(), trYmd, coCd);
    }

    /**
     * Retrieve Available Dates for Calendar Highlighting (dw_c::ue_getdate / SHT0YE)
     */
    public List<String> getDates(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja010fMapper.selectJa010fDates(corpGr.trim());
    }

    @Transactional
    public void saveJa010f(com.kfp.aams.domain.dailyadvisory.dto.Ja010fSaveRequestDto req) {
        if (req == null || req.getCorpGr() == null || req.getCorpGr().isBlank()) {
            throw new IllegalArgumentException("회사그룹 정보가 누락되었습니다.");
        }
        String corpGr = req.getCorpGr().trim();
        java.time.LocalDate ymd = req.getYmd();

        // 1. 삭제 대기열(deletedList) 선행 삭제
        if (req.getDeletedList() != null) {
            for (Ja010fDto del : req.getDeletedList()) {
                if (del.getCorpGr() == null || del.getCorpGr().isBlank()) {
                    del.setCorpGr(corpGr);
                }
                if (del.getTrYmd() == null) {
                    del.setTrYmd(ymd);
                }
                ja010fQueryDslRepository.deleteSht0ye(del);
            }
        }

        // 2. 추가 및 수정 처리
        if (req.getItemList() != null) {
            for (Ja010fDto dto : req.getItemList()) {
                dto.setCorpGr(corpGr);
                if (dto.getTrYmd() == null) {
                    dto.setTrYmd(ymd);
                }
                if (dto.isNew()) {
                    ja010fQueryDslRepository.insertSht0ye(dto);
                } else if (dto.isUpdated()) {
                    ja010fQueryDslRepository.updateSht0ye(dto);
                }
            }
        }
    }
}
