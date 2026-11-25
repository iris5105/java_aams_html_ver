package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036jDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja036jMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class Ja036jService {
    private final Ja036jMapper ja036jMapper;

    @Transactional(readOnly = true)
    public List<Ja036jDto> getList(String corpGr, String ymd, String jasanGb) {
        if (isBlank(corpGr) || isBlank(ymd)) return List.of();
        return ja036jMapper.selectList(corpGr.trim(), normalizeYmd(ymd), normalizeJasanGb(jasanGb));
    }

    @Transactional
    public int save(String corpGr, String ymd, String jasanGb, List<Ja036jDto> rows) {
        if (isBlank(corpGr) || isBlank(ymd) || rows == null) return 0;
        String normalizedYmd = normalizeYmd(ymd);
        String normalizedJasanGb = normalizeJasanGb(jasanGb);
        int count = 0;
        for (Ja036jDto row : rows) {
            if (row == null || isBlank(row.getYjCd())) continue;
            String yjCd = row.getYjCd().trim();
            if (Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus())) {
                count += ja036jMapper.deleteClose(corpGr.trim(), normalizedYmd, yjCd);
                continue;
            }
            if (Boolean.TRUE.equals(row.getIsNew()) || Boolean.TRUE.equals(row.getIsUpdated())
                    || "C".equalsIgnoreCase(row.getRowStatus()) || "U".equalsIgnoreCase(row.getRowStatus())) {
                if (ja036jMapper.selectSecurityCode(corpGr.trim(), yjCd, normalizedJasanGb) == null) {
                    throw new IllegalArgumentException("자산분류에 맞는 종목코드를 확인하십시오: " + yjCd);
                }
                row.setCorpGr(corpGr.trim());
                row.setYmd(normalizedYmd);
                row.setJasanGb(normalizedJasanGb);
                row.setYjCd(yjCd);
                count += ja036jMapper.mergeClose(row);
            }
        }
        return count;
    }

    private String normalizeJasanGb(String value) {
        if ("2".equals(value) || "A".equalsIgnoreCase(value)) return value.toUpperCase();
        return "1";
    }

    private String normalizeYmd(String value) {
        String normalized = value.trim().replace(".", "-").replace("/", "-");
        if (normalized.matches("\\d{8}")) return normalized.substring(0, 4) + "-" + normalized.substring(4, 6) + "-" + normalized.substring(6, 8);
        return normalized;
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}
