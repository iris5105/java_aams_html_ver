package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010eDto;
import com.kfp.aams.domain.daily.mapper.Ja010eMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_ja010e (주식체결LOAD(입고))
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010eService {

    private final Ja010eMapper ja010eMapper;

    /**
     * Retrieve Stock Trading Load List (d_ja010e1.srd)
     */
    public List<Ja010eDto> getList(String corpGr, String trYmd, String trCoCd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trYmd.isBlank()) {
            return Collections.emptyList();
        }
        String coCd = (trCoCd != null && !trCoCd.isBlank() && !"%".equals(trCoCd.trim())) ? trCoCd.trim() : null;
        return ja010eMapper.selectJa010eList(corpGr.trim(), trYmd.trim(), coCd);
    }
}
