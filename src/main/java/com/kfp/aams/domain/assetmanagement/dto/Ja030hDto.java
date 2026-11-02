package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class Ja030hDto {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String fundCd;
    private String originalFundCd;
    private String jmCd;
    private String originalJmCd;
    private BigDecimal seqNo;
    private String xxFundCd;
    private String xxJmCd;
    private String ksdJmCd;
    private String trCoCd;
    private BigDecimal aekm;
    private BigDecimal trAek;
    private BigDecimal jungsanAek;
    private BigDecimal mijigubTax;
    private BigDecimal danga;
    private BigDecimal bfilAekm;
    private BigDecimal bfilSigaAek;
    private BigDecimal mmSonik;
    private BigDecimal mkSuikRt;
    private BigDecimal susuGa;
    private String taxOfferGb;
    private String jajunGb;
    private Integer pVisible;
    private Boolean isNew;
    private Boolean isUpdated;
}
