package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.Data;

import java.math.BigDecimal;

/**
 * W_JA036F 외화자산 조회 (d_ja036f1 / d_ja036f1_krw / d_ja036f2 / d_ja036f2_krw) DTO
 */
@Data
public class Ja036fDto {

    private String corpGr;
    private String ymd;
    private String fundCd;
    private String trustee;
    private String jmCd;
    private String currency;

    private BigDecimal trBfilJusu;
    private BigDecimal trUpJusu;
    private BigDecimal trDwJusu;

    private BigDecimal trBfilChuiAek;
    private BigDecimal trUpChuiAek;
    private BigDecimal trDwChuiAek;
    private BigDecimal trPyungaAek;

    private BigDecimal fcurBfilChuiAek;
    private BigDecimal fcurUpChuiAek;
    private BigDecimal fcurDwChuiAek;

    private BigDecimal wonBfilChuiAek;
    private BigDecimal wonUpChuiAek;
    private BigDecimal wonDwChuiAek;

    private BigDecimal bfilSungCost;
    private BigDecimal sungCost;

    private BigDecimal fcurBfilSungCost;
    private BigDecimal fcurSungCost;

    private BigDecimal wonBfilSungCost;
    private BigDecimal wonSungCost;

    private BigDecimal bfilMisuIja;
    private BigDecimal misuIja;

    private BigDecimal fcurPyungaAek;
    private BigDecimal fcurPyungaSonik;
    private BigDecimal fcurHwanCha;

    private BigDecimal wonPyungaAek;
    private BigDecimal wonPyungaSonik;
    private BigDecimal wonHwanCha;

    private String jmNm;
    private String jasanGb;
    private String jasanNm;
    private String fundNm;
    private String xxFundCd;
    private Integer bsType;
    private String smTrGb;
    private String fundCurrency;

    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

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
