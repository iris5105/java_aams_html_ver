package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "SCT0CG")
@IdClass(Sct0cgId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sct0cg {

    @Id
    @Column(name = "CORP_GR", length = 10, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "TR_YMD", nullable = false)
    private LocalDate trYmd;

    @Id
    @Column(name = "TR_CD", length = 10, nullable = false)
    private String trCd;

    @Id
    @Column(name = "SEQ_NO", precision = 5, scale = 0, nullable = false)
    private BigDecimal seqNo;

    @Column(name = "FUND_CD", length = 20)
    private String fundCd;

    @Column(name = "JM_CD", length = 20)
    private String jmCd;

    @Column(name = "BUY_DATE", length = 8)
    private String buyDate;

    @Column(name = "TR_CO_CD", length = 20)
    private String trCoCd;

    @Column(name = "AEKM", precision = 18, scale = 4)
    private BigDecimal aekm;

    @Column(name = "DANGA", precision = 18, scale = 4)
    private BigDecimal danga;

    @Column(name = "TR_AEK", precision = 18, scale = 4)
    private BigDecimal trAek;

    @Column(name = "SUSU", precision = 18, scale = 4)
    private BigDecimal susu;

    @Column(name = "SUDO_YMD")
    private LocalDate sudoYmd;

    @Column(name = "MK_SUIK_RT", precision = 18, scale = 6)
    private BigDecimal mkSuikRt;

    @Column(name = "PG_CD", length = 20)
    private String pgCd;

    @Column(name = "JAJUN_GB", length = 10)
    private String jajunGb;

    @Column(name = "CHUI_AEK", precision = 18, scale = 4)
    private BigDecimal chuiAek;

    @Column(name = "DANGA_GB", length = 10)
    private String dangaGb;

    @Column(name = "JAJUN_SAYU", length = 200)
    private String jajunSayu;

    @Column(name = "IJA_AEKM", precision = 18, scale = 4)
    private BigDecimal ijaAekm;
}
