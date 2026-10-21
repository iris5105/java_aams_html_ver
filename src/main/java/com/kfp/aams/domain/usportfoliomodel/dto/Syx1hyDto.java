package com.kfp.aams.domain.usportfoliomodel.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.math.BigDecimal;

/**
 * 환율등록 DTO (d_syx1hy_2501.srd 매핑)
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class Syx1hyDto {

    private String ymd;
    private String hkdCur;
    private BigDecimal hkdGijunRt;
    private String usdCur;
    private BigDecimal usdGijunRt;
    private String gbpCur;
    private BigDecimal gbpGijunRt;
    private String vndCur;
    private BigDecimal vndGijunRt;
    private String sgdCur;
    private BigDecimal sgdGijunRt;
    private Integer fontColor;
    private String week;
    private String corpGr;

    // CUD 상태 관리 필드 (규정 02-3 CUD 상태 관리 필드 표준)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public Syx1hyDto() {
    }

    public String getYmd() {
        return ymd;
    }

    public void setYmd(String ymd) {
        this.ymd = ymd;
    }

    public String getHkdCur() {
        return hkdCur;
    }

    public void setHkdCur(String hkdCur) {
        this.hkdCur = hkdCur;
    }

    public BigDecimal getHkdGijunRt() {
        return hkdGijunRt;
    }

    public void setHkdGijunRt(BigDecimal hkdGijunRt) {
        this.hkdGijunRt = hkdGijunRt;
    }

    public String getUsdCur() {
        return usdCur;
    }

    public void setUsdCur(String usdCur) {
        this.usdCur = usdCur;
    }

    public BigDecimal getUsdGijunRt() {
        return usdGijunRt;
    }

    public void setUsdGijunRt(BigDecimal usdGijunRt) {
        this.usdGijunRt = usdGijunRt;
    }

    public String getGbpCur() {
        return gbpCur;
    }

    public void setGbpCur(String gbpCur) {
        this.gbpCur = gbpCur;
    }

    public BigDecimal getGbpGijunRt() {
        return gbpGijunRt;
    }

    public void setGbpGijunRt(BigDecimal gbpGijunRt) {
        this.gbpGijunRt = gbpGijunRt;
    }

    public String getVndCur() {
        return vndCur;
    }

    public void setVndCur(String vndCur) {
        this.vndCur = vndCur;
    }

    public BigDecimal getVndGijunRt() {
        return vndGijunRt;
    }

    public void setVndGijunRt(BigDecimal vndGijunRt) {
        this.vndGijunRt = vndGijunRt;
    }

    public String getSgdCur() {
        return sgdCur;
    }

    public void setSgdCur(String sgdCur) {
        this.sgdCur = sgdCur;
    }

    public BigDecimal getSgdGijunRt() {
        return sgdGijunRt;
    }

    public void setSgdGijunRt(BigDecimal sgdGijunRt) {
        this.sgdGijunRt = sgdGijunRt;
    }

    public Integer getFontColor() {
        return fontColor;
    }

    public void setFontColor(Integer fontColor) {
        this.fontColor = fontColor;
    }

    public String getWeek() {
        return week;
    }

    public void setWeek(String week) {
        this.week = week;
    }

    public String getCorpGr() {
        return corpGr;
    }

    public void setCorpGr(String corpGr) {
        this.corpGr = corpGr;
    }

    public Boolean getIsNew() {
        return isNew;
    }

    public void setIsNew(Boolean isNew) {
        this.isNew = isNew;
    }

    public Boolean getIsUpdated() {
        return isUpdated;
    }

    public void setIsUpdated(Boolean isUpdated) {
        this.isUpdated = isUpdated;
    }

    public Boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public String getRowStatus() {
        return rowStatus;
    }

    public void setRowStatus(String rowStatus) {
        this.rowStatus = rowStatus;
    }
}
