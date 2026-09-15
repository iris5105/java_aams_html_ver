package com.kfp.aams.domain.daily.dto;

import lombok.*;

/**
 * Filter DTO for w_ja010o (주식 신용/대출잔고 LOAD)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja010oFilterDto {
    private String corpGr;       // 회사그룹코드
    private String ymd;          // 기준일자 (yyyyMMdd 또는 yyyy-MM-dd)
    private String fundCd;       // 펀드코드
}
