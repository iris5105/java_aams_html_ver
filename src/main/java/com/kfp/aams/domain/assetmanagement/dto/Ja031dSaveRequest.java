package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

/**
 * W_JA031D 일괄 저장 요청 DTO (규칙 02 준수)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja031dSaveRequest {
    private String corpGr;
    private LocalDate ymd;
    private String trCd;
    private List<Ja031dDto> rows;
    private List<Ja031dDto> deletedRows;
}

