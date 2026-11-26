package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA036B 외화배당금 수령등록 DTO (DataWindow: d_ja036b)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja036bDto {

    private String corpGr;
    private String ymd;
    private String pyungaJoin;
    private String ygRowid;

    private String churiYmd;
    private String gyuljeJmCd;
    private BigDecimal churiJusu;
    private BigDecimal aek;
    private BigDecimal taxAek;
    private BigDecimal wonAek;
    private BigDecimal wonTaxAek;
    private BigDecimal grossUpAek;

    private String trYmd;
    private String trCd;
    private String fundCd;
    private String jmCd;
    private String trustee;
    private String currency;
    private String hwakjYmd;
    private BigDecimal ygTaxAek;
    private BigDecimal ygGyuljeAek;
    private Integer chk;

    private String fundCurrency;
    private BigDecimal fcurGyuljeAek;
    private BigDecimal fcurHwanCha;
    private BigDecimal gyuljeAek;
    private BigDecimal wonGyuljeAek;

    // 명칭 컬럼 (양방향 프로퍼티)
    private String szm0iaFundNm;
    private String xxFundCd;
    private String sym0yaJmNm;
    private String xxJmCd;

    public String getSzm0iaFundNm() {
        return szm0iaFundNm != null ? szm0iaFundNm : xxFundCd;
    }

    public void setSzm0iaFundNm(String szm0iaFundNm) {
        this.szm0iaFundNm = szm0iaFundNm;
        if (this.xxFundCd == null) {
            this.xxFundCd = szm0iaFundNm;
        }
    }

    public String getXxFundCd() {
        return xxFundCd != null ? xxFundCd : szm0iaFundNm;
    }

    public void setXxFundCd(String xxFundCd) {
        this.xxFundCd = xxFundCd;
        if (this.szm0iaFundNm == null) {
            this.szm0iaFundNm = xxFundCd;
        }
    }

    public String getSym0yaJmNm() {
        return sym0yaJmNm != null ? sym0yaJmNm : xxJmCd;
    }

    public void setSym0yaJmNm(String sym0yaJmNm) {
        this.sym0yaJmNm = sym0yaJmNm;
        if (this.xxJmCd == null) {
            this.xxJmCd = sym0yaJmNm;
        }
    }

    public String getXxJmCd() {
        return xxJmCd != null ? xxJmCd : sym0yaJmNm;
    }

    public void setXxJmCd(String xxJmCd) {
        this.xxJmCd = xxJmCd;
        if (this.sym0yaJmNm == null) {
            this.sym0yaJmNm = xxJmCd;
        }
    }

    // CUD 상태 관리 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
