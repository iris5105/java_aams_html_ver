package com.kfp.aams.domain.usportfoliomodel.dto;

import java.io.Serializable;

/**
 * DTO for w_ja032k fund list (d_ja036e.srd mapping)
 */
public class Ja032kFundDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String fundCd;
    private String fundNm;
    private String xxFundCd;
    private String mgCd;
    private Long fundColor;
    private String encAcctNo;
    private String acctNo;
    private String fstSeoljYmd;
    private String bfGyulYmd;
    private String haejiYmd;

    // CUD 상태 관리 필드 (02-dto-and-models.md)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public Ja032kFundDto() {}

    public String getFundCd() {
        return fundCd;
    }

    public void setFundCd(String fundCd) {
        this.fundCd = fundCd;
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

    public String getXxFundCd() {
        return xxFundCd != null ? xxFundCd : fundNm;
    }

    public void setXxFundCd(String xxFundCd) {
        this.xxFundCd = xxFundCd;
        if (this.fundNm == null) {
            this.fundNm = xxFundCd;
        }
    }

    public String getMgCd() {
        return mgCd;
    }

    public void setMgCd(String mgCd) {
        this.mgCd = mgCd;
    }

    public Long getFundColor() {
        return fundColor;
    }

    public void setFundColor(Long fundColor) {
        this.fundColor = fundColor;
    }

    public String getEncAcctNo() {
        return encAcctNo;
    }

    public void setEncAcctNo(String encAcctNo) {
        this.encAcctNo = encAcctNo;
    }

    public String getAcctNo() {
        return acctNo;
    }

    public void setAcctNo(String acctNo) {
        this.acctNo = acctNo;
    }

    public String getFstSeoljYmd() {
        return fstSeoljYmd;
    }

    public void setFstSeoljYmd(String fstSeoljYmd) {
        this.fstSeoljYmd = fstSeoljYmd;
    }

    public String getBfGyulYmd() {
        return bfGyulYmd;
    }

    public void setBfGyulYmd(String bfGyulYmd) {
        this.bfGyulYmd = bfGyulYmd;
    }

    public String getHaejiYmd() {
        return haejiYmd;
    }

    public void setHaejiYmd(String haejiYmd) {
        this.haejiYmd = haejiYmd;
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
