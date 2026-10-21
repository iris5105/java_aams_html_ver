package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 종목별 위험값 (W_JA032M) - 종목별 위험값 상세 DTO (d_ja032m2.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032mDetailDto {

    private String corpGr;
    private String ymd;
    private String fundCd;
    private String fundNm;
    private String xxFundNm;

    private String trustee;
    private String jmCd;
    private String sym0yzJmCd;
    private String jmNm;
    private String sym0yaJmNm;
    private BigDecimal hangsaGa;
    private BigDecimal sym0yaHangsaGa;
    private String layString;
    private String lsyYmd;
    private String currency;

    private BigDecimal jusu;
    private BigDecimal aek;
    private BigDecimal trPyungaAek;
    private BigDecimal optNominalAmt;

    private BigDecimal impJonga;
    private BigDecimal impVolatility;
    private BigDecimal delta;
    private BigDecimal gamma;
    private BigDecimal vega;

    private BigDecimal deltaRiskValue;
    private BigDecimal gammaRiskValue;
    private BigDecimal vegaRiskValue;
    private BigDecimal riskValue;

    private String jasanGb;
    private Long jasanCount;
    private BigDecimal sonikRyul;

    // CUD 상태 플래그 (규정 02-3 표준)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    // 양방향 프로퍼티 표준 (Zero-Serialization-Loss, 규정 02-2)
    public String getXxFundNm() {
        return xxFundNm != null ? xxFundNm : fundNm;
    }

    public void setXxFundNm(String xxFundNm) {
        this.xxFundNm = xxFundNm;
        if (this.fundNm == null) {
            this.fundNm = xxFundNm;
        }
    }

    public String getFundNm() {
        return fundNm != null ? fundNm : xxFundNm;
    }

    public void setFundNm(String fundNm) {
        this.fundNm = fundNm;
        if (this.xxFundNm == null) {
            this.xxFundNm = fundNm;
        }
    }

    public String getJmCd() {
        return jmCd != null ? jmCd : sym0yzJmCd;
    }

    public void setJmCd(String jmCd) {
        this.jmCd = jmCd;
        if (this.sym0yzJmCd == null) {
            this.sym0yzJmCd = jmCd;
        }
    }

    public String getSym0yzJmCd() {
        return sym0yzJmCd != null ? sym0yzJmCd : jmCd;
    }

    public void setSym0yzJmCd(String sym0yzJmCd) {
        this.sym0yzJmCd = sym0yzJmCd;
        if (this.jmCd == null) {
            this.jmCd = sym0yzJmCd;
        }
    }

    public String getJmNm() {
        return jmNm != null ? jmNm : sym0yaJmNm;
    }

    public void setJmNm(String jmNm) {
        this.jmNm = jmNm;
        if (this.sym0yaJmNm == null) {
            this.sym0yaJmNm = jmNm;
        }
    }

    public String getSym0yaJmNm() {
        return sym0yaJmNm != null ? sym0yaJmNm : jmNm;
    }

    public void setSym0yaJmNm(String sym0yaJmNm) {
        this.sym0yaJmNm = sym0yaJmNm;
        if (this.jmNm == null) {
            this.jmNm = sym0yaJmNm;
        }
    }
}
