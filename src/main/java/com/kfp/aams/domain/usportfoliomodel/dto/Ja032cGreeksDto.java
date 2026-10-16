package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * USPM 포트폴리오 모델 변동성분석 (W_JA032C)
 * 6. 델타/감마/세타/베가/로 (Option Greeks) 분석 DTO (d_ja032c3_dgtvr.srd 기반)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja032cGreeksDto {

    private BigDecimal s;             // 종가
    private BigDecimal k;             // 행사가
    private BigDecimal t;             // 잔존일수 / 만기일수
    private BigDecimal r;             // 무위험이자율
    private BigDecimal sigma;         // 변동성
    private BigDecimal yearSigma;     // (년)변동성
    private BigDecimal callDelta;     // 콜 델타
    private BigDecimal putDelta;      // 풋 델타
    private BigDecimal gamma;         // 감마
    private BigDecimal vega;          // 베가
    private BigDecimal callTheta;     // 콜 세타
    private BigDecimal putTheta;      // 풋 세타
    private BigDecimal callRho;       // 콜 로
    private BigDecimal putRho;        // 풋 로
    private String putJmCd;           // PUT 옵션 종목코드
    private BigDecimal marketPrice;   // 시장가격
    private BigDecimal impVolatility; // 내재변동성
}
