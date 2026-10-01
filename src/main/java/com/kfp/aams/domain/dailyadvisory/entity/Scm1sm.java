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
@Table(name = "SCM1SM")
@IdClass(Scm1smId.class)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Scm1sm {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "YMD", nullable = false)
    private LocalDate ymd;

    @Id
    @Column(name = "JM_CD", length = 12, nullable = false)
    private String jmCd;

    @Column(name = "AS_CJ_CD", length = 12)
    private String asCjCd;

    @Column(name = "DANGA")
    private BigDecimal danga;

    @Column(name = "JY_SUIK_RT")
    private BigDecimal jySuikRt;

    @Column(name = "CHGTIME")
    private LocalDateTime chgtime;
}
