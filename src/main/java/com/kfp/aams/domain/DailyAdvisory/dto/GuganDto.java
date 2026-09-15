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
public class GuganDto {
    private String m3Fymd;
    private String m3Tymd;
    private String g3bFymd;
    private String g3bTymd;
    private String b3Fymd;
    private String b3Tymd;
    private String g1Text;
    private String g2Text;
    private String g3Text;
    private BigDecimal m3Gu;
    private BigDecimal g3Gu;
}
