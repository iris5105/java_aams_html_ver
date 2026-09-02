package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Szx0seDto;
import com.kfp.aams.domain.daily.repository.Szx0seQueryDslRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_szx0se (계좌관리그룹/상품그룹)
 * - Single-table query on SZX0SE via QueryDSL (Guideline 4)
 * - Strictly adheres to Guideline 1 (no default value fallback)
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Szx0seService {

    private final Szx0seQueryDslRepository szx0seQueryDslRepository;

    public List<Szx0seDto> getSzx0seList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return szx0seQueryDslRepository.findSzx0seList(corpGr.trim());
    }
}
