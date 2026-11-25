package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA035B3 해외선물 매매등록 DTO (DataWindow: d_ja035b3)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja035b3Dto {

    private String corpGr;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String trCoCd;
    private String trustee;
    private String yjCd;                    // SYT0MG.JM_CD
    private Long trSeq;
    private String currency;
    private BigDecimal trJusu;
    private BigDecimal trDanga;
    private BigDecimal trTax;
    private BigDecimal trCost;
    private BigDecimal trAek;
    private String gyuljeYmd;
    private BigDecimal gyuljeAek;
    private String gyuljeJmCd;
    private BigDecimal mkSuikPer;
    private BigDecimal transRt;
    private BigDecimal passIja;
    private BigDecimal wonPassIja;
    private BigDecimal wonGyuljeAek;
    private BigDecimal unitAek;
    private Long bsType;
    private String fundCurrency;
    private BigDecimal syt0mgFcurGyuljeAek;
    private BigDecimal syt0mgFcurSonik;
    private BigDecimal syt0mgFcurHwanCha;
    private Integer pVisible;

    // 양방향 명칭 프로퍼티
    private String xxFundCd;
    private String fundNm;
    private String xxYjCd;
    private String jmNm;

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

    // CUD 상태 관리 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus; // C, U, D
}
