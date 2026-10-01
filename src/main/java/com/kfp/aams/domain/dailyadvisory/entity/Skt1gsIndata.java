package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "SKT1GS_INDATA")
@IdClass(Skt1gsIndataId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Skt1gsIndata {

    @Id
    @Column(name = "CORP_GR", length = 10, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "GYUL_YMD", nullable = false)
    private LocalDate gyulYmd;

    @Id
    @Column(name = "FUND_CD", length = 20, nullable = false)
    private String fundCd;

    @Column(name = "BASIC_BOSU", precision = 18, scale = 4)
    private BigDecimal basicBosu;

    @Column(name = "SUCCESS_BOSU", precision = 18, scale = 4)
    private BigDecimal successBosu;

    @Column(name = "TOTAL_BOSU", precision = 18, scale = 4)
    private BigDecimal totalBosu;

    @Column(name = "RECONTRACT_AEK", precision = 18, scale = 4)
    private BigDecimal recontractAek;

    @Column(name = "WM_SEOLJ_AEK", precision = 18, scale = 4)
    private BigDecimal wmSeoljAek;

    @Column(name = "WM_SONIK", precision = 18, scale = 4)
    private BigDecimal wmSonik;

    @Column(name = "DOC_NO", length = 100)
    private String docNo;

    @Column(name = "HAEJI_SAYU", length = 200)
    private String haejiSayu;

    @Column(name = "SEND_MAIL_ADDR", length = 200)
    private String sendMailAddr;

    @Column(name = "SEND_CC_ADDR", length = 200)
    private String sendCcAddr;

    @Column(name = "PRODUCT_NM", length = 100)
    private String productNm;

    @Column(name = "CONTRACT_CONDITION", length = 500)
    private String contractCondition;

    @Column(name = "SEND_DT")
    private LocalDateTime sendDt;
}
