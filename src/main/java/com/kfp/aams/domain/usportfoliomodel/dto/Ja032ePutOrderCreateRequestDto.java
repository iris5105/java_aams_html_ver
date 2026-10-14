package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * PUT 배분생성 요청 DTO (cb_syt0mg 대응)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032ePutOrderCreateRequestDto {
    private String corpGr;
    private String ymd;
    private String trCoCd;
    private String fundCd;
    private String portNum;
    private String yjCd;
    private String currency;

    @Builder.Default
    private List<OrderItem> items = new ArrayList<>();

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrderItem {
        private String optJmCd;
        private BigDecimal hangsaGa;
        private String orderGb; // 매도 / 매수
        private BigDecimal trSu;
        private BigDecimal bidAsk; // 주문단가
        private String mm;
    }
}
