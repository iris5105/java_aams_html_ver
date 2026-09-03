package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja020nSigaDto;
import com.kfp.aams.domain.daily.dto.Ja020nStatusDto;
import com.kfp.aams.domain.daily.dto.Ja020nTrDto;
import com.kfp.aams.domain.daily.mapper.Ja020nMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_ja020n (국내 체결/잔고 엑셀자료 LOAD)
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja020nService {

    private final Ja020nMapper ja020nMapper;

    /**
     * Retrieve Load Status list (d_ja020n.srd)
     */
    public List<Ja020nStatusDto> getStatusList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja020nMapper.selectStatusList(corpGr.trim(), ymd.trim());
    }

    /**
     * Retrieve Loaded Balance / Siga list (d_ja020n_siga.srd)
     */
    public List<Ja020nSigaDto> getSigaList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja020nMapper.selectSigaList(corpGr.trim(), ymd.trim());
    }

    /**
     * Retrieve Loaded Execution / Tr list (d_ja020n_tr.srd)
     */
    public List<Ja020nTrDto> getTrList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja020nMapper.selectTrList(corpGr.trim(), ymd.trim());
    }
}
