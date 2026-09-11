package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_run (원장생성 프로그램 목록)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RunItemDto {
    private BigDecimal procSeq;     // 순번
    private String pgmId;           // 프로그램ID
    private String pgmNm;           // 프로그램명
    private String flag;            // 완료여부 ('Y' / 'N' / ' ')
    private String errMsg;          // 오류메세지/실행결과
}
