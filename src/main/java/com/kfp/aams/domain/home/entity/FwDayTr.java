package com.kfp.aams.domain.home.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;

@Entity
@Table(name = "FW_DAY_TR")
@Getter
@Setter
@NoArgsConstructor
@IdClass(FwDayTrId.class)
public class FwDayTr {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "YMD", length = 8, nullable = false)
    private String ymd;

    @Id
    @Column(name = "TR_CD", length = 3, nullable = false)
    private String trCd;

    @Column(name = "JASAN_GB", length = 30)
    private String jasanGb;

    @Column(name = "TR_COUNT")
    private Long trCount;

    @Column(name = "TR_AEK", precision = 18, scale = 2)
    private BigDecimal trAek;

    @Column(name = "FUND_COUNT")
    private Long fundCount;
}
