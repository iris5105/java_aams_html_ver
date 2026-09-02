package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for w_ja030c (채권 매매등록 / d_ja030c.srd)
 * Directly matches column names and types from d_ja030c.srd (Guideline 3)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja030cDto {
    private String corpGr;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String jmCd;
    private String buyDate;
    private BigDecimal seqNo;
    private String trCoCd;
    private BigDecimal aekm;
    private BigDecimal danga;
    private BigDecimal trAek;
    private BigDecimal susu;
    private String sudoYmd;
    private BigDecimal mkSuikRt;
    private String pgCd;
    private String jajunGb;
    private BigDecimal chuiAek;
    private String dangaGb;
    private String jajunSayu;
    private BigDecimal ijaAekm;
    private String cjNm;
    private String fundNm;
    private Integer pVisible;
}
