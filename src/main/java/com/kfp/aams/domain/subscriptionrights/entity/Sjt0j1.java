package com.kfp.aams.domain.subscriptionrights.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "\"SJT0J1\"")
@IdClass(Sjt0j1Id.class)
public class Sjt0j1 {
    @Id @Column(name = "CORP_GR") private String corpGr;
    @Id @Column(name = "YMD") private LocalDate ymd;
    @Id @Column(name = "BALH_CO") private String balhCo;
    @Id @Column(name = "JEUNGJ_MTH") private String jeungjMth;
    @Id @Column(name = "FUND_CD") private String fundCd;
    @Id @Column(name = "OLD_JM_CD") private String oldJmCd;
    @Id @Column(name = "NEW_JM_CD") private String newJmCd;
    @Column(name = "KRAK_JUSU") private BigDecimal krakJusu;
    @Column(name = "KRAK_CHUI_AEK") private BigDecimal krakChuiAek;
    @Column(name = "BAEJ_JUSU") private BigDecimal baejJusu;
    @Column(name = "BAEJ_RT") private BigDecimal baejRt;
    @Column(name = "BALH_GA") private BigDecimal balhGa;
    @Column(name = "CHUI_AEK") private BigDecimal chuiAek;
    @Column(name = "GOSI_JEKYNG_YMD") private LocalDate gosiJekyngYmd;
    @Column(name = "CHG_BF_JUSU") private BigDecimal chgBfJusu;
    @Column(name = "CHG_BF_RT") private BigDecimal chgBfRt;
    @Column(name = "CHG_BF_BALH_GA") private BigDecimal chgBfBalhGa;
    @Column(name = "CHG_CHUI_AEK") private BigDecimal chgChuiAek;
    @Column(name = "CHG_BF_YMD") private LocalDate chgBfYmd;
    @Column(name = "SURY_YMD") private LocalDate suryYmd;
    @Column(name = "SURY_JUSU") private BigDecimal suryJusu;
    @Column(name = "CHENG_YMD") private LocalDate chengYmd;
    @Column(name = "CHENG_JUSU") private BigDecimal chengJusu;
    @Id @Column(name = "HAEJI_FUND") private String haejiFund;
    @Column(name = "HAEJI_YMD") private LocalDate haejiYmd;
    @Id @Column(name = "TYPE_TRENCH") private String typeTrench;
    @Id @Column(name = "BS_TYPE") private BigDecimal bsType;
    @Column(name = "UPD_USER") private String updUser;
}
