package com.kfp.aams.domain.usportfoliomodel.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 펀드 일별현황 상세 DTO (d_ja032b_fund2.srd / SZT0IA_V)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032bFundDetailDto {
    private Integer fseq; // No. (계산/순번)

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate trYmd;
    private String trYmdStr; // YYYY-MM-DD 포맷 문자열

    private BigDecimal wonbonAek;     // 투자원본액
    private BigDecimal usdWonbonAek;  // 투자원본(USD)
    private BigDecimal jmPer;          // 종목비중(%)
    private BigDecimal usdTuja;        // 투자목표액(USD) - round(usd_wonbon_aek * jm_per / 100, 2)
    private BigDecimal yearBeta;       // 전략베타 1년
    private BigDecimal monBeta;        // 전략베타 1개월
    private BigDecimal riskValue;      // 펀드위험값
    private BigDecimal fxSu;           // 환(FX) 헷지수량
    private BigDecimal fxAmt;          // 환(FX) 헷지금액
    private BigDecimal optPremium;     // 옵션 프리미엄
    private BigDecimal optNominalAmt;  // 옵션 명목금액
    private String del;                // 삭제여부
    private Integer pVisible;
    private String week;               // 주차 (TO_CHAR(TR_YMD, 'iw'))
}
