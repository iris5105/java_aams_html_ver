package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036j1Dto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036j1ImportDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja036j1Mapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class Ja036j1Service {
    private final Ja036j1Mapper ja036j1Mapper;

    @Transactional(readOnly = true)
    public List<Ja036j1Dto> getList(String corpGr, String ymd) {
        if (isBlank(corpGr) || isBlank(ymd)) return List.of();
        return ja036j1Mapper.selectList(corpGr.trim(), normalizeYmd(ymd));
    }

    @Transactional
    public int save(String corpGr, String ymd, List<Ja036j1Dto> rows) {
        if (isBlank(corpGr) || isBlank(ymd) || rows == null) return 0;
        int count = 0;
        String normalizedYmd = normalizeYmd(ymd);
        for (Ja036j1Dto row : rows) {
            if (row == null || isBlank(row.getYjCd())) continue;
            if (Boolean.TRUE.equals(row.getIsDeleted())) {
                count += ja036j1Mapper.deleteClose(corpGr, normalizedYmd, row.getYjCd().trim());
            } else if (Boolean.TRUE.equals(row.getIsNew()) || Boolean.TRUE.equals(row.getIsUpdated())) {
                validateStock(corpGr, row.getYjCd());
                row.setCorpGr(corpGr);
                row.setYmd(normalizedYmd);
                count += ja036j1Mapper.mergeClose(row);
            }
        }
        return count;
    }

    @Transactional
    public int importCloses(String corpGr, String ymd, List<Ja036j1ImportDto> rows) {
        if (isBlank(corpGr) || isBlank(ymd) || rows == null || rows.isEmpty()) return 0;
        int count = 0;
        String normalizedYmd = normalizeYmd(ymd);
        List<String> unknownCodes = new ArrayList<>();
        for (Ja036j1ImportDto row : rows) {
            if (row == null || isBlank(row.getLinkedCode()) || row.getClosePrice() == null) continue;
            String jmCd = row.getLinkedCode().trim();
            if (ja036j1Mapper.selectStockCode(corpGr, jmCd) == null) {
                unknownCodes.add(jmCd);
                continue;
            }
            validateStock(corpGr, jmCd);
            Ja036j1Dto close = new Ja036j1Dto();
            close.setCorpGr(corpGr);
            close.setYmd(normalizedYmd);
            close.setYjCd(jmCd);
            close.setJonga(row.getClosePrice());
            close.setDanga(java.math.BigDecimal.ZERO);
            count += ja036j1Mapper.mergeClose(close);
        }
        if (!unknownCodes.isEmpty()) {
            throw new IllegalArgumentException("등록되지 않은 종목코드가 있습니다: " + String.join(", ", unknownCodes));
        }
        if (count > 0) {
            ja036j1Mapper.touchSyt0lpLink();
        }
        return count;
    }

    private void validateStock(String corpGr, String yjCd) {
        if (ja036j1Mapper.selectStockCode(corpGr, yjCd.trim()) == null) {
            throw new IllegalArgumentException("종목코드를 확인하십시오: " + yjCd);
        }
    }

    private String normalizeYmd(String value) {
        String normalized = value.trim().replace(".", "-").replace("/", "-");
        if (normalized.matches("\\d{8}")) return normalized.substring(0, 4) + "-" + normalized.substring(4, 6) + "-" + normalized.substring(6, 8);
        return normalized;
    }

    private boolean isBlank(String value) { return value == null || value.isBlank(); }
}
