package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * Detail DTO for d_scm1pg_2 (채권신용등급 관리 디테일)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Scm1pgDetailDto {
    private String corpGr;   // 회사그룹

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate ymd;   // 적용일자 (YYYY-MM-DD)

    private String jmCd;     // 종목코드
    private String pgCd;     // 신용등급코드
    private String pgNm;     // 신용등급명
    private String week;     // 주차
    private String fundList; // 매수계좌 LIST

    // 상태 플래그
    private String rowStatus;// C: 신규, U: 수정, D: 삭제
    private Boolean isNew;   // 신규 행 여부
}
