package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA035B 해외주식 매매내역 DTO (DataWindow: d_ja035b)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja035bDto {

    private String corpGr;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String trCoCd;
    private String trustee;
    private String yjCd;             // JM_CD
    private Long bsType;
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
    private String countCost;
    private String secCode;
    private String settLocation;
    private String countBic;
    private BigDecimal transRt;
    private BigDecimal wonGyuljeAek;
    private BigDecimal wonChuiAek;
    private Integer pVisible;

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

    // CUD 상태 플래그
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus; // C: 신규, U: 수정, D: 삭제
}
