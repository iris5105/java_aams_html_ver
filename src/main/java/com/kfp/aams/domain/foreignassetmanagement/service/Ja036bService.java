package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036bDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja036bMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * W_JA036B 외화배당금 수령등록 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja036bService {

    private final Ja036bMapper mapper;
    private final WorkDateService workDateService;

    @Transactional(readOnly = true)
    public List<Ja036bDto> getList(String corpGr, String ymd) {
        return mapper.selectList(corpGr, ymd);
    }

    @Transactional(readOnly = true)
    public List<String> getHighlightDates(String corpGr) {
        return mapper.selectHighlightDates(corpGr);
    }

    @Transactional(readOnly = true)
    public String getDefaultGyuljeJmCd(String corpGr, String currency) {
        if (currency == null || currency.isBlank()) {
            return "";
        }
        String jmCd = mapper.selectDefaultGyuljeJmCd(corpGr, currency.trim());
        return jmCd != null ? jmCd.trim() : "";
    }

    @Transactional
    public int save(String corpGr, List<Ja036bDto> rows) {
        if (rows == null || rows.isEmpty()) {
            return 0;
        }
        String workDate = workDateService.getWorkDateOrDefault(corpGr);
        int changed = 0;

        for (Ja036bDto row : rows) {
            if (row == null) continue;
            boolean isUpdated = Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus());
            if (!isUpdated) continue;

            row.setCorpGr(corpGr);
            changed += mapper.updateSyt0ygPyunga(row);

            if (row.getYgRowid() != null && !row.getYgRowid().isBlank()) {
                String targetYmd = (row.getChuriYmd() != null && !row.getChuriYmd().isBlank()) ? workDate : null;
                mapper.updateSyt0ygChuriYmd(row.getYgRowid(), targetYmd);
            }
        }
        return changed;
    }
}
