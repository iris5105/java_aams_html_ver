package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035jDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja035jMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * W_JA035J 수도결제 등록 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja035jService {

    private final Ja035jMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja035jDto> getList(String corpGr, String ymd) {
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
    public int save(String corpGr, List<Ja035jDto> rows) {
        if (rows == null || rows.isEmpty()) {
            return 0;
        }
        int updated = 0;
        for (Ja035jDto row : rows) {
            if (row == null) continue;
            row.setCorpGr(corpGr);
            if ("G33".equals(row.getTrCd())) {
                throw new IllegalArgumentException("유상납입은 2913 해외 주식권리등록에서 납입후 상장처리 해야 합니다.");
            }
            updated += mapper.updateSyt0ys(row);
        }
        return updated;
    }
}
