package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "SJM0JM_COLL")
@IdClass(Sjm0jmCollId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sjm0jmColl {

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
    @Column(name = "JM_CD", length = 20, nullable = false)
    private String jmCd;

    @Column(name = "COLL_JUSU", precision = 18, scale = 4)
    private BigDecimal collJusu;

    @Column(name = "COLLATERAL", precision = 18, scale = 4)
    private BigDecimal collateral;

    @Column(name = "COLL_START")
    private LocalDate collStart;

    @Column(name = "COLL_END")
    private LocalDate collEnd;
}
