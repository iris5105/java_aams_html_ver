package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036gDetailDto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036gMasterDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja036gMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * W_JA036G 외화자산 보유현황(종목/기간별) 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja036gService {

    private final Ja036gMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja036gMasterDto> getMasterList(String corpGr, String fYmd, String tYmd) {
        if (corpGr == null || corpGr.isBlank() || fYmd == null || fYmd.isBlank() || tYmd == null || tYmd.isBlank()) {
            return Collections.emptyList();
        }
        return mapper.selectMasterList(corpGr.trim(), fYmd.trim(), tYmd.trim());
    }

    @Transactional(readOnly = true)
    public List<Ja036gDetailDto> getDetailList(String corpGr, String fYmd, String tYmd, String fundCd, String jmCd) {
        if (corpGr == null || corpGr.isBlank()
                || fYmd == null || fYmd.isBlank()
                || tYmd == null || tYmd.isBlank()
                || fundCd == null || fundCd.isBlank()
                || jmCd == null || jmCd.isBlank()) {
            return Collections.emptyList();
        }
        return mapper.selectDetailList(corpGr.trim(), fYmd.trim(), tYmd.trim(), fundCd.trim(), jmCd.trim());
    }
}
