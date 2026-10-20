package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * w_ja050c 펀드 목록 DTO (d_fund_select.srd 매핑)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja050cFundDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String corpGr;
    private String fundCd;
    private String fundNm;
    private String xxFundCd;
    private String typeGb;
    private String fundCurrency;
    private String fundSelect;
    private String haejiYmd;

    // CUD 상태 플래그
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    // xx_ 명칭 양방향 프로퍼티 (Zero-Serialization-Loss)
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
}
