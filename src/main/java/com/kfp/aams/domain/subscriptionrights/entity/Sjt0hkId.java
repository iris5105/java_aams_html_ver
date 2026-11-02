package com.kfp.aams.domain.subscriptionrights.entity;

import lombok.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.math.BigDecimal;

@Data @NoArgsConstructor @AllArgsConstructor
public class Sjt0hkId implements Serializable {
    private LocalDate trYmd;
    private String trCd;
    private String habCo;
    private String piHabCo;
}

