package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja021cDetailDto {

    private String corpGr;
    private String corpNm;
    private String szx0aaCorpNm;
    private String ymd;
    private String balhCo;

    private String fundCd;
    private String fundNm;

    private String oldJmCd;
    private String newJmCd;

    private BigDecimal boyuJusu;
    private BigDecimal boyuChuiAek;
    private BigDecimal baedBuIlsu;
    private BigDecimal brokJusu;

    private BigDecimal yesaJusu;
    private BigDecimal danga;
    private BigDecimal yesaAek;

    private String hwakjYmd;
    private BigDecimal hwakjJusu;
    private BigDecimal hwakjAek;

    private String juchongYmd;
    private BigDecimal juchongJusu;
    private BigDecimal juchongAek;

    private String suryYmd;
    private BigDecimal suryJuAek;
    private String surySet;

    private String delYn;
    private String delYmd;

    private String oldJmCd553;
    private String newJmCd553;

    private String haejiFund;
    private String haejiYmd;
    private String typeTrench;
    private BigDecimal bsType;

    public String getCorpNm() {
        return corpNm != null ? corpNm : szx0aaCorpNm;
    }

    public void setCorpNm(String corpNm) {
        this.corpNm = corpNm;
        if (this.szx0aaCorpNm == null) this.szx0aaCorpNm = corpNm;
    }
}
