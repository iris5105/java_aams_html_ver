package com.kfp.aams.domain.usportfoliomodel.dto;

import java.math.BigDecimal;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 해외옵션 일별 시세 (d_srs_cd2.srd / SYT0LP) 디테일 DTO
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SrsCdDetailDto {

    private String corpGr;                  // 회사그룹
    private String ymd;                     // 일자 (YYYY-MM-DD)
    private String jmCd;                    // 종목코드 (SRS_CD)
    private BigDecimal jonga;               // 종가
    private BigDecimal danga;               // 단가
    private String loadTime;                // 수신일시 (YYYY-MM-DD HH24:MI:SS)
    private String pxCloseDt;               // 전영업일
    private BigDecimal pxLast;              // 최종가
    private String pxDt1d;                  // 1일전거래일
    private BigDecimal pxClose1d;           // 1일전종가
    private BigDecimal pxYestCloseExchUnadj;// 수정전전일종가
    private String blbgTckr;                // 블룸버그티커
    private String isinCd;                  // ISIN코드
    private String currency;                // 통화
    private BigDecimal hangsaGa;            // 행사가
    private BigDecimal bid;                 // 매수가격 (BID)
    private BigDecimal ask;                 // 매도가격 (ASK)
    private BigDecimal timeGa;              // 시간가치
    private BigDecimal tvol;                // 거래량
    private BigDecimal tamt;                // 거래대금
    private BigDecimal shar;                // 상장주식수
    private BigDecimal tomv;                // 시가총액
    private BigDecimal tRate;               // 등락률
    private String trdToDate;               // 거래기한
    private String week;                    // 주차 (TO_CHAR(YMD, 'iw'))
}
