package com.kfp.aams.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RateChangeDto {
    private String jmCd;
    private String cjNm;
    private String fundCd;
    private String fundNm;
    private String afIjaYmd;
    private String lineColor;
}
