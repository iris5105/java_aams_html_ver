package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.Data;

import java.math.BigDecimal;

/** W_JA036J1 엑셀/클립보드 종가 반영 행 DTO. */
@Data
public class Ja036j1ImportDto {
    private String linkedCode;
    private String stockName;
    private BigDecimal closePrice;
}
