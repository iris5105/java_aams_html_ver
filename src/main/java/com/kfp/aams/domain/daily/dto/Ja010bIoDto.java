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
public class Ja010bIoDto {
    private String corpGr;
    private String fundCd;
    private String trYmd;
    private BigDecimal inAek;
    private BigDecimal outAek;
    private BigDecimal ioJo;
    private BigDecimal wonbonAek;
    private Integer giganIlsu;
    private Integer passIlsu;
}
