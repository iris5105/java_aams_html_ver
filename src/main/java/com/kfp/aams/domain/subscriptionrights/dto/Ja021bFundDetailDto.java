package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * 펀드별 배당권리 상세 DTO (d_ja021b_t22, t32, t42, t52: SJT0BM)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja021bFundDetailDto {

    private String corpGr;
    private String corpNm;
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
}
