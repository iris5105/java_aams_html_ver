package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035hDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja035hMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * W_JA035H 외화 NOTE이자수령 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja035hService {

    private final Ja035hMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja035hDto> getList(String corpGr, String ymd) {
        return mapper.selectList(corpGr, ymd);
    }

    @Transactional(readOnly = true)
    public List<String> getHighlightDates(String corpGr) {
        return mapper.selectHighlightDates(corpGr);
    }

    @Transactional(readOnly = true)
    public BigDecimal getCurrencyRt(String corpGr, String ymd, String currency) {
        BigDecimal rt = mapper.selectCurrencyRt(corpGr, ymd, currency);
        return rt != null ? rt : BigDecimal.ZERO;
    }

    @Transactional(readOnly = true)
    public Map<String, String> getItemInfo(String corpGr, String yjCd, String currency) {
        String resolvedCur = (currency != null && !currency.isBlank()) ? currency.trim() : "";
        if (resolvedCur.isEmpty() && yjCd != null && !yjCd.isBlank()) {
            String itemCur = mapper.selectItemCurrency(corpGr, yjCd);
            if (itemCur != null) resolvedCur = itemCur.trim();
        }
        if (!resolvedCur.isEmpty()) {
            String trusteeCur = mapper.selectTrusteeCurrency(corpGr, resolvedCur);
            if (trusteeCur != null && !trusteeCur.isBlank()) {
                resolvedCur = trusteeCur.trim();
            }
        }
        String gyuljeJmCd = !resolvedCur.isEmpty() ? mapper.selectDefaultGyuljeJmCd(corpGr, resolvedCur) : "";
        String trustee = !resolvedCur.isEmpty() ? resolvedCur + "01" : "";
        return Map.of(
                "currency", resolvedCur,
                "trustee", trustee,
                "gyuljeJmCd", gyuljeJmCd != null ? gyuljeJmCd : ""
        );
    }

    @Transactional(readOnly = true)
    public Map<String, String> getTrusteeInfo(String corpGr, String trustee) {
        String cur = (trustee != null && !trustee.isBlank()) ? mapper.selectTrusteeCurrency(corpGr, trustee) : "";
        if (cur == null) cur = "";
        String gyuljeJmCd = !cur.isBlank() ? mapper.selectDefaultGyuljeJmCd(corpGr, cur) : "";
        return Map.of(
                "currency", cur,
                "gyuljeJmCd", gyuljeJmCd != null ? gyuljeJmCd : ""
        );
    }

    @Transactional
    public int save(String corpGr, String ymd, List<Ja035hDto> rows) {
        if (rows == null || rows.isEmpty()) {
            return 0;
        }
        Map<String, Long> maxSeqCache = new HashMap<>();
        int changed = 0;

        for (Ja035hDto row : rows) {
            if (row == null) continue;
            row.setCorpGr(corpGr);
            if (row.getYmd() == null || row.getYmd().isBlank()) row.setYmd(ymd);
            if (row.getTrYmd() == null || row.getTrYmd().isBlank()) row.setTrYmd(row.getYmd());
            if (row.getGyuljeYmd() == null || row.getGyuljeYmd().isBlank()) row.setGyuljeYmd(row.getYmd());
            if (row.getTrCd() == null || row.getTrCd().isBlank()) row.setTrCd("E2P");
            if (row.getBsType() == null) row.setBsType(0L);

            boolean isDeleted = Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus());
            boolean isNew = Boolean.TRUE.equals(row.getIsNew()) || "C".equalsIgnoreCase(row.getRowStatus());
            boolean isUpdated = Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus());

            if (isDeleted) {
                changed += mapper.deleteSyt0ys(row);
            } else if (isNew) {
                if (row.getTrSeq() == null || row.getTrSeq() <= 0) {
                    String key = row.getYmd() + "|" + (row.getFundCd() == null ? "" : row.getFundCd());
                    Long nextSeq = maxSeqCache.computeIfAbsent(key, k -> {
                        Long cur = mapper.selectMaxTrSeq(corpGr, row.getYmd(), row.getFundCd());
                        return cur == null ? 0L : cur;
                    }) + 1L;
                    maxSeqCache.put(key, nextSeq);
                    row.setTrSeq(nextSeq);
                }
                changed += mapper.insertSyt0ys(row);
            } else if (isUpdated) {
                changed += mapper.updateSyt0ys(row);
            }
        }
        return changed;
    }
}
