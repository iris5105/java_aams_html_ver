package com.kfp.aams.domain.usportfoliomodel.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja032a2 (USPM_PORT)
 * US Portfolio Model 포트별 설정 목록
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032aPortDto {

    private String corpGr;
    private String fymd;
    private String tymd;
    private String fundCd;
    private String portNum;
    private String tt;
    private String ttNm;
    private Integer instDays;
    private String mangiYmd;
    private Long dt;
    private BigDecimal z;
    private BigDecimal jmPer;
    private BigDecimal usdTuja;
    private BigDecimal yearBeta;
    private BigDecimal monBeta;
    private BigDecimal pricePer;
    private Integer optColor;
    private BigDecimal fundJmPer;
    private String pVisible;

    // CUD 관리 플래그
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
