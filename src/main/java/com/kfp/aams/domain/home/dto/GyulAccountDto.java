package com.kfp.aams.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GyulAccountDto {
    private String gyulYmd;
    private String fundCd;
    private String fundNm;
    private String titleYmd;
}
