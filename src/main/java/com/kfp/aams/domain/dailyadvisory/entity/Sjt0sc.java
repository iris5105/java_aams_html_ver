package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "SJT0SC")
@IdClass(Sjt0scId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sjt0sc {

    @Id
    @Column(name = "CORP_GR", length = 10, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "YMD", nullable = false)
    private LocalDate ymd;

    @Id
    @Column(name = "JM_CD", length = 20, nullable = false)
    private String jmCd;

    @Column(name = "DANG_GIJUN_GA", precision = 18, scale = 4)
    private BigDecimal dangGijunGa;

    @Column(name = "JUN_GIJUN_GA", precision = 18, scale = 4)
    private BigDecimal junGijunGa;

    @Column(name = "GYUL_GIJUN_GA", precision = 18, scale = 4)
    private BigDecimal gyulGijunGa;

    @Column(name = "BF_SIGA_AEK", precision = 18, scale = 4)
    private BigDecimal bfSigaAek;

    @Column(name = "LOAD_SIGA_AEK", precision = 18, scale = 4)
    private BigDecimal loadSigaAek;

    @Column(name = "BIGO", length = 200)
    private String bigo;

    @Column(name = "DANG_GGIJUN_GA", precision = 18, scale = 4)
    private BigDecimal dangGgijunGa;

    @Column(name = "GYUL_GGIJUN_GA", precision = 18, scale = 4)
    private BigDecimal gyulGgijunGa;
}
