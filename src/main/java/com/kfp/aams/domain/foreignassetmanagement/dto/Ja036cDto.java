package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA036C 유상청약납입 DTO (DataWindow: d_ja036c)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja036cDto {

    private String corpGr;
    private String ymd;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String trCoCd;
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
    private Long bsType;
    private String fundNm;
    private String fundCurrency;
    private BigDecimal syt0ysFcurGyuljeAek;
    private BigDecimal syt0ysFcurHwanCha;

    // CUD 상태 관리 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
