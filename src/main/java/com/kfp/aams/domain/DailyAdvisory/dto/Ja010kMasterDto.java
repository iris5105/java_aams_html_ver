package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for d_ja010k1 (공모청약 수요예측 참여표(계좌) 마스터 펀드)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010kMasterDto {
    private String fundCd;
    private String fundNm;
    private String reSeoljYmd;
    private String fstSeoljYmd;
    private String haejiYmd;
}
