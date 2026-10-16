package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * 옵션 그릭스 실시간 동적 재계산 요청 DTO
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja032cGreeksRecalcRequest {

    private BigDecimal s;
    private BigDecimal t;
    private BigDecimal k;
    private BigDecimal r;
    private BigDecimal marketPrice;
    private BigDecimal impVolatility;
    private boolean priceChanged;
}
