package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "SJX0JB")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sjx0jb {

    @Id
    @Column(name = "BALH_CO", length = 20, nullable = false)
    private String balhCo;

    @Column(name = "BALH_NM", length = 100)
    private String balhNm;

    @Column(name = "TR_STOP_GB", length = 10)
    private String trStopGb;

    @Column(name = "SOSOK_GB", length = 10)
    private String sosokGb;

    @Column(name = "AEKM", precision = 18, scale = 4)
    private BigDecimal aekm;

    @Column(name = "GR_BALH_GB", length = 10)
    private String grBalhGb;

    @Column(name = "BUDO_YMD")
    private LocalDate budoYmd;

    @Column(name = "COMP_CD", length = 20)
    private String compCd;

    @Column(name = "GYUL_MM", length = 10)
    private String gyulMm;

    @Column(name = "ISIN_CD", length = 20)
    private String isinCd;

    @Column(name = "COMP_BU", length = 20)
    private String compBu;

    @Column(name = "BALH_NATION", length = 20)
    private String balhNation;

    @Column(name = "ENC_BUBIN_NO", length = 100)
    private String encBubinNo;

    @Column(name = "DEL_YN", length = 1)
    private String delYn;
}
