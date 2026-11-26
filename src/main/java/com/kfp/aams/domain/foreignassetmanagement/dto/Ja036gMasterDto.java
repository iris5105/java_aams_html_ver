package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.Data;

/**
 * W_JA036G 마스터 목록 (d_ja036g1) DTO
 */
@Data
public class Ja036gMasterDto {

    private String fundCd;
    private String xxFundCd;
    private String fundNm;
    private String jmCd;
    private String xxJmCd;
    private String jmNm;
    private String jasanGb;
    private String currency;
    private String fundCurrency;

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

    public String getXxJmCd() {
        return xxJmCd != null ? xxJmCd : jmNm;
    }

    public void setXxJmCd(String xxJmCd) {
        this.xxJmCd = xxJmCd;
        if (this.jmNm == null) {
            this.jmNm = xxJmCd;
        }
    }

    public String getJmNm() {
        return jmNm != null ? jmNm : xxJmCd;
    }

    public void setJmNm(String jmNm) {
        this.jmNm = jmNm;
        if (this.xxJmCd == null) {
            this.xxJmCd = jmNm;
        }
    }
}
