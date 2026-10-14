package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja032e1_call (USPM_PORT + SZM0IA)
 * USPM CALL 펀드/포트 목록
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032eCallFundDto {
    private String corpGr;
    private String fymd;
    private String tymd;
    private String fundCd;
    private String fundNm;
    private String portNum;
    private String tt;
    private Integer instDays;
    private String mangiYmd;
    private Long dt;
    private BigDecimal z; // CALL_Z
    private BigDecimal usdTuja;

    // CUD 및 UI 상태
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
