package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * DTO for d_uzm0hy (계좌(종목)별 주간 운용현황 펀드 목록)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Uzm0hyDto {
    private String corpGr;
    private String encAcctNo;
    private String acctNo;
    private String fundCd;
    private String fundNm;
    private String typeGb;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate fstSeoljYmd;

    private BigDecimal sintakGigan;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate bfGyulYmd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate afGyulYmd;

    private String targetJasan;
    private BigDecimal gyulGi;
    private String haejiGb;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate haejiYmd;

    private BigDecimal reSeoljYear;
    private BigDecimal reSeoljAek;
    private String mgCd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate reSeoljYmd;

    private String seriesGb;
    private String gugan;
}
