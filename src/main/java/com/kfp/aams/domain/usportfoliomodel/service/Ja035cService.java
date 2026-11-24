package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja035cDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja035cMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class Ja035cService {
    private final Ja035cMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja035cDto> getList(String corpGr, String ymd, String trCd) {
        return mapper.selectList(corpGr, ymd, trCd);
    }

    @Transactional(readOnly = true)
    public BigDecimal getCurrencyRate(String corpGr, String ymd, String currency) {
        return mapper.selectCurrencyRate(corpGr, ymd, currency);
    }

    @Transactional
    public int save(String corpGr, String ymd, String trCd, List<Ja035cDto> rows) {
        if (rows == null) return 0;
        Long maxSequence = mapper.selectMaxTrSeq(corpGr, ymd, trCd);
        long sequence = maxSequence == null ? 0L : maxSequence;
        int changed = 0;
        for (Ja035cDto row : rows) {
            if (row == null) continue;
            row.setCorpGr(corpGr);
            row.setTrYmd(ymd);
            row.setTrCd(trCd);
            if (row.getGyuljeYmd() == null || row.getGyuljeYmd().isBlank()) row.setGyuljeYmd(ymd);
            boolean deleted = Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus());
            boolean created = Boolean.TRUE.equals(row.getIsNew()) || "C".equalsIgnoreCase(row.getRowStatus());
            boolean updated = Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus());
            if (deleted) changed += mapper.delete(row);
            else if (created) { row.setTrSeq(++sequence); changed += mapper.insert(row); }
            else if (updated) changed += mapper.update(row);
        }
        return changed;
    }
}
