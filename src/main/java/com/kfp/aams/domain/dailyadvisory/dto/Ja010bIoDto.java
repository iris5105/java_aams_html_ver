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
public class Ja010bIoDto {
    private String corpGr;
    private String fundCd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate trYmd;

    private BigDecimal inAek;
    private BigDecimal outAek;
    private BigDecimal ioJo;
    private BigDecimal wonbonAek;
    private Integer giganIlsu;
    private Integer passIlsu;
    private String modDt;
    private String modUser;
    private String modYn;
    private Integer pVisible;
    private Boolean isNew;
    private Boolean isUpdated;
}
