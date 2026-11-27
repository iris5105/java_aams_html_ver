package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035rDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja035rMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * W_JA035R 외화주식 종목등록 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja035rService {

    private final Ja035rMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja035rDto> getList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return mapper.selectList(corpGr.trim());
    }

    @Transactional(readOnly = true)
    public String getCurrencyByNation(String nationCd) {
        if (nationCd == null || nationCd.isBlank()) {
            return "";
        }
        String cur = mapper.selectCurrencyByNation(nationCd.trim().toUpperCase());
        return cur != null ? cur.trim() : "";
    }

    @Transactional(readOnly = true)
    public String getNationByCurrency(String currency) {
        if (currency == null || currency.isBlank()) {
            return "";
        }
        String nation = mapper.selectNationByCurrency(currency.trim().toUpperCase());
        return nation != null ? nation.trim() : "";
    }

    @Transactional(readOnly = true)
    public Map<String, String> resolveExchangeInfo(String stockGb) {
        Map<String, String> result = new HashMap<>();
        if (stockGb == null || stockGb.isBlank()) {
            result.put("balhNation", "");
            result.put("currency", "");
            return result;
        }
        String nation = mapper.selectNationByStockGb(stockGb.trim().toUpperCase());
        String resolvedNation = nation != null ? nation.trim() : "";
        String resolvedCurrency = "";
        if (!resolvedNation.isEmpty()) {
            resolvedCurrency = getCurrencyByNation(resolvedNation);
        }
        result.put("balhNation", resolvedNation);
        result.put("currency", resolvedCurrency);
        return result;
    }

    @Transactional
    public int saveAll(String corpGr, List<Ja035rDto> items) {
        if (corpGr == null || corpGr.isBlank() || items == null || items.isEmpty()) {
            return 0;
        }
        String resolvedCorpGr = corpGr.trim();
        int count = 0;

        for (Ja035rDto item : items) {
            if (item == null) continue;
            item.setCorpGr(resolvedCorpGr);
            if (item.getJasanGb() == null || item.getJasanGb().isBlank()) {
                item.setJasanGb("1");
            }
            if (item.getJsJongryu() == null || item.getJsJongryu().isBlank()) {
                item.setJsJongryu("1");
            }

            boolean isDeleted = Boolean.TRUE.equals(item.getIsDeleted()) || "D".equalsIgnoreCase(item.getRowStatus());
            boolean isNew = Boolean.TRUE.equals(item.getIsNew()) || "C".equalsIgnoreCase(item.getRowStatus());
            boolean isUpdated = Boolean.TRUE.equals(item.getIsUpdated()) || "U".equalsIgnoreCase(item.getRowStatus());

            if (isDeleted) {
                if (item.getJmCd() != null && !item.getJmCd().isBlank()) {
                    count += mapper.deleteItem(resolvedCorpGr, item.getJmCd().trim(), item.getJasanGb());
                }
            } else if (isNew) {
                if (item.getJmCd() != null && !item.getJmCd().isBlank()) {
                    item.setJmCd(item.getJmCd().trim());
                    count += mapper.insertItem(item);
                }
            } else if (isUpdated) {
                if (item.getJmCd() != null && !item.getJmCd().isBlank()) {
                    item.setJmCd(item.getJmCd().trim());
                    count += mapper.updateItem(item);
                }
            }
        }
        return count;
    }
}
