package com.kfp.aams.domain.usportfoliomodel.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja032a3 / d_ja032a3a (USPM)
 * US Portfolio Model 포트 내 종목 상세 목록
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032aDetailDto {

    private String corpGr;
    private String ymd;
    private String fundCd;
    private String portNum;

    @JsonProperty("yjCd")
    private String yjCd; // JM_CD

    @JsonProperty("xxYjCd")
    private String xxYjCd; // JM_NM
    private String jmNm;

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

    private BigDecimal usdTuja;
    private BigDecimal targetReturnPer;
    private BigDecimal pricePer;
    private Integer col;
    private String ovrsExcgCd;
    private BigDecimal stockChui;
    private BigDecimal optNominalAmt;

    // 계산 필드: usdTuja - stockChui - optNominalAmt
    private BigDecimal settableAmount;
    private Integer pVisible;

    // CUD 관리 플래그
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
