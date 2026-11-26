package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.Data;

import java.util.List;

/**
 * W_JA035P 마스터/디테일 일괄 저장 요청 DTO
 */
@Data
public class Ja035pSaveRequest {
    private List<Ja035pMasterDto> masterChanges;
    private List<Ja035pDetailDto> detailChanges;
}
