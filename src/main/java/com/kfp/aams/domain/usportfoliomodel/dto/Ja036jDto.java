package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.Data;

import java.math.BigDecimal;

/** W_JA036J 해외 유가증권 종가/단가 관리 목록 DTO. */
@Data
public class Ja036jDto {
    private String corpGr;
    private String ymd;
    private String jasanGb;
    private String yjCd;
    private String xxYjCd;
    private String blbgTckr;
    private String isinCd;
    private String currency;
    private BigDecimal jonga;
    private BigDecimal danga;
    private String loadTime;
    private String pxCloseDt;
    private BigDecimal pxLast;
    private String pxDt1d;
    private BigDecimal pxClose1d;
    private BigDecimal pxYestCloseExchUnadj;
    private BigDecimal junJonga;
    private BigDecimal junDanga;
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
