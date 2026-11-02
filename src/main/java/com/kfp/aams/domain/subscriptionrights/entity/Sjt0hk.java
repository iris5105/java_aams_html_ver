package com.kfp.aams.domain.subscriptionrights.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.math.BigDecimal;

@Getter @Setter @NoArgsConstructor
@Entity @Table(name="\"SJT0HK\"") @IdClass(Sjt0hkId.class)
public class Sjt0hk {
    @Id @Column(name="TR_YMD")
    private LocalDate trYmd;
    @Id @Column(name="TR_CD")
    private String trCd;
    @Id @Column(name="HAB_CO")
    private String habCo;
    @Id @Column(name="PI_HAB_CO")
    private String piHabCo;
    @Column(name="HAB_ILBAN_RT")
    private BigDecimal habIlbanRt;
    @Column(name="HAB_WOOS_RT")
    private BigDecimal habWoosRt;
    @Column(name="HAB_ILBAN_AEK")
    private BigDecimal habIlbanAek;
    @Column(name="HAB_WOOS_AEK")
    private BigDecimal habWoosAek;
    @Column(name="GAM_ILBAN_RT")
    private BigDecimal gamIlbanRt;
    @Column(name="GAM_WOOS_RT")
    private BigDecimal gamWoosRt;
    @Column(name="GAM_ILBAN_AEK")
    private BigDecimal gamIlbanAek;
    @Column(name="GAM_WOOS_AEK")
    private BigDecimal gamWoosAek;
    @Column(name="PI_HAB_ILBAN_RT")
    private BigDecimal piHabIlbanRt;
    @Column(name="PI_HAB_WOOS_RT")
    private BigDecimal piHabWoosRt;
    @Column(name="PI_HAB_ILBAN_AEK")
    private BigDecimal piHabIlbanAek;
    @Column(name="PI_HAB_WOOS_AEK")
    private BigDecimal piHabWoosAek;
}

