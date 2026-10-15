package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 기준정보 옵션위험값 일별현황 (W_JA032B_OPT) - 종목 목록 DTO (d_ja032b.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032bOptStockDto {

    private String corpGr;
    private String ymd;
    private String fundCd;
    private String yjCd;        // jmCd
    private String jmNm;
    private String xxYjCd;
    private String srsCd;
    private BigDecimal syt0lpJonga;
    private BigDecimal marketCapitalization;
    private Integer days;
    private BigDecimal shortPrice;
    private BigDecimal gijunPrice;
    private BigDecimal d30Volatility;
    private BigDecimal g30Volatility;
    private String highValue;
    private String highYmd;
    private String lowValue;
    private String lowYmd;
    private String ovrsExcgCd;   // 1: 해외, 2: KRX

    // 양방향 프로퍼티 표준 (Zero-Serialization-Loss, 규정 02-2)
    public String getXxYjCd() {
        return xxYjCd != null ? xxYjCd : jmNm;
    }

    public void setXxYjCd(String xxYjCd) {
        this.xxYjCd = xxYjCd;
        if (this.jmNm == null) {
            this.jmNm = xxYjCd;
        }
    }

    public String getJmNm() {
        return jmNm != null ? jmNm : xxYjCd;
    }

    public void setJmNm(String jmNm) {
        this.jmNm = jmNm;
        if (this.xxYjCd == null) {
            this.xxYjCd = jmNm;
        }
    }
}
