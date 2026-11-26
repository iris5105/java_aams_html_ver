package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036eDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja036eMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * W_JA036E 펀드별 배당내역(리포트) 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja036eService {

    private final Ja036eMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja036eDto> getList(String corpGr, String mgCd, String ymd) {
        String resolvedMgCd = (mgCd == null || mgCd.isBlank()) ? "%" : mgCd.trim();
        return mapper.selectList(corpGr, resolvedMgCd, ymd);
    }
}
