package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA031J 점검자료 데이터 DTO (d_ja031j_ga191.srd 1:1 매핑)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja031jGa191Dto {
    private String fundCd;
    private String fundNm;
    private String c01;
    private String c02;
    private String c03;
    private String c04;
    private String c05;
    private BigDecimal n03;
    private BigDecimal n01;
    private BigDecimal n02;
}

