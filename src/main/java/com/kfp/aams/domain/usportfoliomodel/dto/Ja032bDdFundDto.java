package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 기준정보 종목 일별현황 (W_JA032B_DD) - 펀드 목록 DTO (d_ja032n1.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032bDdFundDto {

    private String fundCd;
    private String fundNm;
    private String xxFundCd;
    private BigDecimal wonbonAek;
    private BigDecimal jmPer;
    private BigDecimal usdWonbonAek;
    private BigDecimal usdTuja;
    private BigDecimal jmSonik;
    private BigDecimal pgSonik;
    private BigDecimal pgPremium;
    private BigDecimal premium;
    private BigDecimal unSonik;

    // 양방향 프로퍼티 표준 (Zero-Serialization-Loss)
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
}
