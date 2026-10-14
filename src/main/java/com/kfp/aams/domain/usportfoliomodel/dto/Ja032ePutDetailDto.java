package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja032e3_put (SYT0LP 해외수신 종목 시세)
 * 해외옵션 상세 시세 및 주문 정보
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032ePutDetailDto {
    private String optJmCd;
    private BigDecimal hangsaGa;
    private BigDecimal bid;
    private BigDecimal ask;
    private BigDecimal timeGa;
    private BigDecimal tvol;
    private BigDecimal totBidQntt;
    private String mm;
    private BigDecimal per;
    private String orderGb;
    private BigDecimal trSu;
    private BigDecimal bidAsk;
    private BigDecimal compute1; // BID / HANGSA_GA * 100

    // CUD 및 UI 상태
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
