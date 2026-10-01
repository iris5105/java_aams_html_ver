package com.kfp.aams.domain.dailyadvisory.entity;

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
@Table(name = "SHM0HJ")
@IdClass(Shm0hjId.class)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Shm0hj {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "JM_CD", length = 12, nullable = false)
    private String jmCd;

    @Column(name = "FUND_CD", length = 12)
    private String fundCd;

    @Column(name = "CASH_CD", length = 4)
    private String cashCd;

    @Column(name = "HJ_NM", length = 120)
    private String hjNm;

    @Column(name = "KSD_JM_CD", length = 20)
    private String ksdJmCd;

    @Column(name = "PG_CD", length = 20)
    private String pgCd;

    @Column(name = "AEKM")
    private BigDecimal aekm;

    @Column(name = "CHUI_AEK")
    private BigDecimal chuiAek;

    @Column(name = "TR_AEK")
    private BigDecimal trAek;

    @Column(name = "SANGHW_AEK")
    private BigDecimal sanghwAek;

    @Column(name = "BALH_YMD")
    private LocalDate balhYmd;

    @Column(name = "MEIB_YMD")
    private LocalDate meibYmd;

    @Column(name = "SANGHW_YMD")
    private LocalDate sanghwYmd;

    @Column(name = "AF_IJA_YMD")
    private LocalDate afIjaYmd;

    @Column(name = "PYOM_IYUL")
    private BigDecimal pyomIyul;

    @Column(name = "MEIB_SUIK_RT")
    private BigDecimal meibSuikRt;

    @Column(name = "CD_JIGUB_GB", length = 4)
    private String cdJigubGb;

    @Column(name = "BOJNG_GB", length = 4)
    private String bojngGb;

    @Column(name = "SUNHU_GB", length = 4)
    private String sunhuGb;

    @Column(name = "MEIB_MK_GB", length = 4)
    private String meibMkGb;

    @Column(name = "SUNHU_TAX_GB", length = 4)
    private String sunhuTaxGb;

    @Column(name = "TAX_OFFER_GB", length = 4)
    private String taxOfferGb;

    @Column(name = "DAEYEO_GB", length = 4)
    private String daeyeoGb;

    @Column(name = "BROKER_CD", length = 20)
    private String brokerCd;

    @Column(name = "OFFER_CO_CD", length = 20)
    private String offerCoCd;

    @Column(name = "BOJNG_CO", length = 20)
    private String bojngCo;

    @Column(name = "GIUP_GYUMO", length = 4)
    private String giupGyumo;

    @Column(name = "SUSU_GA")
    private BigDecimal susuGa;

    @Column(name = "NOW_IJA_HOICHA")
    private BigDecimal nowIjaHoicha;

    @Column(name = "YY_IJA_HOICHA")
    private BigDecimal yyIjaHoicha;

    @Column(name = "IJA_YY_SU")
    private BigDecimal ijaYySu;

    @Column(name = "TOT_IJA_GUGAN")
    private BigDecimal totIjaGugan;

    @Column(name = "SUNG_COST")
    private BigDecimal sungCost;

    @Column(name = "OP_YMD")
    private LocalDate opYmd;

    @Column(name = "SEQ_NO")
    private BigDecimal seqNo;

    @Column(name = "SUSU_09900")
    private BigDecimal susu09900;

    @Column(name = "KSD_JM5", length = 20)
    private String ksdJm5;

    @Column(name = "KSD_JM8", length = 20)
    private String ksdJm8;
}
