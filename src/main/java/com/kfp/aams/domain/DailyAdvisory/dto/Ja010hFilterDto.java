package com.kfp.aams.domain.daily.dto;

import lombok.*;

/**
 * Filter DTO for w_ja010h
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja010hFilterDto {
    private String corpGr;
    private String ymd;
    private String fundCd;
}
