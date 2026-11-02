package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * W_JA020C (배당금/단주대금 입금) 그리드 DTO (d_ja020c1.srd 1:1 매핑)
 */
@Getter
@Setter
@NoArgsConstructor
public class Ja020cDto {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String fundCd;
    private String originalFundCd;
    private String jmCd;
    private String jmNm;
    private String originalJmCd;
    private String koscomCd;
    private BigDecimal hwakjAek;
    private BigDecimal suryAek;
    private BigDecimal danga;
    private BigDecimal chuiAek;
    private BigDecimal tax;
    private String typeTrench;
    private BigDecimal bsType;
    private BigDecimal susu;
    private String updUser;
    private String cyType;
    private LocalDate brokYmd;

    private String xxFundCd;
    private String fundNm;
    private String xxMgCd;
    private String mgCd;
    private BigDecimal xxBoyuJusu;
    private BigDecimal jangoJusu;
    private Integer pVisible;

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

    public String getXxMgCd() {
        return xxMgCd != null ? xxMgCd : mgCd;
    }

    public void setXxMgCd(String xxMgCd) {
        this.xxMgCd = xxMgCd;
        if (this.mgCd == null) {
            this.mgCd = xxMgCd;
        }
    }

    public String getMgCd() {
        return mgCd != null ? mgCd : xxMgCd;
    }

    public void setMgCd(String mgCd) {
        this.mgCd = mgCd;
        if (this.xxMgCd == null) {
            this.xxMgCd = mgCd;
        }
    }

    public BigDecimal getXxBoyuJusu() {
        return xxBoyuJusu != null ? xxBoyuJusu : jangoJusu;
    }

    public void setXxBoyuJusu(BigDecimal xxBoyuJusu) {
        this.xxBoyuJusu = xxBoyuJusu;
        if (this.jangoJusu == null) {
            this.jangoJusu = xxBoyuJusu;
        }
    }

    public BigDecimal getJangoJusu() {
        return jangoJusu != null ? jangoJusu : xxBoyuJusu;
    }

    public void setJangoJusu(BigDecimal jangoJusu) {
        this.jangoJusu = jangoJusu;
        if (this.xxBoyuJusu == null) {
            this.xxBoyuJusu = jangoJusu;
        }
    }
}

