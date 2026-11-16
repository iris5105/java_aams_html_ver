package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
public class Ja036kLoadDto {
    private String corpGr;
    private LocalDateTime loadDate;
    private String ipUser;
    private String userNm;
    private String loadOk;
    private String loadNaye;
    private LocalDate loadYmd;
    private Long trSeq;
    private String fundCd;
    private String fundNm;
    private String jmCd;
    private String jmNm;
    private String currency;
    private String stockNm;
    private String trNm;
    private String memeYmd;
    private String gyulYmd;
    private BigDecimal trJusu;
    private BigDecimal trDanga;
    private BigDecimal trSusu;
    private BigDecimal trTax;
    private BigDecimal trAek;
    private BigDecimal memeGijunRt;
    private BigDecimal gyulGijunRt;
    private LocalDateTime loadDt;
    private String jasanNm;
    private BigDecimal aekm;
    private BigDecimal chuiAek;
    private BigDecimal sigaAek;
}
