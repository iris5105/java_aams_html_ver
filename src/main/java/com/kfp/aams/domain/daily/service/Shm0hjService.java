package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Shj0igDetailDto;
import com.kfp.aams.domain.daily.dto.Shm0hjMasterDto;
import com.kfp.aams.domain.daily.mapper.Shm0hjMapper;
import com.kfp.aams.domain.daily.repository.Shj0igQueryDslRepository;
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
     * Call procedure SR_SHJ0IG for generating period interest
     */
    @Transactional
    public void generatePeriodInterest(String corpGr, String jmCd) {
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank()) {
            throw new IllegalArgumentException("회사코드와 종목코드가 올바르지 않습니다.");
        }

        log.info("Generating period interest for corpGr={}, jmCd={}", corpGr, jmCd);
        shm0hjMapper.callSrShj0ig(corpGr.trim(), jmCd.trim(), "ok");
    }
}
