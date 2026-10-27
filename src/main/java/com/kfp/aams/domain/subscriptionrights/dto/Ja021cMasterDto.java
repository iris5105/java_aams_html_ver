package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja021cMasterDto {

    private String corpGr;
    private String trYmd;
    private String trCd;
    private String balhCo;
    private String xxBalhCo;
    private String balhNm;

    private String baedMth;
    private String baejMth;

    private BigDecimal ilbanAek;
    private BigDecimal woosAek;

    private BigDecimal cashIlbanRt;
    private BigDecimal cashWoosRt;
    private BigDecimal cashIlbanPer;
    private BigDecimal cashWoosPer;

    private BigDecimal stockIlbanRt;
    private BigDecimal stockWoosRt;
    private BigDecimal stockIlbanPer;
    private BigDecimal stockWoosPer;

    private String brokYmd;
    private String baedGisanYmd;
    private String juchongYmd;

    // t31 / t41 (확정 탭 비교 필드)
    private String bkTrYmd;
    private String bkTrCd;
    private String bkBalhCo;
    private String bkBaedMth;
    private String bkBaejMth;

    private BigDecimal bkCashIlbanRt;
    private BigDecimal bkCashWoosRt;
    private BigDecimal bkStockIlbanRt;
    private BigDecimal bkStockWoosRt;

    private BigDecimal bkStockWoosPer;
    private BigDecimal bkStockIlbanPer;
    private BigDecimal bkCashWoosPer;
    private BigDecimal bkCashIlbanPer;

    private String bkBrokYmd;
    private String bkJuchongYmd;
    private BigDecimal bkIlbanAek;
    private BigDecimal bkWoosAek;

    private Integer pVisible;
    private Integer fontColor;
    private Integer trSort;

    // CUD 상태 관리 (Zero-Serialization-Loss)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public String getXxBalhCo() {
        return xxBalhCo != null ? xxBalhCo : balhNm;
    }

    public void setXxBalhCo(String xxBalhCo) {
        this.xxBalhCo = xxBalhCo;
        if (this.balhNm == null) this.balhNm = xxBalhCo;
    }

    public String getBalhNm() {
        return balhNm != null ? balhNm : xxBalhCo;
    }

    public void setBalhNm(String balhNm) {
        this.balhNm = balhNm;
        if (this.xxBalhCo == null) this.xxBalhCo = balhNm;
    }
}
