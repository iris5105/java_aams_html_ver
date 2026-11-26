package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.Data;

import java.math.BigDecimal;

/**
 * W_JA036G 일별 잔고 상세 (d_ja036g2 / d_ja036g2_krw) DTO
 */
@Data
public class Ja036gDetailDto {

    private String ymd;
    private String trustee;

    private BigDecimal trBfilJusu;
    private BigDecimal trUpJusu;
    private BigDecimal trDwJusu;

    private BigDecimal trBfilChuiAek;
    private BigDecimal trUpChuiAek;
    private BigDecimal trDwChuiAek;
    private BigDecimal trPyungaAek;

    private BigDecimal fcurBfilChuiAek;
    private BigDecimal fcurUpChuiAek;
    private BigDecimal fcurDwChuiAek;

    private BigDecimal wonBfilChuiAek;
    private BigDecimal wonUpChuiAek;
    private BigDecimal wonDwChuiAek;

    private BigDecimal bfilSungCost;
    private BigDecimal sungCost;
    private BigDecimal fcurBfilSungCost;
    private BigDecimal fcurSungCost;
    private BigDecimal wonBfilSungCost;
    private BigDecimal wonSungCost;

    private BigDecimal bfilMisuIja;
    private BigDecimal misuIja;

    private BigDecimal fcurPyungaAek;
    private BigDecimal fcurPyungaSonik;
    private BigDecimal fcurHwanCha;
    private BigDecimal fcurBfilMisuIja;
    private BigDecimal fcurMisuIja;

    private BigDecimal wonPyungaAek;
    private BigDecimal wonPyungaSonik;
    private BigDecimal wonHwanCha;
    private BigDecimal wonBfilMisuIja;
    private BigDecimal wonMisuIja;

    private BigDecimal msdMeibAekm;
    private BigDecimal msdMeibAek;
    private BigDecimal fcurMsdMeibAek;
    private BigDecimal wonMsdMeibAek;

    private BigDecimal msdMedoAekm;
    private BigDecimal msdMedoAek;
    private BigDecimal fcurMsdMedoAek;
    private BigDecimal wonMsdMedoAek;

    private BigDecimal currencyRt;
}
