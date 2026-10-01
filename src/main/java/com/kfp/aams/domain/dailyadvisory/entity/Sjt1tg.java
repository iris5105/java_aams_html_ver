package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "SJT1TG")
@IdClass(Sjt1tgId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sjt1tg {

    @Id
    @Column(name = "KOSCOM_CD", length = 20, nullable = false)
    private String koscomCd;

    @Id
    @Column(name = "YMD", nullable = false)
    private LocalDate ymd;

    @Column(name = "CLOSE", precision = 18, scale = 4)
    private BigDecimal close;

    @Column(name = "VOLUME", precision = 18, scale = 4)
    private BigDecimal volume;

    @Column(name = "VALUE", precision = 18, scale = 4)
    private BigDecimal value;

    @Column(name = "PRECLOSE", precision = 18, scale = 4)
    private BigDecimal preclose;

    @Column(name = "SPOT_PRICE", precision = 18, scale = 4)
    private BigDecimal spotPrice;

    @Column(name = "CALC_PRICE", precision = 18, scale = 4)
    private BigDecimal calcPrice;

    @Column(name = "CHANGE", precision = 18, scale = 4)
    private BigDecimal change;

    @Column(name = "MOD_DT")
    private java.time.LocalDateTime modDt;
}
