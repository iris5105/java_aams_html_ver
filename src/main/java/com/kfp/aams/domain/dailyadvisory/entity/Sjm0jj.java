package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "SJM0JJ")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sjm0jj {

    @Id
    @Column(name = "JM_CD", length = 20, nullable = false)
    private String jmCd;

    @Column(name = "KOSCOM_CD", length = 20)
    private String koscomCd;

    @Column(name = "JJ_FNM", length = 100)
    private String jjFnm;

    @Column(name = "JJ_NM", length = 50)
    private String jjNm;

    @Column(name = "JJ_ENM", length = 100)
    private String jjEnm;

    @Column(name = "BALH_CO", length = 20)
    private String balhCo;

    @Column(name = "WOOS_ILBAN_GB", length = 10)
    private String woosIlbanGb;

    @Column(name = "CHG_GB", length = 10)
    private String chgGb;

    @Column(name = "NEW_OLD_GB", length = 10)
    private String newOldGb;

    @Column(name = "DANC_GB", length = 10)
    private String dancGb;

    @Column(name = "BALH_GA", precision = 18, scale = 4)
    private BigDecimal balhGa;

    @Column(name = "KWEONRI_YMD")
    private LocalDate kweonriYmd;

    @Column(name = "SANGJ_YMD")
    private LocalDate sangjYmd;

    @Column(name = "SANGJ_JUSU", precision = 18, scale = 4)
    private BigDecimal sangjJusu;

    @Column(name = "UPJ_CD", length = 20)
    private String upjCd;

    @Column(name = "CREATED_YMD")
    private LocalDateTime createdYmd;

    @Column(name = "DEL_YN", length = 1)
    private String delYn;

    @Column(name = "CAPSIZE", length = 20)
    private String capsize;

    @Column(name = "KOSPIGUBUN", length = 20)
    private String kospigubun;

    @Column(name = "WOOS_VOTE_YMD")
    private LocalDate woosVoteYmd;

    @Column(name = "UNDER", length = 20)
    private String under;

    @Column(name = "BAED_GISAN_YMD")
    private LocalDate baedGisanYmd;

    @Column(name = "ISIN_CD", length = 20)
    private String isinCd;

    @Column(name = "A0231", length = 20)
    private String a0231;

    @Column(name = "DEPOSIT", length = 20)
    private String deposit;

    @Column(name = "CHG_RT", precision = 18, scale = 4)
    private BigDecimal chgRt;
}
