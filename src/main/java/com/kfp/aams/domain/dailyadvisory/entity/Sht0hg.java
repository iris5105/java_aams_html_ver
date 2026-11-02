package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "\"SHT0HG\"")
@IdClass(Sht0hgId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sht0hg {

    @Id @Column(name = "CORP_GR", length = 10, nullable = false) private String corpGr;
    @Id @Column(name = "TR_YMD", nullable = false) private LocalDate trYmd;
    @Id @Column(name = "TR_CD", length = 3, nullable = false) private String trCd;
    @Id @Column(name = "FUND_CD", length = 12, nullable = false) private String fundCd;
    @Id @Column(name = "JM_CD", length = 20, nullable = false) private String jmCd;
    @Id @Column(name = "SEQ_NO", precision = 8, scale = 0, nullable = false) private BigDecimal seqNo;

    @Column(name = "AEKM") private BigDecimal aekm;
    @Column(name = "TR_AEK") private BigDecimal trAek;
    @Column(name = "TR_CO_CD", length = 5) private String trCoCd;
    @Column(name = "MK_SUIK_RT") private BigDecimal mkSuikRt;
    @Column(name = "SANGHW_AEK") private BigDecimal sanghwAek;
    @Column(name = "SUSU_GA") private BigDecimal susuGa;
    @Column(name = "TAX_OFFER_GB", length = 1) private String taxOfferGb;
    @Column(name = "JAJUN_GB", length = 1) private String jajunGb;
    @Column(name = "SUNG_COST") private BigDecimal sungCost;
    @Column(name = "AUTO_PER") private BigDecimal autoPer;
    @Column(name = "SUSU_09900") private BigDecimal susu09900;
    @Column(name = "SUNSU_IJA") private BigDecimal sunsuIja;
    @Column(name = "MIJIGUB_TAX") private BigDecimal mijigubTax;
}
