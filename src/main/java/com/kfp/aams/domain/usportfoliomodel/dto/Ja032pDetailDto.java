package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 기준정보 옵션종목 일별현황 (W_JA032P) - 옵션종목 보유현황 DTO (d_ja032p2.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032pDetailDto {

    private String corpGr;
    private String ymd;
    private String fundCd;
    private String xxFundNm;
    private String fundNm;

    private String trustee;          // PORT
    private String sym0yzJmCd;       // 종목코드
    private String jmCd;
    private String sym0yaJmNm;       // 종목명
    private String jmNm;
    private BigDecimal sym0yaHangsaGa; // 행사가격
    private BigDecimal hangsaGa;
    private String lsyYmd;           // 만기일자
    private String currency;

    private BigDecimal jusu;              // 수량
    private BigDecimal aek;               // 취득액
    private BigDecimal trPyungaAek;       // 평가금액
    private BigDecimal optNominalAmt;     // 명목금액
    private BigDecimal impJonga;          // 종가
    private BigDecimal impVolatility;     // 내재변동성
    private BigDecimal delta;             // 델타
    private BigDecimal gamma;             // 감마
    private BigDecimal vega;              // 베가
    private BigDecimal deltaRiskValue;    // 델타위험값
    private BigDecimal gammaRiskValue;    // 감마위험값
    private BigDecimal vegaRiskValue;     // 베가위험값
    private BigDecimal riskValue;         // 위험값합계

    // UI 소계/합계 표시용 메타 필드
    private Boolean isSummaryRow;
    private String summaryType;

    // 양방향 프로퍼티 표준 (Zero-Serialization-Loss)
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

    public String getSym0yzJmCd() {
        return sym0yzJmCd != null ? sym0yzJmCd : jmCd;
    }

    public void setSym0yzJmCd(String sym0yzJmCd) {
        this.sym0yzJmCd = sym0yzJmCd;
        if (this.jmCd == null) {
            this.jmCd = sym0yzJmCd;
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

    public String getSym0yaJmNm() {
        return sym0yaJmNm != null ? sym0yaJmNm : jmNm;
    }

    public void setSym0yaJmNm(String sym0yaJmNm) {
        this.sym0yaJmNm = sym0yaJmNm;
        if (this.jmNm == null) {
            this.jmNm = sym0yaJmNm;
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

    public BigDecimal getSym0yaHangsaGa() {
        return sym0yaHangsaGa != null ? sym0yaHangsaGa : hangsaGa;
    }

    public void setSym0yaHangsaGa(BigDecimal sym0yaHangsaGa) {
        this.sym0yaHangsaGa = sym0yaHangsaGa;
        if (this.hangsaGa == null) {
            this.hangsaGa = sym0yaHangsaGa;
        }
    }

    public BigDecimal getHangsaGa() {
        return hangsaGa != null ? hangsaGa : sym0yaHangsaGa;
    }

    public void setHangsaGa(BigDecimal hangsaGa) {
        this.hangsaGa = hangsaGa;
        if (this.sym0yaHangsaGa == null) {
            this.sym0yaHangsaGa = hangsaGa;
        }
    }
}
