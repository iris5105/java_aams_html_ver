package com.kfp.aams.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SubscriptionDto {
    private String corpGr;
    private String jcJoin;
    private String jgTrCoCd;
    private String scYmd;
    private Long scJusu;
    private BigDecimal scDanga;
    private BigDecimal scAek;
    private String scUser;
    private String cyYmd;
    private Long cyJusu;
    private BigDecimal cyDanga;
    private BigDecimal cyAek;
    private BigDecimal cyJkm;
    private String cyUser;
    private String lockEnd;
    private String sjg1jcJcJoin;
    private String ymd;
    private String balhCo;
    private String sjg1jcJgTrCoCd;
    private String sjg1jcJgTrCoNm;
    private String jgTrCoNm;
    private String jmNm;
    private String xxBalhCo;
    private String cyGb;
    private String sjYmd;
    private String sjJmCd;
    private String startYmd;
    private String endYmd;
    private String jmCd;
}
