package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * W_JA020F (권리보유 원장현황) 그리드 DTO (d_ja020f1.srd & KFP.SR_JA020F 1:1 매핑)
 */
@Getter
@Setter
@NoArgsConstructor
public class Ja020fDto {
    private String corpGr;
    private String corpNm;
    private String fundCd;
    private String fundNm;
    private String xxFundCd;
    private String koscomCd;
    private String jmCd;
    private String jjNm;
    private String balhCo;
    private String jmSort;
    private String gyulMm;
    private String jmType;
    private String bigo;
    private BigDecimal jusu;
    private BigDecimal aek;
    private BigDecimal gongsJusu;
    private BigDecimal gongsAek;
    private BigDecimal pyungaAek;
    private BigDecimal sonik;
    private BigDecimal daySonik;
    private BigDecimal bjonga;
    private BigDecimal joinga;
    private BigDecimal miAek;
    private BigDecimal aekm;
    private BigDecimal danga;
    private BigDecimal lockJusu;
    private BigDecimal gbjonga;
    private BigDecimal gjonga;
    private BigDecimal gaek;
    private BigDecimal gsonik;
    private BigDecimal gpyungaAek;
    private BigDecimal dayGsonik;
    private LocalDate ventureEnd;
    private BigDecimal jan;
    private Long fontColor;

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

