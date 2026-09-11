package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja991aDetailDto {
    private Long fseq;
    private String ymd;
    private BigDecimal close;
    private BigDecimal preclose;
    private BigDecimal change;
    private BigDecimal volume;
    private BigDecimal value;
}
