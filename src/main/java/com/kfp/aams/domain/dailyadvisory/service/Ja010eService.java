package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010eDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja010eMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_ja010e (주식체결LOAD(입고))
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010eService {

    private final Ja010eMapper ja010eMapper;
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja010eQueryDslRepository ja010eQueryDslRepository;

    /**
     * Retrieve Stock Trading Load List (d_ja010e1.srd)
     */
    public List<Ja010eDto> getList(String corpGr, String trYmd, String trCoCd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trYmd.isBlank()) {
            return Collections.emptyList();
        }
        String coCd = (trCoCd != null && !trCoCd.isBlank() && !"%".equals(trCoCd.trim())) ? trCoCd.trim() : null;
        return ja010eMapper.selectJa010eList(corpGr.trim(), trYmd.trim(), coCd);
    }

    /**
     * Retrieve Available Dates for Calendar Highlighting (w_ja010e.srw / dw_c::ue_getdate / SJT1JG)
     */
    public List<String> getDates(String corpGr, String trCoCd) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        String coCd = (trCoCd != null && !trCoCd.isBlank() && !"%".equals(trCoCd.trim())) ? trCoCd.trim() : null;
        return ja010eMapper.selectJa010eDates(corpGr.trim(), coCd);
    }

    @Transactional
    public void saveJa010e(com.kfp.aams.domain.dailyadvisory.dto.Ja010eSaveRequestDto req) {
        if (req == null || req.getCorpGr() == null || req.getCorpGr().isBlank()) {
            throw new IllegalArgumentException("회사그룹 정보가 누락되었습니다.");
        }
        String corpGr = req.getCorpGr().trim();
        String ymd = req.getYmd() != null ? req.getYmd().trim() : "";

        // 1. 삭제 대기열(deletedList) 선행 삭제
        if (req.getDeletedList() != null) {
            for (Ja010eDto del : req.getDeletedList()) {
                if (del.getCorpGr() == null || del.getCorpGr().isBlank()) {
                    del.setCorpGr(corpGr);
                }
                if (del.getTrYmd() == null || del.getTrYmd().isBlank()) {
                    del.setTrYmd(ymd);
                }
                ja010eQueryDslRepository.deleteSjt1jg(del);
            }
        }

        // 2. 추가 및 수정 항목 반영
        if (req.getItemList() != null) {
            for (Ja010eDto dto : req.getItemList()) {
                dto.setCorpGr(corpGr);
                if (dto.getTrYmd() == null || dto.getTrYmd().isBlank()) {
                    dto.setTrYmd(ymd);
                }
                if (dto.isNew()) {
                    if (dto.getOfferNo() == null || dto.getOfferNo() == 0L) {
                        Long nextNo = ja010eQueryDslRepository.getNextOfferNo(corpGr, dto.getTrYmd());
                        dto.setOfferNo(nextNo);
                    }
                    ja010eQueryDslRepository.insertSjt1jg(dto);
                } else if (dto.isUpdated()) {
                    ja010eQueryDslRepository.updateSjt1jg(dto);
                }
            }
        }
    }
}
