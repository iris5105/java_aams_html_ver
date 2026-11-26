package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * W_JA036E 펀드별 배당내역(리포트) 목록 DTO (DataWindow: d_ja036e)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja036eDto {

    private String fundCd;
    private String mgCd;
    private Long fundColor;
    private String encAcctNo;
    private String acctNo;
    private String fstSeoljYmd;
    private String bfGyulYmd;
    private String haejiYmd;

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
}
