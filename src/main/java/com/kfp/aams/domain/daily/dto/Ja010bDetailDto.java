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
public class Ja010bDetailDto {
    private String corpGr;
    private String fundCd;
    private Integer gyulGi;
    private String bfGyulYmd;
    private String afGyulYmd;
    private Integer ilsu;
    private BigDecimal giSonikAek;
    private BigDecimal wmSeoljAek;
    private String haejiYmd;
}
