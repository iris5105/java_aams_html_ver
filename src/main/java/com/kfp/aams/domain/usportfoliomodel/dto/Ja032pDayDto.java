package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 기준정보 옵션종목 일별현황 (W_JA032P) - 옵션종목 일별추이 DTO (d_ja032p3.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032pDayDto {

    private String ymd;
    private String currency;
    private BigDecimal stockJonga;       // 주식종가 (syt0lp.stock_jonga)
    private BigDecimal jusu;             // 수량
    private BigDecimal impJonga;         // 종가
    private BigDecimal aek;              // 취득액
    private BigDecimal trPyungaAek;      // 평가금액
    private BigDecimal sonik;            // 매매손익
    private BigDecimal riskValue;        // 위험값합계
    private BigDecimal optNominalAmt;    // 명목금액
    private BigDecimal impVolatility;    // 내재변동성
    private BigDecimal delta;            // 델타
    private BigDecimal gamma;            // 감마
    private BigDecimal vega;             // 베가
    private BigDecimal deltaRiskValue;   // 델타위험값
    private BigDecimal gammaRiskValue;   // 감마위험값
    private BigDecimal vegaRiskValue;    // 베가위험값
    private String week;                 // 주차 (to_char(ymd, 'iw'))
}
