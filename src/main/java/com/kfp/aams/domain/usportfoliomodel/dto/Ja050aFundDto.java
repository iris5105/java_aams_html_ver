package com.kfp.aams.domain.usportfoliomodel.dto;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * DTO for w_ja050a fund list (d_ja050a1.srd mapping)
 */
public class Ja050aFundDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String mgCd;
    private String fundCd;
    private String fundNm;
    private String xxFundCd;
    private String workGb;
    private String fstSeoljYmd;
    private BigDecimal gijunGa;
    private BigDecimal ggijunGa;
    private String typeGb;
    private Long fundColor;

    // CUD 상태 관리 필드 (02-dto-and-models.md)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public Ja050aFundDto() {}

    public String getMgCd() {
        return mgCd;
    }

    public void setMgCd(String mgCd) {
        this.mgCd = mgCd;
    }

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

    public String getWorkGb() {
        return workGb;
    }

    public void setWorkGb(String workGb) {
        this.workGb = workGb;
    }

    public String getFstSeoljYmd() {
        return fstSeoljYmd;
    }

    public void setFstSeoljYmd(String fstSeoljYmd) {
        this.fstSeoljYmd = fstSeoljYmd;
    }

    public BigDecimal getGijunGa() {
        return gijunGa;
    }

    public void setGijunGa(BigDecimal gijunGa) {
        this.gijunGa = gijunGa;
    }

    public BigDecimal getGgijunGa() {
        return ggijunGa;
    }

    public void setGgijunGa(BigDecimal ggijunGa) {
        this.ggijunGa = ggijunGa;
    }

    public String getTypeGb() {
        return typeGb;
    }

    public void setTypeGb(String typeGb) {
        this.typeGb = typeGb;
    }

    public Long getFundColor() {
        return fundColor;
    }

    public void setFundColor(Long fundColor) {
        this.fundColor = fundColor;
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
