package com.kfp.aams.domain.ja010.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010dDto {
    private String corpGr;
    private String fundCd;
    private String fundNm;
    private String trYmd;
    private Long inAek;
    private Long outAek;
    private Long ioJo;
    private Long wonbonAek;
    private Integer pVisible;
}
