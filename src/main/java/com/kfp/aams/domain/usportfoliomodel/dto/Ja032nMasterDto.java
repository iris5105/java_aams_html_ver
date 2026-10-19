package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * 포트별 옵션수익실현현황 - 좌측 마스터 펀드 목록 DTO (d_ja032n1.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032nMasterDto {

    private String fundCd;
    private String xxFundCd;
    private String fundNm;

    private BigDecimal wonbonAek;
    private BigDecimal jmPer;
    private BigDecimal usdWonbonAek;

    private BigDecimal usdTuja;       // compute: round(usd_wonbon_aek * jm_per / 100, 2)
    private BigDecimal jmSonik;
    private BigDecimal pgSonik;
    private BigDecimal pgPremium;
    private BigDecimal premium;       // sonik.put_premium
    private BigDecimal unSonik;

    // 양방향 프로퍼티 바인딩 (Zero-Serialization-Loss)
    public String getXxFundCd() {
        return xxFundCd != null ? xxFundCd : fundNm;
    }

    public void setXxFundCd(String xxFundCd) {
        this.xxFundCd = xxFundCd;
        if (this.fundNm == null) this.fundNm = xxFundCd;
    }

    public String getFundNm() {
        return fundNm != null ? fundNm : xxFundCd;
    }

    public void setFundNm(String fundNm) {
        this.fundNm = fundNm;
        if (this.xxFundCd == null) this.xxFundCd = fundNm;
    }

    // 투자목표액(USD) 계산 게터
    public BigDecimal getUsdTuja() {
        if (usdTuja != null) return usdTuja;
        if (usdWonbonAek != null && jmPer != null) {
            return usdWonbonAek.multiply(jmPer).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        }
        return BigDecimal.ZERO;
    }
}
