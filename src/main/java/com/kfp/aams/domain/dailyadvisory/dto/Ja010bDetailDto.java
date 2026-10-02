package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010bDetailDto {
    private String corpGr;
    private String fundCd;
    private Integer gyulGi;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate bfGyulYmd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate afGyulYmd;

    private Integer ilsu;
    private BigDecimal giSonikAek;
    private BigDecimal wmSeoljAek;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate wmDt;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate haejiYmd;

    private String distCalc;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate inchulYmd;

    private BigDecimal inAek;
    private BigDecimal afGijun;
    private Integer pVisible;
    private Boolean isNew;
    private Boolean isUpdated;
}
