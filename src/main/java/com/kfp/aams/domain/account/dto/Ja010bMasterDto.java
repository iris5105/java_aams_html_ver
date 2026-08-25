package com.kfp.aams.domain.account.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja010bMasterDto {
    private String corpGr;          // CORP_GR
    private String mgCd;            // MG_CD
    private String mgNm;            // Computed via F_BALH_NM
    private String encAcctNo;       // ENC_ACCT_NO
    private String acctNo;          // Decrypted ENC_ACCT_NO
    private String fstSeoljYmd;     // FST_SEOLJ_YMD
    private Integer reSeoljYear;    // RE_SEOLJ_YEAR
    private String unyongSabun;     // UNYONG_SABUN
    private String fundNm;          // FUND_NM
    private Integer sintakGigan;    // SINTAK_GIGAN
    private Integer bosuGigan;      // BOSU_GIGAN
    private Double reSeoljAek;      // RE_SEOLJ_AEK
    private String seriesGb;        // SERIES_GB
    private Double basicPer;        // BASIC_PER
    private Double bmPer;           // BM_PER
    private Double successPer;      // SUCCESS_PER
    private String taxGb;           // TAX_GB
    private String mgUyYn;          // MG_UY_YN
    private String fdCsGb;          // FD_CS_GB
    private String updUser;         // UPD_USER
    private String updDate;         // UPD_DATE
    private String fundCd;          // FUND_CD
    private String fundCreDate;     // FUND_CRE_DATE
    private String haejiYmd;        // HAEJI_YMD
    private String haejiUpdDate;    // HAEJI_UPD_DATE
    private String typeGb;          // TYPE_GB
    private String typeGbNm;        // Calculated type name
    private String bfGyulYmd;       // BF_GYUL_YMD
    private String afGyulYmd;       // AF_GYUL_YMD
    private Integer gyulGi;         // GYUL_GI
    private String haejiGb;         // HAEJI_GB
    private String jijum;           // JIJUM
    private String mngSawon;        // MNG_SAWON
    private String juso1;           // JUSO1
    private String juso2;           // JUSO2
    private String tel1;            // TEL1
    private String email1;          // EMAIL1
    private String reSeoljYmd;      // RE_SEOLJ_YMD
    private String susuGugan;       // SUSU_GUGAN
    private Double susuRt;          // SUSU_RT
    private String orderSend;       // ORDER_SEND
    private String aliasCode;       // ALIAS_CODE
    private String targetJasan;     // TARGET_JASAN
    private String specialNote;     // SPECIAL_NOTE
    private String noteText;        // Computed NOTE text
    private Double preBasic;        // PRE_BASIC
    private String expenseYn;       // EXPENSE_YN
}
