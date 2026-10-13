package com.kfp.aams.domain.usportfoliomodel.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja032a1 (SZT0IA_V + SZM0IA)
 * 펀드별 미국 포트폴리오 모델 마스터 목록
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032aMasterDto {

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
    private BigDecimal jmPer;
    private BigDecimal usdWonbonAek;
    private BigDecimal yearBeta;
    private BigDecimal monBeta;
    private BigDecimal riskValue;
    private BigDecimal fxSu;
    private BigDecimal fxAmt;
    private BigDecimal optPremium;
    private BigDecimal nominalAmt;
    private String del;
    private BigDecimal stockChui;
    private Integer pVisible;

    // 계산 필드: round(usd_wonbon_aek * jm_per / 100, 2)
    private BigDecimal usdTuja;

    // CUD 관리 플래그
    private Boolean isNew;
    private Boolean isUpdated;
    private String rowStatus;
}
