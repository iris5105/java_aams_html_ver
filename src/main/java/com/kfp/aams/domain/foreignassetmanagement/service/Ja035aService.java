package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035aDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja035aMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * W_JA035A 외화 단기유동자산 종목 등록 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja035aService {

    private final Ja035aMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja035aDto> getList(String corpGr) {
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
    public String generateJmCd(String balhNation, String balhYmd, String jasanGb, Integer seqNo) {
        if (balhNation == null || balhNation.isBlank() || balhYmd == null || balhYmd.isBlank()) {
            return "";
        }
        String digits = balhYmd.replaceAll("[^0-9]", "");
        if (digits.length() < 8) {
            return "";
        }
        String yyyy = digits.substring(0, 4);
        String mm = digits.substring(4, 6);
        String dd = digits.substring(6, 8);

        String yyCode = mapper.selectIdDaeCd("Y", yyyy);
        String mmCode = mapper.selectIdDaeCd("M", mm);
        if (yyCode == null || yyCode.isBlank()) yyCode = "?";
        if (mmCode == null || mmCode.isBlank()) mmCode = "?";

        String gb = (jasanGb == null || jasanGb.isBlank()) ? "5" : jasanGb.trim();
        int seq = seqNo != null ? seqNo : 1;
        String seqStr = String.format("%03d", Math.max(0, seq));
        String base = balhNation.trim().toUpperCase() + "9" + yyCode.trim() + mmCode.trim() + dd + gb + seqStr;
        return appendCheckDigit(base);
    }

    @Transactional
    public int saveAll(String corpGr, List<Ja035aDto> items) {
        if (corpGr == null || corpGr.isBlank() || items == null || items.isEmpty()) {
            return 0;
        }
        String resolvedCorpGr = corpGr.trim();
        int count = 0;

        for (Ja035aDto item : items) {
            if (item == null) continue;
            item.setCorpGr(resolvedCorpGr);
            if (item.getJasanGb() == null || item.getJasanGb().isBlank()) {
                item.setJasanGb("5");
            }

            boolean isDeleted = Boolean.TRUE.equals(item.getIsDeleted()) || "D".equalsIgnoreCase(item.getRowStatus());
            boolean isNew = Boolean.TRUE.equals(item.getIsNew()) || "C".equalsIgnoreCase(item.getRowStatus());
            boolean isUpdated = Boolean.TRUE.equals(item.getIsUpdated()) || "U".equalsIgnoreCase(item.getRowStatus());

            if (isDeleted) {
                if (item.getJmCd() != null && !item.getJmCd().isBlank()) {
                    count += mapper.deleteItem(resolvedCorpGr, item.getJmCd().trim(), item.getJasanGb());
                }
            } else if (isNew) {
                if (item.getJmCd() == null || item.getJmCd().isBlank()) {
                    String gen = generateJmCd(item.getBalhNation(), item.getBalhYmd(), item.getJasanGb(), item.getSeqNo());
                    item.setJmCd(gen);
                    if (item.getSedol() == null || item.getSedol().isBlank()) {
                        item.setSedol(gen);
                    }
                }
                count += mapper.insertItem(item);
            } else if (isUpdated) {
                count += mapper.updateItem(item);
            }
        }
        return count;
    }

    /**
     * PB f_jm_check 동일 로직 (ISIN 체크디지트 산출)
     */
    private String appendCheckDigit(String raw) {
        StringBuilder converted = new StringBuilder();
        for (int i = 0; i < raw.length(); i++) {
            char ch = Character.toUpperCase(raw.charAt(i));
            if (ch >= '0' && ch <= '9') {
                converted.append(ch);
            } else if (ch >= 'A' && ch <= 'Z') {
                converted.append((int) ch - 55);
            } else {
                return raw;
            }
        }

        StringBuilder weighted = new StringBuilder();
        int flag = 1;
        for (int i = converted.length() - 1; i >= 0; i--) {
            flag = (flag == 2) ? 1 : 2;
            int digit = converted.charAt(i) - '0';
            weighted.insert(0, digit * flag);
        }

        int sum = 0;
        for (int i = 0; i < weighted.length(); i++) {
            sum += weighted.charAt(i) - '0';
        }
        int checkDigit = (10 - (sum % 10)) % 10;
        return raw + checkDigit;
    }
}
