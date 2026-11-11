package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA031J 금감원 보고서 데이터 DTO (d_ja031j.srd 1:1 매핑)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja031jDto {
    private String c01;
    private String c02;
    private String c03;
    private String c04;
    private String c05;

    private BigDecimal n01;
    private BigDecimal n02;
    private BigDecimal n03;
    private BigDecimal n04;
    private BigDecimal n05;
    private BigDecimal n06;
    private BigDecimal n07;
    private BigDecimal n08;
    private BigDecimal n09;
    private BigDecimal n10;
    private BigDecimal n11;
    private BigDecimal n12;
    private BigDecimal n13;
    private BigDecimal n14;
    private BigDecimal n15;
    private BigDecimal n16;
    private BigDecimal n17;
    private BigDecimal n18;
    private BigDecimal n19;
    private BigDecimal n20;
}

