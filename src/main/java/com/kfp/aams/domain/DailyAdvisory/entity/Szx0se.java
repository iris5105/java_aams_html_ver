package com.kfp.aams.domain.daily.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Entity
@Table(name = "SZX0SE")
@IdClass(Szx0seId.class)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Szx0se {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "SERIES_G1", length = 30, nullable = false)
    private String seriesG1;

    @Id
    @Column(name = "SERIES_G2", length = 30, nullable = false)
    private String seriesG2;

    @Id
    @Column(name = "SERIES_GB", length = 10, nullable = false)
    private String seriesGb;

    @Column(name = "SERIES_NM", length = 100)
    private String seriesNm;

    @Column(name = "RET_SUSU")
    private BigDecimal retSusu;

    @Column(name = "RET_SUSU_GB", length = 1)
    private String retSusuGb;

    @Column(name = "FUTURES_INCLUDE", length = 1)
    private String futuresInclude;

    @Column(name = "USED", length = 1)
    private String used;

    @Column(name = "RE_SEOLJ_YEAR")
    private BigDecimal reSeoljYear;

    @Column(name = "SINTAK_GIGAN")
    private BigDecimal sintakGigan;

    @Column(name = "BOSU_GIGAN")
    private BigDecimal bosuGigan;

    @Column(name = "MOKPYO_SUIK_PER")
    private BigDecimal mokpyoSuikPer;

    @Column(name = "PRE_BASIC")
    private BigDecimal preBasic;

    @Column(name = "BASIC_PER")
    private BigDecimal basicPer;

    @Column(name = "SUCCESS_PER")
    private BigDecimal successPer;

    @Column(name = "MAGAM_USED", length = 1)
    private String magamUsed;

    @Column(name = "DP_USED", length = 1)
    private String dpUsed;

    @Column(name = "BM_GR", length = 20)
    private String bmGr;

    @Column(name = "GUGAN", length = 20)
    private String gugan;

    @Column(name = "GA", length = 20)
    private String ga;

    @Column(name = "BIGO", length = 200)
    private String bigo;
}
