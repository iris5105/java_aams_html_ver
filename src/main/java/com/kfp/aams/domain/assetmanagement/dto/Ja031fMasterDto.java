package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * d_ja031f.srd 매핑 DTO (채권 매매현황 계좌 목록)
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja031fMasterDto {
    private String fundCd;
    private String fundNm;
}

