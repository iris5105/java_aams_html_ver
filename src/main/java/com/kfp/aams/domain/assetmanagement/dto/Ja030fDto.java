package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class Ja030fDto {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String fundCd;
    private String originalFundCd;
    private String originalHjCd;
    private String xxFundCd;
    private String hjCd;
    private String xxHjCd;
    private BigDecimal seqNo;
    private BigDecimal aekm;
    private BigDecimal trAek;
    private BigDecimal danga;
    private String trCoCd;
    private BigDecimal mkSuikRt;
    private BigDecimal sanghwAek;
    private BigDecimal susuGa;
    private String taxOfferGb;
    private String jajunGb;
    private BigDecimal sungCost;
    private BigDecimal autoPer;
    private BigDecimal susu09900;
    private BigDecimal sunsuIja;
    private Integer pVisible;
    private Boolean isNew;
    private Boolean isUpdated;
}
