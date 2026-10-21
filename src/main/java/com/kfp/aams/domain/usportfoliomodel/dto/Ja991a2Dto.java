package com.kfp.aams.domain.usportfoliomodel.dto;

import java.math.BigDecimal;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 종목 일별 시세 (d_ja991a2.srd) DTO
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja991a2Dto {

    private String koscomCd;      // 단축코드
    private String ymd;           // 종가일자
    private BigDecimal close;     // 종가
    private BigDecimal volume;    // 거래량
    private BigDecimal value;     // 거래대금(억원)
    private BigDecimal preclose;  // 전일종가
    private BigDecimal change;    // 등락

    // 상태 관리 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
