package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010dDto;
import com.kfp.aams.domain.daily.mapper.Ja010dMapper;
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
}
