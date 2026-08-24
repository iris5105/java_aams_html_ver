package com.kfp.aams.domain.home.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PublicStockDto {
    private String jcJoin;
    private String ymd;
    private String cyGb;
    private String balhCo;
    private String jmNm;
    private String jgTrCoCd;
    private String jgTrCoNm;
    private String startYmd;
    private String endYmd;
    private String sjYmd;
    private String nabibYmd;
    private String cyJmCd;
    private String sjJmCd;
    private BigDecimal susuPer;
    private String xxCyJmCd;
    private String xxSjJmCd;
}
