package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * USPM 포트폴리오 모델 변동성분석 (W_JA032C)
 * 1. 펀드/포트 목록 DTO (d_ja032c1.srd 기반)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja032cPortDto {

    private String corpGr;
    private String fymd;
    private String tymd;
    private String fundCd;
    private String fundNm;
    private String xxFundCd;
    private String portNum;
    private String tt;          // 변동성계산기준 코드 (dddw의 cd)
    private String sebuCdNm;    // 변동성계산기준 명칭 (dddw의 sebu_cd_nm / dscr)
    private String ttNm;        // 변동성계산기준 명칭 (호환성)
    private Long instDays;      // 분할일수
    private String mangi;       // 만기일 (YYYY-MM-DD)
    private Long dt;            // 잔존일수
    private BigDecimal z;       // PUT(z) 변동성
    private BigDecimal putZ;    // PUT(z) 변동성

    public String getSebuCdNm() {
        return sebuCdNm != null ? sebuCdNm : ttNm;
    }

    public void setSebuCdNm(String sebuCdNm) {
        this.sebuCdNm = sebuCdNm;
        if (this.ttNm == null) {
            this.ttNm = sebuCdNm;
        }
    }

    public String getTtNm() {
        return ttNm != null ? ttNm : sebuCdNm;
    }

    public void setTtNm(String ttNm) {
        this.ttNm = ttNm;
        if (this.sebuCdNm == null) {
            this.sebuCdNm = ttNm;
        }
    }

    // CUD 상태 관리 필드 (표준 규정 02)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    // 양방향 프로퍼티 표준 (Zero-Serialization-Loss)
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

    public BigDecimal getZ() {
        return z != null ? z : putZ;
    }

    public void setZ(BigDecimal z) {
        this.z = z;
        if (this.putZ == null) {
            this.putZ = z;
        }
    }

    public BigDecimal getPutZ() {
        return putZ != null ? putZ : z;
    }

    public void setPutZ(BigDecimal putZ) {
        this.putZ = putZ;
        if (this.z == null) {
            this.z = putZ;
        }
    }
}
