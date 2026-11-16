package com.kfp.aams.domain.subscriptionrights.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Sjt0j1Id implements Serializable {
    private String corpGr;
    private LocalDate ymd;
    private String balhCo;
    private String jeungjMth;
    private String fundCd;
    private String oldJmCd;
    private String newJmCd;
    private String haejiFund;
    private String typeTrench;
    private BigDecimal bsType;
}
