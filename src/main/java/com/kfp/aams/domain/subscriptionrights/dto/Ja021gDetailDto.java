package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.Data;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.LocalDate;
import java.math.BigDecimal;

@Data
public class Ja021gDetailDto {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String habCo;
    private String piHabCo;
    private String fundCd;
    private String oldJmCd;
    private String newJmCd;
    private BigDecimal boyuJusu;
    private BigDecimal chuiAek;
    private BigDecimal habPer;
    private BigDecimal habJusu;
    private BigDecimal habChuiAek;
    private BigDecimal habGyoubAek;
    private BigDecimal gamPer;
    private BigDecimal gamJusu;
    private LocalDate jusuSuryYmd;
    private BigDecimal suryJusu;
    private LocalDate aekSuryYmd;
    private BigDecimal suryAek;
    private String delYn;
    private String typeTrench;
    private BigDecimal bsType;
    private String fundNm;
    @JsonProperty("isUpdated")
    private boolean isUpdated;
}

