package com.kfp.aams.domain.usportfoliomodel.dto;

import java.io.Serializable;

/**
 * d_ja032d1 (API 요청 현황 마스터) DTO
 */
public class Ja032dMasterDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String company;
    private String url;
    private String snm;
    private String dt;
    private String tablename;
    private String subtable;
    private String qtable;
    private Long reqCnt;
    private Long waitCnt;
    private Long okCnt;
    private Long errCnt;

    // CUD 상태 필드 (규정 02-3)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public Ja032dMasterDto() {
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getSnm() {
        return snm;
    }

    public void setSnm(String snm) {
        this.snm = snm;
    }

    public String getDt() {
        return dt;
    }

    public void setDt(String dt) {
        this.dt = dt;
    }

    public String getTablename() {
        return tablename;
    }

    public void setTablename(String tablename) {
        this.tablename = tablename;
    }

    public String getSubtable() {
        return subtable;
    }

    public void setSubtable(String subtable) {
        this.subtable = subtable;
    }

    public String getQtable() {
        return qtable;
    }

    public void setQtable(String qtable) {
        this.qtable = qtable;
    }

    public Long getReqCnt() {
        return reqCnt;
    }

    public void setReqCnt(Long reqCnt) {
        this.reqCnt = reqCnt;
    }

    public Long getWaitCnt() {
        return waitCnt;
    }

    public void setWaitCnt(Long waitCnt) {
        this.waitCnt = waitCnt;
    }

    public Long getOkCnt() {
        return okCnt;
    }

    public void setOkCnt(Long okCnt) {
        this.okCnt = okCnt;
    }

    public Long getErrCnt() {
        return errCnt;
    }

    public void setErrCnt(Long errCnt) {
        this.errCnt = errCnt;
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
