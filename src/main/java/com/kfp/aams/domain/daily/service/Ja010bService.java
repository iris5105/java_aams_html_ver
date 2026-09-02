package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010bDetailDto;
import com.kfp.aams.domain.daily.dto.Ja010bIoDto;
import com.kfp.aams.domain.daily.dto.Ja010bMasterDto;
import com.kfp.aams.domain.daily.mapper.Ja010bMapper;
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
}
