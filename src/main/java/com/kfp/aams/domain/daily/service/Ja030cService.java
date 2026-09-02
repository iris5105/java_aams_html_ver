package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja030cDto;
import com.kfp.aams.domain.daily.mapper.Ja030cMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_ja030c (채권 매매등록)
 * - Multi-table query on SCT0CG + SZM0IA + SCM0CJ via MyBatis (Guideline 4)
 * - Strictly adheres to Guideline 1 (no default value fallback)
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja030cService {

    private final Ja030cMapper ja030cMapper;

    public List<Ja030cDto> getJa030cList(String corpGr, String trYmd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trYmd.isBlank()) {
            return Collections.emptyList();
        }
        return ja030cMapper.selectJa030cList(corpGr.trim(), trYmd.trim());
    }
}
