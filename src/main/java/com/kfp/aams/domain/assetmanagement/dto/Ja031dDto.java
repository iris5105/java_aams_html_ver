package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * W_JA031D (타사)수익증권 매매내역 등록 DTO
 * 파워빌더 d_ja031d.srd 메타데이터 기반 1:1 매핑 (규칙 02 준수)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja031dDto {

    // --- Key & DB Fields (SJT5SG) ---
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String fundCd;
    private String tasaJmCd;
    private Long seqNo;
    private BigDecimal trJwa;
    private BigDecimal gijunga;
    private BigDecimal ggijunga;
    private BigDecimal trAek;
    private BigDecimal gtrJwa;
    private String trCoCd;
    private LocalDate gijungaYmd;
    private LocalDate sudoYmd;
    private String updJwa;
    private BigDecimal susu;
    private LocalDate orgTrYmd;
    private Long orgSeqNo;
    private LocalDate tasaSeoljYmd;

    // --- Join & Display Fields ---
    private String xxFundCd;
    private String fundNm;

    private String xxTasaJmCd;
    private String tasaFundNm;

    private String xxTrCoCd;
    private String trCoNm;

    private BigDecimal transUnit;

    private Integer pVisible;

    // --- CUD Status Fields (규칙 02 준수) ---
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus; // C: 등록, U: 수정, D: 삭제

    // Original keys for update
    private String originalFundCd;
    private String originalTasaJmCd;
    private Long originalSeqNo;
    private String originalTrCoCd;
    private LocalDate originalSudoYmd;

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

    public String getXxTasaJmCd() {
        return xxTasaJmCd != null ? xxTasaJmCd : tasaFundNm;
    }

    public void setXxTasaJmCd(String xxTasaJmCd) {
        this.xxTasaJmCd = xxTasaJmCd;
        if (this.tasaFundNm == null) this.tasaFundNm = xxTasaJmCd;
    }

    public String getTasaFundNm() {
        return tasaFundNm != null ? tasaFundNm : xxTasaJmCd;
    }

    public void setTasaFundNm(String tasaFundNm) {
        this.tasaFundNm = tasaFundNm;
        if (this.xxTasaJmCd == null) this.xxTasaJmCd = tasaFundNm;
    }

    public String getXxTrCoCd() {
        return xxTrCoCd != null ? xxTrCoCd : trCoNm;
    }

    public void setXxTrCoCd(String xxTrCoCd) {
        this.xxTrCoCd = xxTrCoCd;
        if (this.trCoNm == null) this.trCoNm = xxTrCoCd;
    }

    public String getTrCoNm() {
        return trCoNm != null ? trCoNm : xxTrCoCd;
    }

    public void setTrCoNm(String trCoNm) {
        this.trCoNm = trCoNm;
        if (this.xxTrCoCd == null) this.xxTrCoCd = trCoNm;
    }
}

