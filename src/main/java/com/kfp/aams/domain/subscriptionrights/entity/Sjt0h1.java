package com.kfp.aams.domain.subscriptionrights.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.math.BigDecimal;

@Getter @Setter @NoArgsConstructor
@Entity @Table(name="\"SJT0H1\"") @IdClass(Sjt0h1Id.class)
public class Sjt0h1 {
    @Id @Column(name="CORP_GR")
    private String corpGr;
    @Id @Column(name="TR_YMD")
    private LocalDate trYmd;
    @Id @Column(name="TR_CD")
    private String trCd;
    @Id @Column(name="HAB_CO")
    private String habCo;
    @Id @Column(name="PI_HAB_CO")
    private String piHabCo;
    @Id @Column(name="FUND_CD")
    private String fundCd;
    @Id @Column(name="OLD_JM_CD")
    private String oldJmCd;
    @Id @Column(name="NEW_JM_CD")
    private String newJmCd;
    @Column(name="BOYU_JUSU")
    private BigDecimal boyuJusu;
    @Column(name="CHUI_AEK")
    private BigDecimal chuiAek;
    @Column(name="HAB_PER")
    private BigDecimal habPer;
    @Column(name="HAB_JUSU")
    private BigDecimal habJusu;
    @Column(name="HAB_CHUI_AEK")
    private BigDecimal habChuiAek;
    @Column(name="HAB_GYOUB_AEK")
    private BigDecimal habGyoubAek;
    @Column(name="GAM_PER")
    private BigDecimal gamPer;
    @Column(name="GAM_JUSU")
    private BigDecimal gamJusu;
    @Column(name="JUSU_SURY_YMD")
    private LocalDate jusuSuryYmd;
    @Column(name="SURY_JUSU")
    private BigDecimal suryJusu;
    @Column(name="AEK_SURY_YMD")
    private LocalDate aekSuryYmd;
    @Column(name="SURY_AEK")
    private BigDecimal suryAek;
    @Column(name="DEL_YN")
    private String delYn;
    @Id @Column(name="TYPE_TRENCH")
    private String typeTrench;
    @Id @Column(name="BS_TYPE")
    private BigDecimal bsType;
}

