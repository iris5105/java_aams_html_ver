package com.kfp.aams.domain.subscriptionrights.entity;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class Sjt0fsId implements Serializable {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String fundCd;
    private String jmCd;
    private String typeTrench;
    private BigDecimal bsType;
}

