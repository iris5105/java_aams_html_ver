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
public class Szx0seDto {
    private String corpGr;
    private String seriesG1;
    private String seriesG2;
    private String seriesGb;
    private String seriesNm;
    private BigDecimal retSusu;
    private String retSusuGb;
    private String futuresInclude;
    private String used;
    private BigDecimal reSeoljYear;
    private BigDecimal sintakGigan;
    private BigDecimal bosuGigan;
    private BigDecimal mokpyoSuikPer;
    private BigDecimal preBasic;
    private BigDecimal basicPer;
    private BigDecimal successPer;
    private String magamUsed;
    private String dpUsed;
    private String bmGr;
    private String gugan;
    private String ga;
    private String bigo;
}
