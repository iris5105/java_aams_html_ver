package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * W_JA031M 기타비용 출금등록 DTO
 * 파워빌더 d_ja031m.srd 메타데이터 기반 1:1 매핑 (규칙 02 준수)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja031mDto {

    // --- Key & DB Fields (SKT0HS) ---
    private String corpGr;
    private LocalDate trYmd;
    private String fundCd;
    private String trCd;
    private String trCoCd;
    private BigDecimal hwanibAek;
    private BigDecimal balAek;
    private LocalDate bfYmd;
    private LocalDate afYmd;
    private String bigo;

    // --- Display & Name Fields ---
    private String xxFundCd;
    private String fundNm;

    private String xxTrCoCd;
    private String trCoNm;

    private Integer pVisible;

    // --- CUD Status Fields (규칙 02 준수) ---
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus; // C: 등록, U: 수정, D: 삭제

    // Original keys for update
    private String originalFundCd;

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

