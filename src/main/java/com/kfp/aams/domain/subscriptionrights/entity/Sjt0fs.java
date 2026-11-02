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
@Table(name = "\"SJT0FS\"")
@IdClass(Sjt0fsId.class)
public class Sjt0fs {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "TR_YMD", nullable = false)
    private LocalDate trYmd;

    @Id
    @Column(name = "TR_CD", length = 3, nullable = false)
    private String trCd;

    @Id
    @Column(name = "FUND_CD", length = 12, nullable = false)
    private String fundCd;

    @Id
    @Column(name = "JM_CD", length = 30, nullable = false)
    private String jmCd;

    @Id
    @Column(name = "TYPE_TRENCH", length = 20, nullable = false)
    private String typeTrench = "00:";

    @Id
    @Column(name = "BS_TYPE", nullable = false)
    private BigDecimal bsType = BigDecimal.ZERO;

    @Column(name = "KOSCOM_CD", length = 12)
    private String koscomCd;

    @Column(name = "HWAKJ_AEK")
    private BigDecimal hwakjAek;

    @Column(name = "SURY_AEK")
    private BigDecimal suryAek;

    @Column(name = "DANGA")
    private BigDecimal danga;

    @Column(name = "CHUI_AEK")
    private BigDecimal chuiAek;

    @Column(name = "TAX")
    private BigDecimal tax;

    @Column(name = "SUSU")
    private BigDecimal susu;

    @Column(name = "UPD_USER", length = 40)
    private String updUser;

    @Column(name = "CY_TYPE", length = 1)
    private String cyType = "2";

    @Column(name = "BROK_YMD")
    private LocalDate brokYmd;
}

