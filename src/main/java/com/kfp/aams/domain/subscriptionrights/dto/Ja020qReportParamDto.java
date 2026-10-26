package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * W_JA020Q 수요예측 참여자료 MRD 리포트 파라미터 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020qReportParamDto {

    private String mrdPath;
    private String fundCd;
    private String fundNm;
    private String gugan;
    private String fymd;
    private String tymd;
    private String reportTitle;
    private String statusText;
}
