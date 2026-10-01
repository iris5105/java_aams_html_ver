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
@Table(name = "SZT0IO")
@IdClass(Szt0ioId.class)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Szt0io {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "FUND_CD", length = 12, nullable = false)
    private String fundCd;

    @Id
    @Column(name = "TR_YMD", nullable = false)
    private LocalDate trYmd;

    @Column(name = "IN_AEK")
    private BigDecimal inAek;

    @Column(name = "OUT_AEK")
    private BigDecimal outAek;

    @Column(name = "WONBON_AEK")
    private BigDecimal wonbonAek;

    @Column(name = "IO_JO")
    private BigDecimal ioJo;

    @Column(name = "GIGAN_ILSU")
    private Integer giganIlsu;

    @Column(name = "PASS_ILSU")
    private Integer passIlsu;

    @Column(name = "MOD_DT")
    private java.time.LocalDateTime modDt;

    @Column(name = "MOD_USER", length = 50)
    private String modUser;
}
