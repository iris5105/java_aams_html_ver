package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010bDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010bIoDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010bMasterDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja010bMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_ja010b (계좌계약정보관리)
 * - Queries d_ja010b1 (SZM0IA), d_ja010b2 (SZM0GI), and SZT0IO via MyBatis (includes Oracle TO_DECRYPTS)
 * - Strictly adheres to Guideline 1 (no default value fallback)
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010bService {

    private final Ja010bMapper ja010bMapper;
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja010bQueryDslRepository ja010bQueryDslRepository;

    public List<Ja010bMasterDto> getMasterList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja010bMapper.selectJa010bMasterList(corpGr.trim());
    }

    public List<Ja010bDetailDto> getDetailList(String corpGr, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyList();
        }
        return ja010bMapper.selectJa010bDetailList(corpGr.trim(), fundCd.trim());
    }

    public List<Ja010bIoDto> getIoList(String corpGr, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyList();
        }
        return ja010bMapper.selectJa010bIoList(corpGr.trim(), fundCd.trim());
    }

    public String getNextFundCd(String corpGr) {
        return ja010bQueryDslRepository.getNextFundCd(corpGr);
    }

    @Transactional
    public void saveJa010b(com.kfp.aams.domain.dailyadvisory.dto.Ja010bSaveRequestDto request) {
        saveJa010b(request, "SYSTEM");
    }

    /**
     * w_ja010b 일괄 저장 (JPA EntityManager C/U/D)
     */
    @Transactional
    public void saveJa010b(com.kfp.aams.domain.dailyadvisory.dto.Ja010bSaveRequestDto request, String modUser) {
        if (request == null) return;
        String corpGr = request.getCorpGr();

        // 0. 삭제 선행 처리 (Detail, IO 먼저 삭제 후 Master 삭제)
        if (request.getDeletedDetailList() != null) {
            for (Ja010bDetailDto del : request.getDeletedDetailList()) {
                if (del.getCorpGr() == null || del.getCorpGr().isBlank()) del.setCorpGr(corpGr);
                ja010bQueryDslRepository.deleteDetail(del);
            }
        }
        if (request.getDeletedIoList() != null) {
            for (Ja010bIoDto del : request.getDeletedIoList()) {
                if (del.getCorpGr() == null || del.getCorpGr().isBlank()) del.setCorpGr(corpGr);
                ja010bQueryDslRepository.deleteIo(del);
            }
        }
        if (request.getDeletedMasterList() != null) {
            for (Ja010bMasterDto del : request.getDeletedMasterList()) {
                if (del.getCorpGr() == null || del.getCorpGr().isBlank()) del.setCorpGr(corpGr);
                ja010bQueryDslRepository.deleteMaster(del);
            }
        }

        // 1. 마스터 (SZM0IA)
        if (request.getMasterList() != null) {
            for (Ja010bMasterDto master : request.getMasterList()) {
                if (master.getCorpGr() == null || master.getCorpGr().isBlank()) {
                    master.setCorpGr(corpGr);
                }
                if (Boolean.TRUE.equals(master.getIsNew())) {
                    if (master.getFundCd() == null || master.getFundCd().isBlank()) {
                        master.setFundCd(ja010bQueryDslRepository.getNextFundCd(master.getCorpGr()));
                    }
                    ja010bQueryDslRepository.insertMaster(master);
                } else if (Boolean.TRUE.equals(master.getIsUpdated())) {
                    ja010bQueryDslRepository.updateMaster(master);
                }
            }
        }

        // 2. 결산이력 (SZM0GI)
        if (request.getDetailList() != null) {
            for (Ja010bDetailDto detail : request.getDetailList()) {
                if (detail.getCorpGr() == null || detail.getCorpGr().isBlank()) {
                    detail.setCorpGr(corpGr);
                }
                if (Boolean.TRUE.equals(detail.getIsNew())) {
                    ja010bQueryDslRepository.insertDetail(detail);
                } else if (Boolean.TRUE.equals(detail.getIsUpdated())) {
                    ja010bQueryDslRepository.updateDetail(detail);
                }
            }
        }

        // 3. 입출고이력 (SZT0IO)
        if (request.getDeletedIoList() != null) {
            for (Ja010bIoDto del : request.getDeletedIoList()) {
                if (del.getCorpGr() == null || del.getCorpGr().isBlank()) del.setCorpGr(corpGr);
                ja010bQueryDslRepository.deleteIo(del);
            }
        }
        if (request.getIoList() != null) {
            for (Ja010bIoDto io : request.getIoList()) {
                if (io.getCorpGr() == null || io.getCorpGr().isBlank()) {
                    io.setCorpGr(corpGr);
                }
                io.setModUser(modUser);
                if (Boolean.TRUE.equals(io.getIsNew())) {
                    ja010bQueryDslRepository.insertIo(io);
                } else if (Boolean.TRUE.equals(io.getIsUpdated())) {
                    ja010bQueryDslRepository.updateIo(io);
                }
            }
        }
    }
}
