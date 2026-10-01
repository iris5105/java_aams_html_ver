package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "SJT1JG")
@IdClass(Sjt1jgId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sjt1jg {

    @Id
    @Column(name = "CORP_GR", length = 10, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "TR_YMD", nullable = false)
    private LocalDate trYmd;

    @Id
    @Column(name = "TR_CD", length = 10, nullable = false)
    private String trCd;

    @Id
    @Column(name = "TR_CO_CD", length = 20, nullable = false)
    private String trCoCd;

    @Id
    @Column(name = "OFFER_NO", nullable = false)
    private Long offerNo;

    @Column(name = "ENC_ACCT_NO", length = 100)
    private String encAcctNo;

    @Column(name = "JM_CD", length = 20)
    private String jmCd;

    @Column(name = "KOSCOM_CD", length = 20)
    private String koscomCd;

    @Column(name = "TR_JUSU", precision = 18, scale = 4)
    private BigDecimal trJusu;

    @Column(name = "TR_AEK", precision = 18, scale = 4)
    private BigDecimal trAek;

    @Column(name = "FUND_CD", length = 20)
    private String fundCd;

    @Column(name = "DANC_GB", length = 10)
    private String dancGb;

    @Column(name = "SUSU", precision = 18, scale = 4)
    private BigDecimal susu;

    @Column(name = "TAX", precision = 18, scale = 4)
    private BigDecimal tax;

    @Column(name = "SUDO_YMD")
    private LocalDate sudoYmd;

    @Column(name = "LOAD_TIME")
    private LocalDateTime loadTime;

    @Column(name = "LOAD_USER", length = 50)
    private String loadUser;
}
