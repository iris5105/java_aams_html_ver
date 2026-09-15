package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja010n1 (주가지수 입력)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010nDto {
    private String corpGr;    // 'JISU'
    private String ymd;       // 기준일자 (YYYY-MM-DD)
    private String colId;     // 'kospi_jisu'
    private BigDecimal colVal;// 종합주가지수

    // 상태 플래그
    private String rowStatus; // C: 신규, U: 수정, D: 삭제
    private Boolean isNew;    // 신규 행 여부
}
