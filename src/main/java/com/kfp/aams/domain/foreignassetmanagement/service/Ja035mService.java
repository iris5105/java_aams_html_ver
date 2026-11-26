package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035mDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja035mMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * W_JA035M 해외보관처수익등록 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja035mService {

    private final Ja035mMapper mapper;
    private final WorkDateService workDateService;

    @Transactional(readOnly = true)
    public List<Ja035mDto> getList(String corpGr, String ymd, String trCd) {
        List<Ja035mDto> rows = mapper.selectList(corpGr, ymd, trCd);
        if (rows != null && !rows.isEmpty()) {
            return rows;
        }

        // w_ja035m.srw dw_list::retrieveend: 조회 0건 && ymd >= workDate && trCd != 'E72' 시 당일 SYT0MC 기준 자동생성
        String workDate = workDateService.getWorkDateOrDefault(corpGr);
        boolean canManage = workDate == null || workDate.isBlank() || ymd.compareTo(workDate) >= 0;
        if (!canManage || "E72".equalsIgnoreCase(trCd)) {
            return rows != null ? rows : List.of();
        }
        if (!"H21".equalsIgnoreCase(trCd) && !"H22".equalsIgnoreCase(trCd)) {
            return List.of();
        }

        List<Map<String, Object>> candidates = mapper.selectAutoCreateRows(corpGr, ymd, trCd);
        if (candidates == null || candidates.isEmpty()) {
            return List.of();
        }

        String defaultGyuljeYmd = (workDate != null && !workDate.isBlank()) ? workDate : ymd;
        List<Ja035mDto> generated = new ArrayList<>(candidates.size());
        for (Map<String, Object> c : candidates) {
            BigDecimal balAek = dec(c.get("balAek"), c.get("BALAEK"));
            BigDecimal wonBalAek = dec(c.get("wonBalAek"), c.get("WONBALAEK"));

            generated.add(Ja035mDto.builder()
                    .corpGr(corpGr)
                    .trYmd(ymd)
                    .trCd(trCd)
                    .fundCd(str(c.get("fundCd"), c.get("FUNDCD")))
                    .xxFundCd(str(c.get("fundNm"), c.get("FUNDNM")))
                    .trustee(str(c.get("trustee"), c.get("TRUSTEE")))
                    .currency(str(c.get("currency"), c.get("CURRENCY")))
                    .fundCurrency(str(c.get("fundCurrency"), c.get("FUNDCURRENCY")))
                    .trSeq(1L)
                    .gyuljeYmd(defaultGyuljeYmd)
                    .balAek(balAek)
                    .wonBalAek(wonBalAek)
                    .trAek(balAek)
                    .pVisible(1)
                    .isNew(true)
                    .rowStatus("C")
                    .build());
        }
        return generated;
    }

    @Transactional(readOnly = true)
    public List<String> getHighlightDates(String corpGr) {
        return mapper.selectHighlightDates(corpGr);
    }

    @Transactional(readOnly = true)
    public String getTrusteeCurrency(String corpGr, String trustee) {
        if (trustee == null || trustee.isBlank()) {
            return "";
        }
        String currency = mapper.selectTrusteeCurrency(corpGr, trustee);
        return currency != null ? currency.trim() : "";
    }

    @Transactional(readOnly = true)
    public BigDecimal getGijunRt(String corpGr, String ymd, String currency) {
        if (ymd == null || ymd.isBlank() || currency == null || currency.isBlank()) {
            return BigDecimal.ZERO;
        }
        BigDecimal rt = mapper.selectGijunRt(corpGr, ymd, currency);
        return rt != null ? rt : BigDecimal.ZERO;
    }

    @Transactional
    public int save(String corpGr, String ymd, String trCd, List<Ja035mDto> rows) {
        if (rows == null || rows.isEmpty()) {
            return 0;
        }
        int changed = 0;

        for (Ja035mDto row : rows) {
            if (row == null) continue;
            row.setCorpGr(corpGr);
            if (row.getTrYmd() == null || row.getTrYmd().isBlank()) row.setTrYmd(ymd);
            if (row.getTrCd() == null || row.getTrCd().isBlank()) row.setTrCd(trCd);
            if (row.getGyuljeYmd() == null || row.getGyuljeYmd().isBlank()) row.setGyuljeYmd(row.getTrYmd());
            if (row.getTrSeq() == null || row.getTrSeq() <= 0) row.setTrSeq(1L);

            boolean isDeleted = Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus());
            boolean isNew = Boolean.TRUE.equals(row.getIsNew()) || "C".equalsIgnoreCase(row.getRowStatus());
            boolean isUpdated = Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus());

            if (isDeleted) {
                changed += mapper.deleteSyt0ma(row);
            } else if (isNew) {
                changed += mapper.insertSyt0ma(row);
            } else if (isUpdated) {
                changed += mapper.updateSyt0ma(row);
            }
        }
        return changed;
    }

    private String str(Object primary, Object secondary) {
        Object v = primary != null ? primary : secondary;
        return v != null ? String.valueOf(v).trim() : "";
    }

    private BigDecimal dec(Object primary, Object secondary) {
        Object v = primary != null ? primary : secondary;
        if (v == null) return BigDecimal.ZERO;
        if (v instanceof BigDecimal bd) return bd;
        return new BigDecimal(String.valueOf(v));
    }
}
