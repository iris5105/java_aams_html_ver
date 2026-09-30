package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020rMasterDto {
    private String corpGr;
    private String fundCd;
    private String fundNm;
    private String bfYmd;
    private String afGyulYmd;
    private String secCd;
    private String secNm;
}
