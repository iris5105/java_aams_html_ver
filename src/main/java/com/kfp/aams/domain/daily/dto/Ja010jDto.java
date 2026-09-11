package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for d_ja010j1 (공모청약 수요예측 참여표(회사) 참여그룹 목록)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010jDto {
    private String corpGr;
    private String companyName;
    private String fundCd;
    private String fundNm;
}
