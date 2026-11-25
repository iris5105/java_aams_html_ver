package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA035J 수도결제 등록 DTO (DataWindow: d_ja035j)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja035jDto {

    private String corpGr;
    private String ymd;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String trCoCd;              // d_ja035j: xx_mg_cd (syt0ys.tr_co_cd)
    private String trustee;
    private String jmCd;
    private String currency;
    private Long trSeq;
    private String gyuljeYmd;
    private BigDecimal gyuljeAek;
    private BigDecimal wonGyuljeAek;
    private String gyuljeGb;
    private String gyuljeJmCd;
    private String sym0yaJmNm;
    private String jasanGb;
    private BigDecimal wonHwanCha;
    private BigDecimal suryAek;
    private Long bsType;
    private String fundNm;
    private String fundCurrency;
    private BigDecimal fcurGyuljeAek;
    private BigDecimal syt0ysFcurHwanCha;
    private BigDecimal bunhalAek;

    // CUD 상태 관리 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
