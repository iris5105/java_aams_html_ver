package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * d_ja030b1.srd 매핑 DTO (주식 계좌별 매매현황 계좌 목록)
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja030b1Dto {
    private String fundCd;
    private String fundNm;
}

