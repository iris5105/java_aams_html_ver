package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * USPM 포트폴리오 모델 변동성분석 (W_JA032C)
 * 4. 베타(Beta) 분석 DTO (d_ja032c3_beta.srd / d_ja032c3_beta_krx.srd 기반)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja032cBetaDto {

    private BigDecimal beta;     // 년간 Beta
    private BigDecimal beta20;   // 1개월 Beta
    private BigDecimal beta60;   // 3개월 Beta
    private BigDecimal beta120;  // 6개월 Beta
}
