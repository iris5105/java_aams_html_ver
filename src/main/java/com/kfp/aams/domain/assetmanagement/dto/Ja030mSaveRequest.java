package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.util.List;

/** W_JA030M 저장 요청. */
@Data
public class Ja030mSaveRequest {
    private List<Ja030mDto> rows;
    private List<Ja030mDto> deletedRows;
}
