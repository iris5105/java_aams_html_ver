package com.kfp.aams.domain.dailyadvisory.entity;

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
import java.time.LocalDateTime;

@Entity
@Table(name = "SHT0YE")
@IdClass(Sht0yeId.class)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Sht0ye {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "TR_YMD", nullable = false)
    private LocalDate trYmd;

    @Id
    @Column(name = "FUND_CD", length = 12, nullable = false)
    private String fundCd;

    @Id
    @Column(name = "TR_CO_CD", length = 20, nullable = false)
    private String trCoCd;

    @Column(name = "T0_AEK")
    private BigDecimal t0Aek;

    @Column(name = "T1_AEK")
    private BigDecimal t1Aek;

    @Column(name = "T2_AEK")
    private BigDecimal t2Aek;

    @Column(name = "STOCK_AEK")
    private BigDecimal stockAek;

    @Column(name = "BOND_AEK")
    private BigDecimal bondAek;

    @Column(name = "RP_AEK")
    private BigDecimal rpAek;

    @Column(name = "TOT_AEK")
    private BigDecimal totAek;

    @Column(name = "ENC_ACCT_NO", length = 128)
    private String encAcctNo;

    @Column(name = "BIGO", length = 250)
    private String bigo;

    @Column(name = "CONF_YMD")
    private LocalDateTime confYmd;
}
