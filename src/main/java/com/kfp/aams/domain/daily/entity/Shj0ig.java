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
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "SHJ0IG")
@IdClass(Shj0igId.class)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Shj0ig {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "JM_CD", length = 30, nullable = false)
    private String jmCd;

    @Id
    @Column(name = "GUGAN_NO", nullable = false)
    private BigDecimal guganNo;

    @Column(name = "GUGAN_ILSU")
    private BigDecimal guganIlsu;

    @Column(name = "GUGAN_IJA")
    private BigDecimal guganIja;

    @Column(name = "BF_IJA_YMD")
    private LocalDate bfIjaYmd;

    @Column(name = "AF_IJA_YMD")
    private LocalDate afIjaYmd;

    @Column(name = "IP_USER", length = 40)
    private String ipUser;

    @Column(name = "IP_YMD")
    private LocalDateTime ipYmd;

    @Column(name = "PLATFORM_FEE")
    private BigDecimal platformFee;

    @Column(name = "PLATFORM_YMD")
    private LocalDate platformYmd;

    @Column(name = "FIX_IJA_AEK")
    private BigDecimal fixIjaAek;

    @Column(name = "OTHER_COST")
    private BigDecimal otherCost;

    @Column(name = "OTHER_COST_END_YMD")
    private LocalDate otherCostEndYmd;
}
