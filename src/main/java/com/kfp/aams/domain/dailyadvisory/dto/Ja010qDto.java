package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * DTO for d_ja010q (성과보수 상세내역 계좌 목록)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010qDto {
    private String corpGr;
    private String fundCd;
    private String fundNm;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate bfGyulYmd;   // 전결산일

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate bfStart;     // bf_gyul_ymd + 1

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate afGyulYmd;   // 후결산일

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate haejiYmd;    // 계약해지일

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate af;          // haeji_ymd - 1
}
