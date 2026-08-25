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
public class Ja010bIoDto {
    private String corpGr;          // CORP_GR
    private String fundCd;          // FUND_CD
    private String trYmd;           // TR_YMD
    private Double wonbonAek;       // WONBON_AEK
    private Double inAek;           // IN_AEK
    private Double outAek;          // OUT_AEK
    private Double giganPer;        // GIGAN_PER
    private Double giganAmt;        // GIGAN_AMT
    private Integer giganIlsu;      // GIGAN_ILSU
    private Integer passIlsu;       // PASS_ILSU
    private Double ioJo;            // IO_JO
    private String modDt;           // MOD_DT
    private String modUser;         // MOD_USER
    private String modYn;           // Computed MOD_YN
}
