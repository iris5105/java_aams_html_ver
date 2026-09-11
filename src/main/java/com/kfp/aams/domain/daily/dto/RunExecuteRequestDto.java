package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RunExecuteRequestDto {
    private String corpGr;
    private String ymd;
    private String pgmId;
    private String pgmNm;
}
