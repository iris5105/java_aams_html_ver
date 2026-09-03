package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * DTO for w_ja010e 주식체결LOAD(입고) (d_ja010e1.srd / SJT1JG)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja010eDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String corpGr;
    private String trYmd;
    private String trCd;
    private String trCoCd;
    private Long offerNo;
    private String encAcctNo;
    private String jmCd;
    private String koscomCd;
    private BigDecimal trJusu;
    private BigDecimal trAek;
    private String fundCd;
    private String fundNm;
    private String jjNm;
    private String dancGb;
    private BigDecimal susu;
    private BigDecimal tax;
    private String sudoYmd;
    private String acctNo;
    private String loadTime;
    private Integer pVisible;
    private BigDecimal danga;
}
