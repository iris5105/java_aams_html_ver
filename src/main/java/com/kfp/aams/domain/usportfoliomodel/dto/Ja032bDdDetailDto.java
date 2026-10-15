package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 기준정보 종목 일별현황 (W_JA032B_DD) - 종목 일별현황 DTO (d_ja032b_dd.srd / d_ja032b_dd_krx.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032bDdDetailDto {

    private String ymd;
    private BigDecimal jonga;          // 종가 (해외 syt0lp.jonga / 국내 sjt1tg.close)
    private BigDecimal jongaChgPct;    // 전일대비(%)
    private BigDecimal shortPrice;     // 단기(30) 평균가
    private BigDecimal gijunPrice;     // 기준(30) 평균가
    private BigDecimal d30Volatility;  // 단기(30) 변동성
    private BigDecimal g30Volatility;  // 기준(30) 변동성
    private BigDecimal tvol;           // 거래량 (volume)
    private BigDecimal tomv;           // 시가총액 (해외 tomv / 국내 value)
    private String week;
    private Boolean isKrx;             // KRX 국내 종목 여부

    // 해외 종목 전용 필드
    private BigDecimal ma50;           // 50일 이동평균
    private BigDecimal ma200;          // 200일 이동평균
    private BigDecimal chgPct5d;       // 5일 등락률
    private BigDecimal chgPct10d;      // 10일 등락률
    private BigDecimal chgPct15d;      // 15일 등락률
    private BigDecimal chgPct20d;      // 20일 등락률
}
