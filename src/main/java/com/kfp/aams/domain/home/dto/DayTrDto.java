package com.kfp.aams.domain.home.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DayTrDto {
    private String corpGr;
    private String jasanGb;
    private String trCd;
    private Long trCount;
    private BigDecimal trAek;
    private Long fundCount;
    private String titleYmd;
}
