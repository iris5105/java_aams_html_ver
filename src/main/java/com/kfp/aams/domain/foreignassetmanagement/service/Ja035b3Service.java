package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035b3Dto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja035b3Mapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * W_JA035B3 해외선물 매매등록 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja035b3Service {

    private final Ja035b3Mapper mapper;

    @Transactional(readOnly = true)
    public List<Ja035b3Dto> getList(String corpGr, String ymd, String trCd) {
        return mapper.selectList(corpGr, ymd, trCd);
    }

    @Transactional(readOnly = true)
    public List<String> getHighlightDates(String corpGr, String trCd) {
        return mapper.selectHighlightDates(corpGr, trCd);
    }

    @Transactional(readOnly = true)
    public BigDecimal getUnitAek(String corpGr, String jmCd) {
        BigDecimal val = mapper.selectUnitAek(corpGr, jmCd);
        return val != null ? val : BigDecimal.ONE;
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getTrusteeInfo(String corpGr, String ymd, String trustee) {
        Map<String, Object> info = mapper.selectTrusteeInfo(corpGr, ymd, trustee);
        return info != null ? info : Map.of();
    }

    @Transactional(readOnly = true)
    public String getTrusteeBankCd(String corpGr, String trustee) {
        return mapper.selectTrusteeBankCd(corpGr, trustee);
    }

    @Transactional(readOnly = true)
    public String getSjGb(String trCd) {
        return mapper.selectSjGb(trCd);
    }

    @Transactional
    public int save(String corpGr, String ymd, String trCd, List<Ja035b3Dto> rows) {
        if (rows == null || rows.isEmpty()) {
            return 0;
        }
        Map<String, Long> maxSeqCache = new HashMap<>();
        int changed = 0;

        for (Ja035b3Dto row : rows) {
            if (row == null) continue;
            row.setCorpGr(corpGr);
            if (row.getTrYmd() == null || row.getTrYmd().isBlank()) {
                row.setTrYmd(ymd);
            }
            if (row.getTrCd() == null || row.getTrCd().isBlank()) {
                row.setTrCd(trCd);
            }
            if (row.getGyuljeYmd() == null || row.getGyuljeYmd().isBlank()) {
                row.setGyuljeYmd(row.getTrYmd());
            }

            boolean isDeleted = Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus());
            boolean isNew = Boolean.TRUE.equals(row.getIsNew()) || "C".equalsIgnoreCase(row.getRowStatus());
            boolean isUpdated = Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus());

            if (isDeleted) {
                changed += mapper.deleteSyt0mg(row);
            } else if (isNew) {
                if (row.getTrSeq() == null || row.getTrSeq() <= 0) {
                    String key = row.getTrYmd() + "|" + (row.getFundCd() == null ? "" : row.getFundCd());
                    Long nextSeq = maxSeqCache.computeIfAbsent(key, k -> {
                        Long cur = mapper.selectMaxTrSeq(corpGr, row.getTrYmd(), row.getFundCd());
                        return cur == null ? 0L : cur;
                    }) + 1L;
                    maxSeqCache.put(key, nextSeq);
                    row.setTrSeq(nextSeq);
                }
                changed += mapper.insertSyt0mg(row);
            } else if (isUpdated) {
                changed += mapper.updateSyt0mg(row);
            }
        }
        return changed;
    }
}
