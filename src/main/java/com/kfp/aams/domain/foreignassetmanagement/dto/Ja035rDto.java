package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.Data;

import java.math.BigDecimal;

/**
 * W_JA035R 외화주식 종목등록 화면 전용 DTO (d_ja035r1 / d_ja035r2 매핑)
 */
@Data
public class Ja035rDto {

    private String corpGr;
    private String jmCd;
    private String jmNm;
    private String jasanGb;
    private String jsJongryu;
    private String balhNation;
    private String currency;
    private BigDecimal aekm;
    private String sangjYmd;
    private BigDecimal sangjJusu;
    private String blbgTckr;
    private String blbgTckrText;
    private String isinCd;
    private String sigaAgent;
    private String jasanAttr;
    private String sjGb;
    private String sedol;
    private String fen0055;
    private String balhNm;
    private String jasan;
    private String gbx;
    private String stockGb;
    private String srsCd;
    private Integer pVisible;

    // Tabulator CUD 상태 관리 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
