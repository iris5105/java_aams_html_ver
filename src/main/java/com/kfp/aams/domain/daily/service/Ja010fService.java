package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010fDto;
import com.kfp.aams.domain.daily.mapper.Ja010fMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_ja010f (예수금잔액LOAD)
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010fService {

    private final Ja010fMapper ja010fMapper;

    /**
     * Retrieve Deposit Balance Load List (d_ja010f1.srd)
     */
    public List<Ja010fDto> getList(String corpGr, String trYmd, String trCoCd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trYmd.isBlank()) {
            return Collections.emptyList();
        }
        String coCd = (trCoCd != null && !trCoCd.isBlank() && !"%".equals(trCoCd.trim())) ? trCoCd.trim() : null;
        return ja010fMapper.selectJa010fList(corpGr.trim(), trYmd.trim(), coCd);
    }
}
