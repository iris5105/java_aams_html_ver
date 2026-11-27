package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.Data;

import java.math.BigDecimal;

/**
 * W_JA035A 외화 단기유동자산 종목 등록 (d_ja035a / SYM0YA) DTO
 */
@Data
public class Ja035aDto {

    private String corpGr;
    private String jmCd;
    private String jmNm;
    private String jasanGb;
    private Integer seqNo;
    private String balhNation;
    private String currency;
    private BigDecimal ijaPer;
    private String balhYmd;
    private String sanghwYmd;
    private String gyuljeJm;
    private String jasanAttr;
    private String sedol;
    private Integer pVisible;

    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
