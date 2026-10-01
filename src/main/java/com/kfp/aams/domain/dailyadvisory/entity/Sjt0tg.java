package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "SJT0TG")
@IdClass(Sjt0tgId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sjt0tg {

    @Id
    @Column(name = "CORP_GR", length = 10, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "YMD", nullable = false)
    private LocalDate ymd;

    @Id
    @Column(name = "KOSCOM_CD", length = 20, nullable = false)
    private String koscomCd;

    @Column(name = "CLOSE", precision = 18, scale = 4)
    private BigDecimal close;

    @Column(name = "VOLUME", precision = 18, scale = 4)
    private BigDecimal volume;

    @Column(name = "VALUE", precision = 18, scale = 4)
    private BigDecimal value;

    @Column(name = "PRECLOSE", precision = 18, scale = 4)
    private BigDecimal preclose;

    @Column(name = "CHANGE", precision = 18, scale = 4)
    private BigDecimal change;

    @Column(name = "AEKM", precision = 18, scale = 4)
    private BigDecimal aekm;

    @Column(name = "SANGJ_JUSU", precision = 18, scale = 4)
    private BigDecimal sangjJusu;

    @Column(name = "MOD_DT")
    private LocalDateTime modDt;
}
