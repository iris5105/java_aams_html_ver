package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

/**
 * Request DTO for creating derivative repurchase orders (환매수 주문생성: cb_syt0mg)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032oOrderCreateRequestDto {

    private String corpGr;
    private String ymd;
    private String trCoCd;
    private String fundCd;
    private String portNum;
    private List<OrderItem> items;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrderItem {
        private String jmCd;      // 파생 종목코드
        private String yjCd;      // 기초자산 코드
        private String currency;  // 통화
        private String trCd;      // 환매수 거래코드 (S71, S81, etc.)
        private BigDecimal orderSu;   // 주문수량
        private BigDecimal orderAek;  // 주문단가
    }
}
