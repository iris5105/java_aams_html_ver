package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class Ja030dDto {
    private String corpGr, trCd, fundCd, jmCd, originalFundCd, originalJmCd, trCoCd, xxTrCoCd, xxFundCd, xxJmCd, jajunGb, dangaGb, jajunSayu, buyDate, creUser;
    private LocalDate trYmd, sudoYmd;
    private BigDecimal seqNo, aekm, danga, comDanga, trAek, susu, sodukTax, juminTax, ijaTax, mkSuikRt, comMkSuikRt, chuiAek, boyuAekm, ijaAekm;
    private Integer pVisible;
    private Boolean isNew, isUpdated;
}
