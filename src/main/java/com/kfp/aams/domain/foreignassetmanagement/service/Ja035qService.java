package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035qDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja035qMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * W_JA035Q 미지급/미수금 이월내역 관리 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja035qService {

    private final Ja035qMapper mapper;
    private final WorkDateService workDateService;

    @Transactional(readOnly = true)
    public List<Ja035qDto> getList(String corpGr, String ymd) {
        String workDate = workDateService.getWorkDateOrDefault(corpGr);
        return mapper.selectList(corpGr, ymd, workDate);
    }

    @Transactional(readOnly = true)
    public List<String> getHighlightDates(String corpGr) {
        return mapper.selectHighlightDates(corpGr);
    }

    @Transactional
    public int save(String corpGr, List<Ja035qDto> rows) {
        if (rows == null || rows.isEmpty()) {
            return 0;
        }
        int changed = 0;

        for (Ja035qDto row : rows) {
            if (row == null) continue;
            row.setCorpGr(corpGr);

            boolean isDeleted = Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus());
            boolean isUpdated = Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus());

            if (isDeleted) {
                changed += mapper.deleteSyt0mc(row);
            } else if (isUpdated) {
                changed += mapper.updateSyt0mc(row);
            }
        }
        return changed;
    }
}
