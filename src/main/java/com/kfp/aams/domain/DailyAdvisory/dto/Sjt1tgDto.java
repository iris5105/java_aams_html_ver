package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_sjt1tg (선물/옵션 종가등록)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Sjt1tgDto {
    private String sjCd;        // 선물/옵션 종목코드(12자리, koscom_cd)
    private String xxSjCd;      // 선물/옵션 종목명 (f_sj_nm)
    private BigDecimal close;   // 당일종가
    private BigDecimal volume;  // 거래량
    private BigDecimal value;   // 거래대금
    private BigDecimal preclose;// 전일종가
    private BigDecimal spotPrice;// 현물가격
    private BigDecimal calcPrice;// 정산가격
    private BigDecimal change;  // 등락
    private String ymd;         // 기준일 (YYYY-MM-DD)
    private String bigo;        // 비고
    private Integer pVisible;   // 버튼 표출 여부 (1)

    // 상태 플래그
    private String rowStatus;   // C: 생성, U: 수정, D: 삭제
    private Boolean isNew;      // 신규 행 여부
}
