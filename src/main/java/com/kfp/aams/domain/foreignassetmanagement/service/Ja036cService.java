package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036cDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja036cMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * W_JA036C 유상청약납입 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja036cService {

    private final Ja036cMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja036cDto> getList(String corpGr, String ymd) {
        return mapper.selectList(corpGr, ymd);
    }

    @Transactional(readOnly = true)
    public List<String> getHighlightDates(String corpGr) {
        return mapper.selectHighlightDates(corpGr);
    }

    @Transactional(readOnly = true)
    public String getDefaultGyuljeJmCd(String corpGr, String currency) {
        return mapper.selectDefaultGyuljeJmCd(corpGr, currency);
    }

    @Transactional
    public int save(String corpGr, List<Ja036cDto> rows) {
        if (rows == null || rows.isEmpty()) {
            return 0;
        }
        int updated = 0;
        for (Ja036cDto row : rows) {
            if (row == null) continue;
            row.setCorpGr(corpGr);
            updated += mapper.updateSyt0ys(row);
        }
        return updated;
    }
}
