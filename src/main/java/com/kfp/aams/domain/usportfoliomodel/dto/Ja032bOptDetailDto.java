package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 기준정보 옵션위험값 일별현황 (W_JA032B_OPT) - 옵션위험값 일별현황 상세 DTO (d_ja032b_opt.srd / d_ja032b_opt_krx.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032bOptDetailDto {

    private String corpGr;
    private String ymd;
    private String fundCd;
    private String jmCd;
    private String yjCd;
    private String port;
    private BigDecimal jonga;

    // 거래량 / 거래대금 (해외: lp.TVOL, lp.TOMV / 국내: tg.VOLUME, tg.VALUE)
    private BigDecimal tvol;
    private BigDecimal tomv;
    private BigDecimal volume;
    private BigDecimal value;

    // 수량 및 금액
    private BigDecimal stockJusu;        // 보유수량 (stock_jusu)
    private BigDecimal stockChui;        // 주식취득금액 (stock_chui)
    private BigDecimal optQty;           // 옵션보유수량 (opt_qty)
    private BigDecimal optNominalAmt;    // 옵션명목금액 (opt_nominal_amt)
    private BigDecimal optPremium;       // 옵션프리미엄 (opt_premium)
    private BigDecimal riskValue;        // 옵션위험값 (risk_value, 해외전용)

    // 부가 및 상태 플래그
    private Boolean isKrx;
    private Boolean isSummaryRow;

    // 거래량 통합 getter (해외/국내)
    public BigDecimal getDisplayVolume() {
        return Boolean.TRUE.equals(isKrx) ? volume : tvol;
    }
}
