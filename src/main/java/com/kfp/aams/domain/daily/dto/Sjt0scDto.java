package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_sjt0sc_2402 (펀드 기준가(시가액)등록)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Sjt0scDto {
    private String corpGr;         // 회사그룹
    private String ymd;            // 기준일자 (YYYY-MM-DD)
    private String jmCd;           // 당사종목코드
    private String tasaFundCd;     // KSD종목코드
    private String jmNm;           // 펀드(종목)명
    private BigDecimal dangGijunGa; // 기준가격 (당일기준가)
    private BigDecimal junGijunGa;  // 전일기준가격
    private BigDecimal gijunGaDr;   // 전일대비
    private BigDecimal gyulGijunGa; // 결산기준가격
    private BigDecimal bfSigaAek;   // 이월시가평가액
    private BigDecimal loadSigaAek; // 입력시가평가액
    private String bigo;           // 비고
    private BigDecimal dangGgijunGa;// 당일과세기준가
    private BigDecimal gyulGgijunGa;// 결산과세기준가

    // 상태 플래그
    private String rowStatus;      // C: 신규, U: 수정, D: 삭제
    private Boolean isNew;         // 신규 행 여부
}
