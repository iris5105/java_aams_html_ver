package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * W_JA031A 선물매매 거래 등록 DTO
 * 파워빌더 d_ja031a1.srd 메타데이터 기반 1:1 매핑
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja031aDto {

    // --- Key & DB Fields (SST1KT) ---
    private String corpGr;
    private LocalDate trYmd;
    private String fundCd;
    private String trCd;
    private String sjCd;
    private Integer chasu;
    private Long trSeqNo;
    private BigDecimal gyeySu;
    private BigDecimal gyeyJisu;
    private String trCoCd;
    private String susuTrCoCd;
    private BigDecimal gyeyAek;
    private String ipUser;
    private String cutoffGb;

    // --- Join & Display Fields ---
    private String xxFundCd;
    private String fundNm;

    private String xxSjCd;
    private String sjNm;

    private String xxSusuTrCoCd;
    private String susuTrCoNm;

    private BigDecimal xxUnitAek;
    private BigDecimal unitAek;

    private String xxMgCd;

    // --- Computed Fields ---
    private BigDecimal yakjungAek; // compute_3: gyey_su * gyey_jisu * xx_unit_aek
    private BigDecimal chaAek;     // compute_6: gyey_aek - (gyey_su * gyey_jisu * xx_unit_aek)

    private Integer pVisible;

    // --- CUD Status Fields (규칙 02 준수) ---
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus; // C: 등록, U: 수정, D: 삭제

    // Original keys for update
    private String originalFundCd;
    private String originalSjCd;
    private Long originalTrSeqNo;

    // --- 양방향 프로퍼티 표준 (Zero-Serialization-Loss) ---
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

    public String getXxSjCd() {
        return xxSjCd != null ? xxSjCd : sjNm;
    }

    public void setXxSjCd(String xxSjCd) {
        this.xxSjCd = xxSjCd;
        if (this.sjNm == null) this.sjNm = xxSjCd;
    }

    public String getSjNm() {
        return sjNm != null ? sjNm : xxSjCd;
    }

    public void setSjNm(String sjNm) {
        this.sjNm = sjNm;
        if (this.xxSjCd == null) this.xxSjCd = sjNm;
    }

    public String getXxSusuTrCoCd() {
        return xxSusuTrCoCd != null ? xxSusuTrCoCd : susuTrCoNm;
    }

    public void setXxSusuTrCoCd(String xxSusuTrCoCd) {
        this.xxSusuTrCoCd = xxSusuTrCoCd;
        if (this.susuTrCoNm == null) this.susuTrCoNm = xxSusuTrCoCd;
    }

    public String getSusuTrCoNm() {
        return susuTrCoNm != null ? susuTrCoNm : xxSusuTrCoCd;
    }

    public void setSusuTrCoNm(String susuTrCoNm) {
        this.susuTrCoNm = susuTrCoNm;
        if (this.xxSusuTrCoCd == null) this.xxSusuTrCoCd = susuTrCoNm;
    }

    public BigDecimal getXxUnitAek() {
        return xxUnitAek != null ? xxUnitAek : unitAek;
    }

    public void setXxUnitAek(BigDecimal xxUnitAek) {
        this.xxUnitAek = xxUnitAek;
        if (this.unitAek == null) this.unitAek = xxUnitAek;
    }

    public BigDecimal getUnitAek() {
        return unitAek != null ? unitAek : xxUnitAek;
    }

    public void setUnitAek(BigDecimal unitAek) {
        this.unitAek = unitAek;
        if (this.xxUnitAek == null) this.xxUnitAek = unitAek;
    }
}

