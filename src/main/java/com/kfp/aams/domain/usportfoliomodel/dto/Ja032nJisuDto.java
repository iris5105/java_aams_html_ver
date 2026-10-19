package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * 포트별 옵션수익실현현황 - 우측 상단 지수 및 펀드 수익률 요약 DTO (d_ja032n3.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032nJisuDto {

    private String jisuYmd;
    private String today;

    private BigDecimal spxStart;
    private BigDecimal spxToday;
    private BigDecimal ndxStart;
    private BigDecimal ndxToday;
    private BigDecimal fundStart;
    private BigDecimal fundToday;

    private BigDecimal spxRt;     // (spx_today / spx_start) - 1
    private BigDecimal ndxRt;     // (ndx_today / ndx_start) - 1
    private BigDecimal fundRt;    // (fund_today / fund_start) - 1

    private BigDecimal jisuRt;     // (spx_rt * 0.5) + (ndx_rt * 0.5)
    private BigDecimal sangdaeRt; // fund_rt - jisu_rt

    public BigDecimal getJisuRt() {
        if (jisuRt != null) return jisuRt;
        BigDecimal s = spxRt != null ? spxRt : BigDecimal.ZERO;
        BigDecimal n = ndxRt != null ? ndxRt : BigDecimal.ZERO;
        return s.multiply(BigDecimal.valueOf(0.5)).add(n.multiply(BigDecimal.valueOf(0.5)));
    }

    public BigDecimal getSangdaeRt() {
        if (sangdaeRt != null) return sangdaeRt;
        BigDecimal f = fundRt != null ? fundRt : BigDecimal.ZERO;
        return f.subtract(getJisuRt());
    }
}
