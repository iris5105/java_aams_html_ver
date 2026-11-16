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
@Table(name = "\"SJT0JK\"")
@IdClass(Sjt0jkId.class)
public class Sjt0jk {
    @Column(name = "TR_YMD") private LocalDate trYmd;
    @Id @Column(name = "TR_CD") private String trCd;
    @Id @Column(name = "BALH_CO") private String balhCo;
    @Id @Column(name = "JEUNGJ_MTH") private String jeungjMth;
    @Column(name = "BAEJ_MTH") private String baejMth;
    @Column(name = "BALH_GA") private BigDecimal balhGa;
    @Column(name = "WOOS_BALH_GA") private BigDecimal woosBalhGa;
    @Column(name = "JEKYNG_RT") private BigDecimal jekyngRt;
    @Column(name = "WOOS_JEKYNG_RT") private BigDecimal woosJekyngRt;
    @Column(name = "BAED_GISAN_YMD") private LocalDate baedGisanYmd;
    @Column(name = "CHENG_YMD") private LocalDate chengYmd;
    @Id @Column(name = "KRAK_YMD") private LocalDate krakYmd;
    @Column(name = "BAEJ_GIJUN_YMD") private LocalDate baejGijunYmd;
    @Column(name = "JUKM_NABIB_YMD") private LocalDate jukmNabibYmd;
    @Column(name = "SINJ_JAEW") private String sinjJaew;
    @Column(name = "ILBAN_BALH_JUSU") private BigDecimal ilbanBalhJusu;
    @Column(name = "WOOS_BALH_JUSU") private BigDecimal woosBalhJusu;
}
