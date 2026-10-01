package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010aDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010aMasterDto;
import com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja010aQueryDslRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_ja010a (회사계약 및 변경이력 관리)
 * - Single-table queries on SZX0AA and SZX0AB via QueryDSL (Guideline 4)
 * - Strictly adheres to Guideline 1 (no default value fallback)
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010aService {

    private final Ja010aQueryDslRepository ja010aQueryDslRepository;

    public List<Ja010aMasterDto> getMasterList() {
        return ja010aQueryDslRepository.findMasterList();
    }

    public List<Ja010aDetailDto> getDetailList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja010aQueryDslRepository.findDetailList(corpGr.trim());
    }

    public String getNextCorpGr() {
        return ja010aQueryDslRepository.getNextCorpGr();
    }

    /**
     * w_ja010a 일괄 저장 (JPA EntityManager merge/persist)
     */
    @Transactional
    public void saveJa010a(com.kfp.aams.domain.dailyadvisory.dto.Ja010aSaveRequestDto request) {
        if (request == null) return;

        // 0. 삭제 선행 처리 (Detail -> Master 순서로 무결성 유지)
        if (request.getDeletedDetailList() != null) {
            for (Ja010aDetailDto del : request.getDeletedDetailList()) {
                ja010aQueryDslRepository.deleteDetail(del);
            }
        }
        if (request.getDeletedMasterList() != null) {
            for (Ja010aMasterDto del : request.getDeletedMasterList()) {
                ja010aQueryDslRepository.deleteMaster(del);
            }
        }

        // 1. 마스터 (SZX0AA) 처리
        if (request.getMasterList() != null) {
            for (Ja010aMasterDto master : request.getMasterList()) {
                if (Boolean.TRUE.equals(master.getIsNew())) {
                    if (master.getCorpGr() == null || master.getCorpGr().isBlank()) {
                        master.setCorpGr(ja010aQueryDslRepository.getNextCorpGr());
                    }
                    ja010aQueryDslRepository.saveMaster(master);
                } else if (Boolean.TRUE.equals(master.getIsUpdated())) {
                    ja010aQueryDslRepository.saveMaster(master);
                }
            }
        }

        // 2. 디테일 (SZX0AB) 처리
        if (request.getDetailList() != null) {
            for (Ja010aDetailDto detail : request.getDetailList()) {
                if (Boolean.TRUE.equals(detail.getIsNew()) || Boolean.TRUE.equals(detail.getIsUpdated())) {
                    ja010aQueryDslRepository.saveDetail(detail);
                }
            }
        }
    }
}
