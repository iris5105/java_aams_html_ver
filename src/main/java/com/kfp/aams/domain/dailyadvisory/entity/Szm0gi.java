package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "SZM0GI")
@IdClass(Szm0giId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Szm0gi {

    @Id
    @Column(name = "CORP_GR", length = 10, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "FUND_CD", length = 20, nullable = false)
    private String fundCd;

    @Id
    @Column(name = "BF_GYUL_YMD", nullable = false)
    private LocalDate bfGyulYmd;

    @Column(name = "GYUL_GI")
    private Integer gyulGi;

    @Column(name = "AF_GYUL_YMD")
    private LocalDate afGyulYmd;

    @Column(name = "ILSU")
    private Integer ilsu;

    @Column(name = "GI_SONIK_AEK", precision = 18, scale = 4)
    private BigDecimal giSonikAek;

    @Column(name = "WM_SEOLJ_AEK", precision = 18, scale = 4)
    private BigDecimal wmSeoljAek;

    @Column(name = "WM_DT")
    private LocalDate wmDt;

    @Column(name = "HAEJI_YMD")
    private LocalDate haejiYmd;

    @Column(name = "INCHUL_YMD")
    private LocalDate inchulYmd;

    @Column(name = "IN_AEK", precision = 18, scale = 4)
    private BigDecimal inAek;

    @Column(name = "DIST_CALC", length = 20)
    private String distCalc;

    @Column(name = "AF_GIJUN", precision = 18, scale = 4)
    private BigDecimal afGijun;
}
