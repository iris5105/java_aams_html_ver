package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 현금/단기금융 매매현황 펀드 마스터 DTO (d_ja031g.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja031gMasterDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 펀드번호 (관리번호) */
    private String fundCd;

    /** 계좌명 (펀드명) */
    private String fundNm;

    /** 명칭 컬럼 (Rule 02: Zero-Serialization-Loss) */
    private String xxFundCd;

    public String getXxFundCd() {
        return xxFundCd != null ? xxFundCd : fundNm;
    }

    public void setXxFundCd(String xxFundCd) {
        this.xxFundCd = xxFundCd;
        if (this.fundNm == null) this.fundNm = xxFundCd;
    }

    public String getFundNm() {
        return fundNm != null ? fundNm : xxFundCd;
    }

    public void setFundNm(String fundNm) {
        this.fundNm = fundNm;
        if (this.xxFundCd == null) this.xxFundCd = fundNm;
    }
}

