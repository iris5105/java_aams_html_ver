package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja032o2 (USPM + USPM_OPT + SYM0YA + SYM0YZ + SYM0YA opt_jm)
 * 파생상품 보유 내역 및 환매수 주문 생성 목록
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032oDetailDto {

    private String corpGr;
    private String ymd;
    private String fundCd;
    private String yjCd;          // 기초자산 종목코드 (USPM.JM_CD)
    private String xxYjCd;        // 기초자산 종목명 (SYM0YA.JM_NM)
    private BigDecimal usdTuja;   // 투자목표액
    private BigDecimal targetReturnPer; // 목표수익률
    private BigDecimal stockChui; // 주식취득액
    private BigDecimal optNominalAmt; // 옵션명목금액

    // 계산식: usd_tuja - stock_chui - opt_nominal_amt
    private BigDecimal settableAmount;

    // 파생 보유 정보
    private String jmCd;          // 보유 파생상품 종목코드 (SYM0YZ.JM_CD)
    private String jmNm;          // 보유종목명
    private BigDecimal hangsaGa;  // 행사가격
    private String lsyYmd;        // 상환/만기일
    private BigDecimal trJusu;    // 보유수량 (잔고수량)
    private BigDecimal trAek;     // 취득액
    private BigDecimal sym0yzOptNominalAmt;
    private String trCd;          // 환매수 거래코드 (S71, S81, S91, SA1)
    private String currency;      // 통화

    // 환매수 주문 입력 필드
    private BigDecimal orderSu;   // 주문수량
    private BigDecimal orderAek;  // 주문단가

    // CUD 상태 플래그
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
}
