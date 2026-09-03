package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * DTO for w_ja010f 예수금잔액LOAD (d_ja010f1.srd / SHT0YE)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja010fDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String corpGr;
    private String trYmd;
    private String fundCd;
    private String fundNm;
    private BigDecimal t0Aek;
    private BigDecimal t1Aek;
    private BigDecimal t2Aek;
    private BigDecimal stockAek;
    private BigDecimal bondAek;
    private BigDecimal rpAek;
    private BigDecimal totAek;
    private String trCoCd;
    private String encAcctNo;
    private String bigo;
    private String acctNo;
}
