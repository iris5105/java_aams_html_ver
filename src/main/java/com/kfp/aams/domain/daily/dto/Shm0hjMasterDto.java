package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_shm0hj.srd (SHM0HJ + SZM0IA + szx2mm)
 * Columns and data types directly mapped from d_shm0hj.srd table definition.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Shm0hjMasterDto {

    // Key & Identifying columns
    private String corpGr;          // char(8)
    private String fundCd;          // char(12)
    private String fundNm;          // szm0ia.fund_nm char(80) (alias xx_fund_cd)
    private String jmCd;            // char(30)
    private String cdJigubGb;       // char(1)
    private BigDecimal aekm;        // decimal(0)
    private String balhYmd;         // datetime -> YYYY-MM-DD string
    private String cashCd;          // char(2)
    private BigDecimal chuiAek;     // decimal(0)
    private String hjNm;            // char(80)
    private String meibYmd;         // datetime -> YYYY-MM-DD string
    private BigDecimal pyomIyul;    // number
    private String afIjaYmd;        // datetime -> YYYY-MM-DD string
    private String bojngGb;         // char(1)
    private BigDecimal nowIjaHoicha;// decimal(0)
    private BigDecimal sanghwAek;   // decimal(0)
    private String sanghwYmd;       // datetime -> YYYY-MM-DD string
    private String sunhuGb;         // char(1)
    private BigDecimal yyIjaHoicha; // number
    private BigDecimal ijaYySu;     // number
    private String meibMkGb;        // char(1)
    private BigDecimal meibSuikRt;  // number
    private BigDecimal totIjaGugan; // number
    private String offerCoCd;       // char(5)
    private String giupGyumo;       // char(1)
    private BigDecimal trAek;       // decimal(0)
    private String sunhuTaxGb;      // char(1)
    private String taxOfferGb;      // char(1)
    private String daeyeoGb;        // char(2)
    private String brokerCd;        // char(5)
    private BigDecimal susuGa;      // decimal(0)
    private BigDecimal meibSuikRtPer; // number (meib_suik_rt * 100)
    private BigDecimal pyomIyulPer;   // number (pyom_iyul * 100)
    private String bojngCo;         // char(5) (alias bojng_cd)
    private String trCoNm;          // szx2mm.tr_co_nm char(80) (alias xx_tr_co_cd)
    private BigDecimal sungCost;    // decimal(0)
    private String opYmd;           // datetime -> YYYY-MM-DD string
    private String ksdJmCd;         // char(12)
    private BigDecimal seqNo;       // decimal(0)
    private BigDecimal susu09900;   // number
    private String ksdJm5;          // char(3)
    private String ksdJm8;          // char(2)
    private String pgCd;            // char(4)
    private Integer pVisible;       // number (calculated)
}
