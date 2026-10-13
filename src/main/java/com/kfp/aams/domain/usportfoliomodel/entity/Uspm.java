package com.kfp.aams.domain.usportfoliomodel.entity;

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
@Table(name = "USPM")
@IdClass(UspmId.class)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Uspm {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "YMD", nullable = false)
    private LocalDate ymd;

    @Id
    @Column(name = "FUND_CD", length = 12, nullable = false)
    private String fundCd;

    @Id
    @Column(name = "PORT_NUM", length = 2, nullable = false)
    private String portNum;

    @Id
    @Column(name = "JM_CD", length = 30, nullable = false)
    private String jmCd;

    @Column(name = "USD_TUJA", precision = 20, scale = 2)
    private BigDecimal usdTuja;

    @Column(name = "TARGET_RETURN_PER", precision = 15, scale = 4)
    private BigDecimal targetReturnPer;

    @Column(name = "PRICE_PER", precision = 15, scale = 4)
    private BigDecimal pricePer;

    @Column(name = "COL")
    private Integer col;

    @Column(name = "OVRS_EXCG_CD", length = 4)
    private String ovrsExcgCd;
}
