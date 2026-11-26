package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036fDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja036fMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * W_JA036F 외화자산 조회 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja036fService {

    private final Ja036fMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja036fDto> getList(String corpGr, String ymd, String accountType) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        String resolvedType = "2".equals(accountType) ? "2" : "1";
        return mapper.selectList(corpGr.trim(), ymd.trim(), resolvedType);
    }
}
