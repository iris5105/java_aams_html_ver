package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

/** W_JA030M 예금 이자 적용종목(SHM0HJ) 행. */
@Data
public class Ja030mDto {
    private String corpGr;
    private String jmCd;
    private String hjNm;
    private String cashCd;
    private String sutakCd;
    private BigDecimal pyomIyul;
    private BigDecimal pyomIyulPer;
    private BigDecimal meibSuikRt;
    private LocalDate balhYmd;
    private LocalDate sanghwYmd;
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
