package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA032F 종목 일별 시세 내역 DTO (d_ja032f2)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032fDetailDto {
    private String corpGr;
    private String ymd;
    private String jmCd;
    private BigDecimal jonga;
    private BigDecimal danga;
    private String loadTime;
    private String pxCloseDt;
    private BigDecimal pxLast;
    private String pxDt1d;
    private BigDecimal pxClose1d;
    private BigDecimal pxYestCloseExchUnadj;
    private String blbgTckr;
    private String isinCd;
    private String currency;
    private BigDecimal hangsaGa;
    private BigDecimal bid;
    private BigDecimal ask;
    private BigDecimal timeGa;
    private BigDecimal tvol;
    private BigDecimal tamt;
    private BigDecimal shar;
    private BigDecimal tomv;
    private BigDecimal tRate;
    private String trdToDate;
    private String week;
}
