package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * DTO for d_shj0ig.srd (SHJ0IG - 현금 종목별 이자구간)
 * Columns and data types directly mapped from d_shj0ig.srd table definition.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Shj0igDetailDto {

    private String corpGr;             // char(8)
    private String jmCd;               // char(12)
    private BigDecimal guganNo;        // number
    private BigDecimal guganIlsu;      // number
    private BigDecimal guganIja;       // number

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate bfIjaYmd;         // datetime -> LocalDate

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate afIjaYmd;         // datetime -> LocalDate

    private String ipUser;             // char(10)

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime ipYmd;       // datetime -> LocalDateTime

    private BigDecimal otherCost;      // number

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate otherCostEndYmd; // datetime -> LocalDate

    private BigDecimal platformFee;    // number

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate platformYmd;     // datetime -> LocalDate

    private BigDecimal fixIjaAek;      // number
    private BigDecimal nowNo;          // number (argument)
    private Integer pVisible;          // number (1)
}
