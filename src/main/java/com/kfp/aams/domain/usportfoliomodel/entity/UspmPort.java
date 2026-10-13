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
@Table(name = "USPM_PORT")
@IdClass(UspmPortId.class)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UspmPort {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "TYMD", nullable = false)
    private LocalDate tymd;

    @Id
    @Column(name = "FUND_CD", length = 12, nullable = false)
    private String fundCd;

    @Id
    @Column(name = "PORT_NUM", length = 2, nullable = false)
    private String portNum;

    @Column(name = "FYMD")
    private LocalDate fymd;

    @Column(name = "TT", length = 1)
    private String tt;

    @Column(name = "INST_DAYS")
    private Integer instDays;

    @Column(name = "MANGI")
    private LocalDate mangi;

    @Column(name = "DT")
    private Long dt;

    @Column(name = "PUT_Z", precision = 15, scale = 4)
    private BigDecimal putZ;

    @Column(name = "JM_PER", precision = 15, scale = 4)
    private BigDecimal jmPer;

    @Column(name = "USD_TUJA", precision = 20, scale = 2)
    private BigDecimal usdTuja;

    @Column(name = "YEAR_BETA", precision = 15, scale = 4)
    private BigDecimal yearBeta;

    @Column(name = "MON_BETA", precision = 15, scale = 4)
    private BigDecimal monBeta;

    @Column(name = "PRICE_PER", precision = 15, scale = 4)
    private BigDecimal pricePer;
}
