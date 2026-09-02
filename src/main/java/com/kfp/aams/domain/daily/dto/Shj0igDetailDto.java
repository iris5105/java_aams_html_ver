package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_shj0ig.srd (SHJ0IG - 현금 종목별 이자구간)
 * Columns and data types directly mapped from d_shj0ig.srd table definition.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Shj0igDetailDto {

    private String corpGr;             // char(8)
    private String jmCd;               // char(12)
    private BigDecimal guganNo;        // number
    private BigDecimal guganIlsu;      // number
    private BigDecimal guganIja;       // number
    private String bfIjaYmd;          // datetime -> YYYY-MM-DD string
    private String afIjaYmd;          // datetime -> YYYY-MM-DD string
    private String ipUser;             // char(10)
    private String ipYmd;              // datetime -> YYYY-MM-DD HH:mm:ss string
    private BigDecimal otherCost;      // number
    private String otherCostEndYmd;    // datetime -> YYYY-MM-DD string
    private BigDecimal platformFee;    // number
    private String platformYmd;        // datetime -> YYYY-MM-DD string
    private BigDecimal fixIjaAek;      // number
    private BigDecimal nowNo;          // number (argument)
    private Integer pVisible;          // number (1)
}
