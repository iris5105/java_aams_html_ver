package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * USPM 포트폴리오 모델 변동성분석 (W_JA032C)
 * 3. 변동수준 / 괴리율 분석 DTO (d_ja032c3.srd 기반)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja032cVolatilityDto {

    private String rec;
    private BigDecimal volatility;     // 변동수준 (%)
    private String guganDt;            // 기준일자 (YYYY-MM-DD)
    private String bigo;               // 구분
    private BigDecimal dayVolatility;  // 당일지표 (%)
    private String pos;                // 위치

    // CUD 상태 관리 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
