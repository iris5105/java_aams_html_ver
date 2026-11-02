package com.kfp.aams.domain.assetmanagement.entity;

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
import java.time.LocalDate;

/** SJT5J1 - 신주인수권 매매 내역. */
@Entity
@Table(name = "SJT5J1")
@IdClass(Sjt5j1Id.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sjt5j1 {
    @Id @Column(name = "CORP_GR", length = 8, nullable = false) private String corpGr;
    @Id @Column(name = "TR_YMD", nullable = false) private LocalDate trYmd;
    @Id @Column(name = "TR_CD", length = 3, nullable = false) private String trCd;
    @Id @Column(name = "JM_CD", length = 30, nullable = false) private String jmCd;
    @Id @Column(name = "FUND_CD", length = 12, nullable = false) private String fundCd;
    @Id @Column(name = "BALH_CO", length = 5, nullable = false) private String balhCo;
    @Id @Column(name = "TYPE_TRENCH", length = 20, nullable = false) private String typeTrench;
    @Id @Column(name = "BS_TYPE", precision = 1, scale = 0, nullable = false) private BigDecimal bsType;

    @Column(name = "KRAK_YMD") private LocalDate krakYmd;
    @Column(name = "CHG_BF_BALH_GA", precision = 7, scale = 0) private BigDecimal chgBfBalhGa;
    @Column(name = "CHG_BF_YMD") private LocalDate chgBfYmd;
    @Column(name = "BALH_GA", precision = 7, scale = 0) private BigDecimal balhGa;
    @Column(name = "GOSI_JEKYNG_YMD") private LocalDate gosiJekyngYmd;
    @Column(name = "TR_JUSU", precision = 13, scale = 0) private BigDecimal trJusu;
    @Column(name = "TR_DANGA", precision = 7, scale = 0) private BigDecimal trDanga;
    @Column(name = "TR_AEK", precision = 17, scale = 0) private BigDecimal trAek;
    @Column(name = "SUSU", precision = 13, scale = 0) private BigDecimal susu;
    @Column(name = "GYUL_AEK", precision = 17, scale = 0) private BigDecimal gyulAek;
    @Column(name = "TR_CO_CD", length = 5) private String trCoCd;
    @Column(name = "CHENG_YMD") private LocalDate chengYmd;
}
