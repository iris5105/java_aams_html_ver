package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

/** d_ja030a1.srd 목록/저장 전용 DTO. */
@Data
public class Ja030aDto {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String fundCd;
    private String originalFundCd;
    private String fundNm;
    private String jmCd;
    private LocalDate krakYmd;
    private String balhCo;
    private BigDecimal balhGa;
    private BigDecimal trJusu;
    private BigDecimal trDanga;
    private BigDecimal trAek;
    private BigDecimal susu;
    private BigDecimal gyulAek;
    private String trCoCd;
    private LocalDate chengYmd;
    private String typeTrench;
    private BigDecimal bsType;
    private Integer pVisible;
    private Boolean isNew;
    private Boolean isUpdated;
}
