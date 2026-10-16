package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * USPM 포트폴리오 모델 변동성분석 (W_JA032C)
 * 5. 상승/하락일수 분석 DTO (d_ja032c3_ud.srd / d_ja032c3_ud_krx.srd 기반)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja032cUpDownDto {

    private String upDown;       // 구분 (상승일수, 하락일수 등)
    private BigDecimal c5;       // 5일
    private BigDecimal c8;       // 8일
    private BigDecimal c13;      // 13일
    private BigDecimal c21;      // 21일
    private BigDecimal c34;      // 34일
    private BigDecimal c55;      // 55일
}
