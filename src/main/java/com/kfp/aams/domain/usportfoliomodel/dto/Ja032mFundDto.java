package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 종목별 위험값 (W_JA032M) - 펀드 목록 DTO (d_ja032m1.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032mFundDto {

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
    private BigDecimal putPremium;
    private BigDecimal unSonik;

    // CUD 상태 플래그 (규정 02-3 표준)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    // 양방향 프로퍼티 표준 (Zero-Serialization-Loss, 규정 02-2)
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
