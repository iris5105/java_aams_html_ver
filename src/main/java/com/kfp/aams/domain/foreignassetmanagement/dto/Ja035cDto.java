package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.Data;

import java.math.BigDecimal;

/** d_ja035c.srd row model. */
@Data
public class Ja035cDto {
    private String corpGr;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String trCoCd;
    private String trustee;
    private String yjCd;
    private Long trSeq;
    private String currency;
    private BigDecimal gyuljeAek;
    private BigDecimal transRt;
    private BigDecimal wonGyuljeAek;
    private String gyuljeYmd;
    private String xxFundCd;
    private String xxYjCd;
    private String fundCurrency;
    private BigDecimal fcurGyuljeAek;
    private String ksdJmCd;
    private String xxKsdJmCd;
    private Integer pVisible;
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
