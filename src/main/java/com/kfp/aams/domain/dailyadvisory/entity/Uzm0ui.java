package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "UZM0UI")
@IdClass(Uzm0uiId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Uzm0ui {

    @Id
    @Column(name = "CORP_GR", length = 10, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "YMD", nullable = false)
    private LocalDate ymd;

    @Id
    @Column(name = "FUND_CD", length = 20, nullable = false)
    private String fundCd;

    @Id
    @Column(name = "JM_GR", length = 10, nullable = false)
    private String jmGr;

    @Id
    @Column(name = "JM_CD", length = 20, nullable = false)
    private String jmCd;

    @Id
    @Column(name = "BUY_DATE", length = 8, nullable = false)
    private String buyDate;

    @Id
    @Column(name = "CHASU", precision = 5, scale = 0, nullable = false)
    private BigDecimal chasu;

    @Column(name = "VC_OLD", precision = 18, scale = 4)
    private BigDecimal vcOld;

    @Column(name = "VC_OLD_DT")
    private LocalDate vcOldDt;
}
