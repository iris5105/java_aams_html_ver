package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

/**
 * W_JA031K CUD 일괄 저장 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja031kSaveRequest {
    private String corpGr;
    private LocalDate ymd;
    private String trCd;
    private List<Ja031kDto> rows;
    private List<Ja031kDto> deletedRows;
}

