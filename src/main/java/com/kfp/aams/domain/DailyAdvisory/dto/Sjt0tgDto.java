package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DTO for d_sjt0tg (주식 종가 관리)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Sjt0tgDto {

    private String corpGr;
    private String ymd;
    private String koscomCd;
    private String xxKoscomCd; // 종목명 (F_KOSCOM_NM)

    private BigDecimal close;      // 종가
    private BigDecimal volume;     // 거래량
    private BigDecimal value;      // 거래대금
    private BigDecimal preclose;   // 전일종가
    private BigDecimal change;     // 전일대비
    private BigDecimal aekm;       // 액면가
    private BigDecimal sangjJusu;  // 상장주수

    private LocalDateTime modDt;   // 수정일시
    private String modDtStr;

    // UI 상태 관리용
    private Boolean isNew;
    private String rowStatus; // C: 신규, U: 수정, D: 삭제
}
