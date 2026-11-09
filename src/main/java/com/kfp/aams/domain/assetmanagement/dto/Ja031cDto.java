package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class Ja031cDto {
    private String corpGr;
    private String fundCd;
    private String xxFundCd;
    private String trCoCd;
    private Integer trSeqNo;
    private BigDecimal trAek;
    private LocalDate trYmd;
    private String trCd;
    private String trustee;
    private String currency;
    private BigDecimal fcurTrAek;
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
