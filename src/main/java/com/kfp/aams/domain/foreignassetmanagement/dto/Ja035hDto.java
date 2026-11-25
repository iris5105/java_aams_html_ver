package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA035H 외화 NOTE이자수령 DTO (DataWindow: d_ja035h)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja035hDto {

    private String corpGr;
    private String ymd;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String trCoCd;              // d_ja035h: xx_mg_cd (syt0ys.tr_co_cd)
    private String trustee;
    private String yjCd;                // d_ja035h: yj_cd (syt0ys.jm_cd)
    private String currency;
    private Long trSeq;
    private String gyuljeYmd;
    private BigDecimal gyuljeAek;
    private BigDecimal wonGyuljeAek;
    private String gyuljeGb;
    private String gyuljeJmCd;
    private String jasanGb;
    private BigDecimal wonHwanCha;
    private BigDecimal suryAek;
    private Long bsType;
    private String fundCurrency;
    private BigDecimal fcurGyuljeAek;
    private BigDecimal syt0ysFcurHwanCha;
    private BigDecimal bunhalAek;
    private Integer pVisible;

    // 수정/삭제 시 원본 키 보존용
    private String origFundCd;
    private String origYjCd;
    private String origTrustee;
    private String origTrCoCd;

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
    private String rowStatus;
}
