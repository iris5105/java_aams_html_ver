package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010aDetailDto;
import com.kfp.aams.domain.daily.dto.Ja010aMasterDto;
import com.kfp.aams.domain.daily.repository.Ja010aQueryDslRepository;
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
}
