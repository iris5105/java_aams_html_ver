package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja032o1 (SZT0IA_V + SZM0IA + USPM_PORT)
 * USPM 파생 환매수 펀드/포트 만기별 목록
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032oFundDto {

    private String corpGr;
    private String fundCd;

    private String xxFundCd;
    private String fundNm;

    public String getXxFundCd() {
        return xxFundCd != null ? xxFundCd : fundNm;
    }

    public void setXxFundCd(String xxFundCd) {
        this.xxFundCd = xxFundCd;
        if (this.fundNm == null) {
            this.fundNm = xxFundCd;
        }
    }

    public String getFundNm() {
        return fundNm != null ? fundNm : xxFundCd;
    }

    public void setFundNm(String fundNm) {
        this.fundNm = fundNm;
        if (this.xxFundCd == null) {
            this.xxFundCd = fundNm;
        }
    }

    private String trYmd;
    private BigDecimal wonbonAek;
    private BigDecimal usdWonbonAek;
    private BigDecimal jmPer;
    private BigDecimal yearBeta;
    private BigDecimal monBeta;
    private BigDecimal riskValue;
    private BigDecimal optPremium;
    private BigDecimal optNominalAmt;

    // USPM_PORT 필드
    private String fymd;
    private String tymd;
    private String portNum;
    private String tt;
    private Integer instDays;
    private String mangi;
    private Integer dt;
    private BigDecimal uspmPortUsdTuja;
    private BigDecimal uspmPortYearBeta;
    private BigDecimal uspmPortMonBeta;

    // 계산식: round(usd_wonbon_aek * jm_per / 100, 2)
    private BigDecimal usdTuja;

    // CUD 상태 플래그
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
}
