package com.kfp.aams.domain.subscriptionrights.dto;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDate;
/** d_ja021e2.srd column types, including transient holding/row-state metadata. */
@Getter @Setter
public class Ja021eDetailDto {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String fundCd;
    private String jmCd;
    private String buyDate;
    private BigDecimal seqNo;
    private String trCoCd;
    private String ijaBaedGb;
    private String koscomCd;
    private BigDecimal jusicJusu;
    private BigDecimal jusicAek;
    private BigDecimal jusicDanga;
    private String dancGb;
    private BigDecimal mijigubTax;
    private String xxFundCd;
    private BigDecimal aekm;
    private BigDecimal danga;
    private BigDecimal comAekm;
    private String chgJmCd;
    private LocalDate lockEnd;
    private String suryChk;
    private LocalDate suryYmd;
    private BigDecimal aek;
    private BigDecimal suryProtect;
    private BigDecimal pVisible;
    private BigDecimal holdingAek;
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
    public String getFundNm() { return xxFundCd; }
    public void setFundNm(String name) { this.xxFundCd = name; }
}
