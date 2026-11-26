package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA035P 마스터 DTO (DataWindow: d_ja035p1, 테이블: SYT9MG)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja035pMasterDto {

    private String corpGr;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String trustee;
    private String hjCd;        // syt9mg.jm_cd
    private Long trSeq;
    private String aekGb;
    private String currency;
    private String trCoCd;
    private BigDecimal aek;
    private BigDecimal janAek;
    private BigDecimal wonAek;
    private BigDecimal wonJanAek;
    private String sanghwYmd;
    private String bfYmd;
    private String afYmd;
    private String bigo;
    private String gwamok;
    private BigDecimal gijunRt;
    private BigDecimal wonSanghwAek;
    private Integer pVisible;

    // 수정/삭제 시 원본 키 보존용
    private String origTrYmd;
    private String origTrCd;
    private String origFundCd;
    private String origHjCd;
    private Long origTrSeq;
    private String origAekGb;

    // 양방향 명칭 프로퍼티
    private String xxFundCd;
    private String fundNm;
    private String xxHjCd;
    private String xxJmNm;

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

    public String getXxHjCd() {
        return xxHjCd != null ? xxHjCd : xxJmNm;
    }

    public void setXxHjCd(String xxHjCd) {
        this.xxHjCd = xxHjCd;
        if (this.xxJmNm == null) {
            this.xxJmNm = xxHjCd;
        }
    }

    public String getXxJmNm() {
        return xxJmNm != null ? xxJmNm : xxHjCd;
    }

    public void setXxJmNm(String xxJmNm) {
        this.xxJmNm = xxJmNm;
        if (this.xxHjCd == null) {
            this.xxHjCd = xxJmNm;
        }
    }

    // CUD 상태 관리 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
