package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DTO for d_scm1sm (채권단가 / 종가 관리)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Scm1smDto {

    private String corpGr;
    private String ymd;
    private String jmCd;
    private String asCjCd;
    private BigDecimal jySuikRt;
    private BigDecimal danga;
    private String cjNm;
    private BigDecimal jySuikPer;

    private LocalDateTime chgtime;
    private String chgtimeStr;

    // UI 상태 관리용
    private Boolean isNew;
    private String rowStatus; // C: 신규, U: 수정, D: 삭제
}
