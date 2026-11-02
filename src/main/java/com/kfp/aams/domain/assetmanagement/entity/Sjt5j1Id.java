package com.kfp.aams.domain.assetmanagement.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Sjt5j1Id implements Serializable {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String jmCd;
    private String fundCd;
    private String balhCo;
    private String typeTrench;
    private BigDecimal bsType;
}
