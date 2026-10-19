package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA035B2 해외파생 매매내역 DTO (DataWindow: d_ja035b2)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja035b2Dto {

    private String corpGr;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String trCoCd;
    private String trustee;
    private String yjCd;             // JM_CD
    private String currency;
    private Long trSeq;
    private BigDecimal trJusu;
    private BigDecimal trDanga;
    private BigDecimal trCost;
    private BigDecimal trAek;
    private BigDecimal nominalAmt;
    private String gyuljeYmd;
    private String gyuljeJmCd;
    private BigDecimal transRt;
    private String updUser;
    private String fundCurrency;

    // 양방향 프로퍼티: fundNm & xxFundCd
    private String xxFundCd;
    private String fundNm;

    public String getXxFundCd() {
        return xxFundCd != null ? xxFundCd : fundNm;
    }

    public void setXxFundCd(String xxFundCd) {
        this.xxFundCd = xxFundCd;
        if (this.fundNm == null) {
            this.fundNm = xxFundCd;
        }
    }

    public String getFundNm() {
        return fundNm != null ? fundNm : xxFundCd;
    }

    public void setFundNm(String fundNm) {
        this.fundNm = fundNm;
        if (this.xxFundCd == null) {
            this.xxFundCd = fundNm;
        }
    }

    // 양방향 프로퍼티: jmNm & xxYjCd
    private String xxYjCd;
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

    // 양방향 프로퍼티: sym0yaHangsaGa & hangsaGa
    private BigDecimal sym0yaHangsaGa;
    private BigDecimal hangsaGa;

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

    private BigDecimal unitAek;
    private Integer pVisible;

    // CUD 상태 플래그
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus; // C, U, D
}
