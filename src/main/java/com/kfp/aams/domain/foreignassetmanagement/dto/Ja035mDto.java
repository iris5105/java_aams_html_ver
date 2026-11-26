package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA035M 해외보관처수익등록 DTO (DataWindow: d_ja035m)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja035mDto {

    private String corpGr;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String trustee;
    private String currency;
    private Long trSeq;
    private BigDecimal trAek;
    private BigDecimal wonTrAek;
    private BigDecimal balAek;
    private BigDecimal wonBalAek;
    private BigDecimal taxAek;
    private BigDecimal wonTaxAek;
    private String gyuljeYmd;
    private String fundCurrency;
    private BigDecimal syt0maFcurTrAek;
    private BigDecimal syt0maFcurBalAek;
    private Integer pVisible;

    // 수정/삭제 시 원본 키 보존용
    private String origFundCd;
    private String origTrustee;
    private String origCurrency;
    private Long origTrSeq;
    private String origGyuljeYmd;

    // 양방향 명칭 프로퍼티 (xx_fund_cd <-> fundNm)
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

    // CUD 상태 관리 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
