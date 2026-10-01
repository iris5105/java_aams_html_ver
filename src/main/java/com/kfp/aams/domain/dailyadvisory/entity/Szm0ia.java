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

@Entity
@Table(name = "SZM0IA")
@IdClass(Szm0iaId.class)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Szm0ia {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "FUND_CD", length = 12, nullable = false)
    private String fundCd;

    @Column(name = "ENC_ACCT_NO", length = 128)
    private String encAcctNo;

    @Column(name = "FUND_NM", length = 120)
    private String fundNm;

    @Column(name = "TYPE_GB", length = 4)
    private String typeGb;

    @Column(name = "FST_SEOLJ_YMD")
    private LocalDate fstSeoljYmd;

    @Column(name = "SINTAK_GIGAN")
    private Integer sintakGigan;

    @Column(name = "BF_GYUL_YMD")
    private LocalDate bfGyulYmd;

    @Column(name = "AF_GYUL_YMD")
    private LocalDate afGyulYmd;

    @Column(name = "PRE_BASIC")
    private BigDecimal preBasic;

    @Column(name = "BASIC_PER")
    private BigDecimal basicPer;

    @Column(name = "BM_PER")
    private BigDecimal bmPer;

    @Column(name = "SUCCESS_PER")
    private BigDecimal successPer;

    @Column(name = "SERIES_GB", length = 4)
    private String seriesGb;

    @Column(name = "TARGET_JASAN", length = 30)
    private String targetJasan;

    @Column(name = "GYUL_GI")
    private Integer gyulGi;

    @Column(name = "HAEJI_GB", length = 4)
    private String haejiGb;

    @Column(name = "HAEJI_YMD")
    private LocalDate haejiYmd;

    @Column(name = "RE_SEOLJ_YEAR")
    private Integer reSeoljYear;

    @Column(name = "RE_SEOLJ_AEK")
    private BigDecimal reSeoljAek;

    @Column(name = "MG_CD", length = 20)
    private String mgCd;

    @Column(name = "SUSU_RT")
    private BigDecimal susuRt;

    @Column(name = "EMAIL1", length = 120)
    private String email1;

    @Column(name = "RE_SEOLJ_YMD")
    private LocalDate reSeoljYmd;

    @Column(name = "UNYONG_SABUN", length = 20)
    private String unyongSabun;

    @Column(name = "ORDER_SEND", length = 4)
    private String orderSend;

    @Column(name = "EXPENSE_YN", length = 4)
    private String expenseYn;

    @Column(name = "ALIAS_CODE", length = 30)
    private String aliasCode;

    @Column(name = "SPECIAL_NOTE", length = 500)
    private String specialNote;
}
