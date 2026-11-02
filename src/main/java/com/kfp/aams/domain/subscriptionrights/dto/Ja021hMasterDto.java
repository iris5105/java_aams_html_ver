package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class Ja021hMasterDto {

    private LocalDate trYmd;
    private String trCd;
    private String balhCo;
    private String oldJmCd;
    private String oldDancGb;
    private String oldKoscomCd;
    private String newJmCd;
    private String newDancGb;
    private String newKoscomCd;
    private String jmCd;
    private String sjKoscomCd;
    private String sjJmCd;
    private String balhNm;
    private String oldJmNm;
    private String newJmNm;
    private String jmNm;
    private String koscomNm;
    private LocalDate closeYmd;
    private LocalDate hwakjYmd;
    private LocalDate krakYmd;
    private LocalDate baejGijunYmd;
    private LocalDate chengYmd;
    private BigDecimal balhGa;
    private BigDecimal hwakjBalhGa;
    private BigDecimal jonga;
    private String g00;
    private Integer pVisible;
}
