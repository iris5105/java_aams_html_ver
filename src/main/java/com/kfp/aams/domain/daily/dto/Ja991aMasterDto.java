package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja991aMasterDto {
    private Long fseq;
    private String jmCd;
    private String koscomCd;
    private String jjNm;
    private String jjEnm;
    private String balhCo;
}
