package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.Data;

import java.math.BigDecimal;

/** W_JA036J1 해외주식 종가 관리 목록 DTO. */
@Data
public class Ja036j1Dto {
    private String corpGr;
    private String ymd;
    private String currency;
    private String yjCd;
    private String xxYjCd;
    private BigDecimal jonga;
    private BigDecimal danga;
    private String loadTime;
    private String blbgTckr;
    private BigDecimal junJonga;
    private BigDecimal junDanga;
    private BigDecimal gijunRt;
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
}
