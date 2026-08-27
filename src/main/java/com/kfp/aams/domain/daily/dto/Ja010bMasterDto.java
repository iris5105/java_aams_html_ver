package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010bMasterDto {
    private String corpGr;
    private String encAcctNo;
    private String fundCd;
    private String fundNm;
    private String typeGb;
    private String typeGbNm;
    private String fstSeoljYmd;
    private Integer sintakGigan;
    private String bfGyulYmd;
    private String afGyulYmd;
    private BigDecimal preBasic;
    private BigDecimal basicPer;
    private BigDecimal bmPer;
    private BigDecimal successPer;
    private String seriesGb;
    private String targetJasan;
    private Integer gyulGi;
    private String haejiGb;
    private String haejiYmd;
    private Integer reSeoljYear;
    private BigDecimal reSeoljAek;
    private String mgCd;
    private String mgNm;
    private BigDecimal susuRt;
    private String email1;
    private String reSeoljYmd;
    private String unyongSabun;
    private String orderSend;
    private String expenseYn;
    private String aliasCode;
    private String specialNote;
    private String noteText;
    private String acctNo;
    private Integer pVisible;
}
