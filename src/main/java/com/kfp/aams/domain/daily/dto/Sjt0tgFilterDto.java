package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Sjt0tgFilterDto {
    private String corpGr;
    private String ymd;
}
