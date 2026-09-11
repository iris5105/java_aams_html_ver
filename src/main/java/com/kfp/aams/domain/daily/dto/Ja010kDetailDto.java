package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja010k2 (공모청약 수요예측 참여표(계좌) 디테일 운용내역)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010kDetailDto {
    private String corpGr;
    private String ymd;
    private String typeGb;
    private String fundCd;
    private String gubun;           // 채권/주식
    private String dancGb;          // 거래소/코스닥/코넥스/비상장
    private String jmGr;
    private String jmCd;
    private String jmNm;
    private String buyDate;
    private BigDecimal chasu;
    private String typeTrench;
    private BigDecimal bsType;

    private BigDecimal ventureTotal;    // 벤처합계 (aekm)
    private BigDecimal sise;            // 시세
    private BigDecimal sigaAek;         // 시가액
    private BigDecimal ventureNew;      // 벤처신주 (aekm - vc_old)
    private BigDecimal vcOld;           // 벤처구주 (수정가능)
    private String vcOldDt;             // 구주일자 (수정일시)

    private BigDecimal nav;             // NAV (sun_jasan_aek)
    private BigDecimal totalNav;        // 총NAV (real_jasan_aek)
    private BigDecimal ventureNewPer;   // 벤처신주비율(%)
    private BigDecimal ventureOldPer;   // 벤처구주비율(%)
    private BigDecimal ventureTotalPer; // 벤처합계비율(%)

    private String ventureStart;        // 벤처시작일
    private String ventureEnd;          // 벤처종료일
}
