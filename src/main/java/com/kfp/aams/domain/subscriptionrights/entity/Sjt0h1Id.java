package com.kfp.aams.domain.subscriptionrights.entity;

import lombok.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.math.BigDecimal;

@Data @NoArgsConstructor @AllArgsConstructor
public class Sjt0h1Id implements Serializable {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String habCo;
    private String piHabCo;
    private String fundCd;
    private String oldJmCd;
    private String newJmCd;
    private String typeTrench;
    private BigDecimal bsType;
}

