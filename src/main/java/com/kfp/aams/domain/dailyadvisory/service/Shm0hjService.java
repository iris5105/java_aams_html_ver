package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Shj0igDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Shm0hjMasterDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Shm0hjMapper;
import com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Shj0igQueryDslRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

/**
 * Service for w_shm0hj (현금 매입(종목)등록)
 * - Master query (d_shm0hj): Multi-table join via MyBatis (Guideline 4)
 * - Detail query (d_shj0ig): Single table query via QueryDSL (Guideline 4)
 * - Adheres strictly to Guideline 1 (no default value fallback)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Shm0hjService {

    private final Shm0hjMapper shm0hjMapper;
    private final Shj0igQueryDslRepository shj0igQueryDslRepository;
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Shm0hjQueryDslRepository shm0hjQueryDslRepository;

    /**
     * Master Cash Purchase List (d_shm0hj via MyBatis)
     */
    @Transactional(readOnly = true)
    public List<Shm0hjMasterDto> getMasterList(String corpGr, String ymd, String cashCd) {
        // Guideline 1: Do not supply default values for corpGr or other parameters
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }

        String searchCashCd = (cashCd == null || cashCd.isBlank() || "%".equals(cashCd)) ? "%" : cashCd.trim();
        return shm0hjMapper.selectShm0hjList(corpGr.trim(), ymd.trim(), searchCashCd);
    }

    /**
     * Detail Interest Period List (d_shj0ig via QueryDSL)
     */
    @Transactional(readOnly = true)
    public List<Shj0igDetailDto> getDetailList(String corpGr, String jmCd, BigDecimal nowNo) {
        // Guideline 1: Do not supply default values
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank()) {
            return Collections.emptyList();
        }

        return shj0igQueryDslRepository.findDetailList(corpGr.trim(), jmCd.trim(), nowNo);
    }

    /**
     * PB 채번: 다음 종목코드 채번
     */
    public String getNextJmCd(String corpGr, String balhYmd, String cashCd) {
        if (corpGr == null || corpGr.isBlank()) {
            return "";
        }
        return shm0hjQueryDslRepository.getNextJmCd(corpGr.trim(), balhYmd, cashCd);
    }

    /**
     * Call procedure SR_SHJ0IG for generating period interest (JPA)
     */
    @Transactional
    public void generatePeriodInterest(String corpGr, String jmCd) {
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank()) {
            throw new IllegalArgumentException("회사코드와 종목코드가 올바르지 않습니다.");
        }

        log.info("Generating period interest for corpGr={}, jmCd={}", corpGr, jmCd);
        shm0hjQueryDslRepository.callSrShj0ig(corpGr.trim(), jmCd.trim(), "ok");
    }

    /**
     * Save SHM0HJ list (Insert, Update, Delete via JPA)
     */
    @Transactional
    public void saveShm0hj(com.kfp.aams.domain.dailyadvisory.dto.Shm0hjSaveRequestDto request) {
        if (request == null) return;
        String corpGr = request.getCorpGr();
        if (corpGr == null || corpGr.isBlank()) {
            throw new IllegalArgumentException("회사코드가 누락되었습니다.");
        }

        // 1. Delete
        if (request.getDeleteList() != null) {
            for (Shm0hjMasterDto dto : request.getDeleteList()) {
                if (dto.getJmCd() != null && !dto.getJmCd().isBlank()) {
                    shm0hjQueryDslRepository.deleteShm0hj(corpGr.trim(), dto.getJmCd().trim());
                }
            }
        }

        // 2. Insert
        if (request.getInsertList() != null) {
            for (Shm0hjMasterDto dto : request.getInsertList()) {
                dto.setCorpGr(corpGr.trim());
                if (dto.getJmCd() == null || dto.getJmCd().isBlank()) {
                    String nextCd = shm0hjQueryDslRepository.getNextJmCd(corpGr.trim(), dto.getBalhYmd(), dto.getCashCd());
                    dto.setJmCd(nextCd);
                }
                shm0hjQueryDslRepository.insertShm0hj(dto);
            }
        }

        // 3. Update
        if (request.getUpdateList() != null) {
            for (Shm0hjMasterDto dto : request.getUpdateList()) {
                dto.setCorpGr(corpGr.trim());
                shm0hjQueryDslRepository.updateShm0hj(dto);
            }
        }
    }
}
