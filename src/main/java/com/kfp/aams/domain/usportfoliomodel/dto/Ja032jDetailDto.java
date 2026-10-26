package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 해외주식종가/업종지수 등록 (W_JA032J) 디테일 DTO
 * - DataWindow: d_ja032j2.srd (SYT0LP 해외주식/지수 일별 종가 내역)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032jDetailDto {

    /** 회사그룹 */
    private String corpGr;

    /** 기준일자 (YYYY-MM-DD) */
    private String ymd;

    /** 종목코드 (d_ja032j2에서는 yj_cd) */
    private String yjCd;
    private String jmCd;

    public String getYjCd() {
        return yjCd != null ? yjCd : jmCd;
    }

    public void setYjCd(String yjCd) {
        this.yjCd = yjCd;
        if (this.jmCd == null) this.jmCd = yjCd;
    }

    public String getJmCd() {
        return jmCd != null ? jmCd : yjCd;
    }

    public void setJmCd(String jmCd) {
        this.jmCd = jmCd;
        if (this.yjCd == null) this.yjCd = jmCd;
    }

    /** 종가 */
    private BigDecimal jonga;

    /** 거래량 */
    private BigDecimal syt0lpTvol;
    private BigDecimal tvol;

    public BigDecimal getSyt0lpTvol() {
        return syt0lpTvol != null ? syt0lpTvol : tvol;
    }

    public void setSyt0lpTvol(BigDecimal syt0lpTvol) {
        this.syt0lpTvol = syt0lpTvol;
        if (this.tvol == null) this.tvol = syt0lpTvol;
    }

    public BigDecimal getTvol() {
        return tvol != null ? tvol : syt0lpTvol;
    }

    public void setTvol(BigDecimal tvol) {
        this.tvol = tvol;
        if (this.syt0lpTvol == null) this.syt0lpTvol = tvol;
    }

    /** 거래대금 */
    private BigDecimal syt0lpTamt;
    private BigDecimal tamt;

    public BigDecimal getSyt0lpTamt() {
        return syt0lpTamt != null ? syt0lpTamt : tamt;
    }

    public void setSyt0lpTamt(BigDecimal syt0lpTamt) {
        this.syt0lpTamt = syt0lpTamt;
        if (this.tamt == null) this.tamt = syt0lpTamt;
    }

    public BigDecimal getTamt() {
        return tamt != null ? tamt : syt0lpTamt;
    }

    public void setTamt(BigDecimal tamt) {
        this.tamt = tamt;
        if (this.syt0lpTamt == null) this.syt0lpTamt = tamt;
    }

    /** 상장주수 */
    private BigDecimal syt0lpShar;
    private BigDecimal shar;

    public BigDecimal getSyt0lpShar() {
        return syt0lpShar != null ? syt0lpShar : shar;
    }

    public void setSyt0lpShar(BigDecimal syt0lpShar) {
        this.syt0lpShar = syt0lpShar;
        if (this.shar == null) this.shar = syt0lpShar;
    }

    public BigDecimal getShar() {
        return shar != null ? shar : syt0lpShar;
    }

    public void setShar(BigDecimal shar) {
        this.shar = shar;
        if (this.syt0lpShar == null) this.syt0lpShar = shar;
    }

    /** 시가총액 */
    private BigDecimal syt0lpTomv;
    private BigDecimal tomv;

    public BigDecimal getSyt0lpTomv() {
        return syt0lpTomv != null ? syt0lpTomv : tomv;
    }

    public void setSyt0lpTomv(BigDecimal syt0lpTomv) {
        this.syt0lpTomv = syt0lpTomv;
        if (this.tomv == null) this.tomv = syt0lpTomv;
    }

    public BigDecimal getTomv() {
        return tomv != null ? tomv : syt0lpTomv;
    }

    public void setTomv(BigDecimal tomv) {
        this.tomv = tomv;
        if (this.syt0lpTomv == null) this.syt0lpTomv = tomv;
    }

    /** 수신일시 */
    private String loadTime;

    /** 자산구분 (SYM0YA) */
    private String jasanGb;

    /** 블룸버그 티커 (SYM0YA) */
    private String blbgTckr;

    /** ISIN 코드 (SYM0YA) */
    private String isinCd;

    /** 통화 (SYM0YA) */
    private String currency;

    /** 주식종목명 (F_JM_NM) - 양방향 프로퍼티 */
    private String xxYjCd;
    private String jmNm;

    public String getXxYjCd() {
        return xxYjCd != null ? xxYjCd : jmNm;
    }

    public void setXxYjCd(String xxYjCd) {
        this.xxYjCd = xxYjCd;
        if (this.jmNm == null) this.jmNm = xxYjCd;
    }

    public String getJmNm() {
        return jmNm != null ? jmNm : xxYjCd;
    }

    public void setJmNm(String jmNm) {
        this.jmNm = jmNm;
        if (this.xxYjCd == null) this.xxYjCd = jmNm;
    }

    /** 전일종가 (F_YJONGA) */
    private BigDecimal junJonga;

    /** 전일대비 (jonga - jun_jonga) */
    private BigDecimal diffJonga;

    /** 검색버튼 표시 여부 */
    private Integer pVisible;

    /** CUD 상태 관리 필드 (규정 02-3 표준) */
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus; // C, U, D
}
