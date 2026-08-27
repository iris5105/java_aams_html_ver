package com.kfp.aams.domain.ja010.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja010bDetailDto {
    private String corpGr;          // CORP_GR
    private String fundCd;          // FUND_CD
    private Integer gyulGi;         // GYUL_GI
    private String bfGyulYmd;       // BF_GYUL_YMD
    private String afGyulYmd;       // AF_GYUL_YMD
    private Integer ilsu;           // ILSU
    private Double giSonikAek;      // GI_SONIK_AEK
    private String haejiYmd;        // HAEJI_YMD
    private String distCalc;        // DIST_CALC
    private String inchulYmd;       // INCHUL_YMD
    private Double inAek;           // IN_AEK
    private String afGijun;         // AF_GIJUN
    private Double wmSeoljAek;      // WM_SEOLJ_AEK
    private String wmDt;            // WM_DT
}
