package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 포트별 옵션수익실현현황 - 우측 하단 상세 목록 DTO (d_ja032n2.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032nDetailDto {

    private String corpGr;
    private String ymd;
    private String fundCd;
    private String port;

    private BigDecimal pgPremium; // 미실현 프리미엄
    private BigDecimal bfPremium; // 실현프리미엄 이월액
    private BigDecimal upPremium; // 당일증가 프리미엄
    private BigDecimal dwPremium; // 당일감소 프리미엄
    private BigDecimal premium;   // 실현프리미엄 누계액 (bf_premium + sa3_premium)
    private BigDecimal jmSonik;   // 주식매매 손익누계
    private BigDecimal pgSonik;   // 주식 평가손익

    // 클라이언트 UI용 플래그
    private Boolean isDailySummaryRow; // 일별합계 행 여부
    private Integer fseq;              // 행 순번
}
