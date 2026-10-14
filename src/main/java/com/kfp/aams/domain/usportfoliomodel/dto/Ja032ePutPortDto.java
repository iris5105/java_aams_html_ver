package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja032e2_put (USPM + USPM_PORT + USPM_OPT + SYM0YA + SYM0YZ)
 * 포트 내 종목 설정 및 현황 목록
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032ePutPortDto {
    private String corpGr;
    private String ymd;
    private String fundCd;
    private String portNum;
    private String yjCd;
    private String srsCd;
    private String xxYjCd;
    private String jmNm;
    private Integer col;
    private BigDecimal jonga;
    private BigDecimal putPrice;
    private BigDecimal targetReturnPer;
    private BigDecimal usdTuja;
    private BigDecimal moAmt;
    private Integer instDays;
    private BigDecimal minJusu;
    private String fymd;
    private String currency;
    private BigDecimal optQty;
    private BigDecimal optNominalAmt;
    private BigDecimal optPremium;
    private BigDecimal riskValue;
    private String lineColor;

    // Summary 행 여부
    private Boolean isSummaryRow;

    // CUD 및 UI 상태
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public String getXxYjCd() {
        return xxYjCd != null ? xxYjCd : jmNm;
    }

    public void setXxYjCd(String xxYjCd) {
        this.xxYjCd = xxYjCd;
        if (this.jmNm == null) this.jmNm = xxYjCd;
    }

    public String getJmNm() {
        return jmNm != null ? jmNm : xxYjCd;
    }

    public void setJmNm(String jmNm) {
        this.jmNm = jmNm;
        if (this.xxYjCd == null) this.xxYjCd = jmNm;
    }
}
