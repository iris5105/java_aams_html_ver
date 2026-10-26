package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 해외주식종가/업종지수 등록 (W_JA032J) 마스터 DTO
 * - DataWindow: d_ja032j1.srd (종가일자 및 주차 목록)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032jMasterDto {

    /** 종가일자 (YYYY-MM-DD) */
    private String ymd;

    /** 주차 (2자리) */
    private String week;
}
