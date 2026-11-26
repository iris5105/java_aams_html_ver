package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA035Q 미지급/미수금 이월내역 관리 DTO (DataWindow: d_ja035q, 테이블: SYT0MC)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja035qDto {

    private String corpGr;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String trustee;
    private String currency;

    private BigDecimal bfilAek;
    private BigDecimal upAek;
    private BigDecimal dwAek;
    private BigDecimal wonBfilAek;
    private BigDecimal wonUpAek;
    private BigDecimal wonDwAek;
    private BigDecimal wonBfilHwanCha;
    private BigDecimal wonHwanCha;

    private String workdate;
    private String fundCurrency;
    private BigDecimal fcurAek;
    private BigDecimal syt0mcFcurHwanCha;

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
