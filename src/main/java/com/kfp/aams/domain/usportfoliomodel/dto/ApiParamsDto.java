package com.kfp.aams.domain.usportfoliomodel.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * API 파라미터 DTO (d_api_params.srd 1:1 매핑)
 * - 테이블: API_PARAMS, szx0gr
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class ApiParamsDto {

    private String trCoCd;        // 매매처코드 (PK)
    private String grCd;          // 종류코드 (PK)
    private String xxGrCd;        // 종류명 (szx0gr.sebu_cd_nm)
    private String scd;           // 분류코드 (PK)
    private String snm;           // 분류명
    private String company;       // Company (PK)
    private String url;           // URL
    private String headers;       // Headers
    private String queryparams;   // QUERYPARAMS
    private String tablename;     // 테이블명
    private String subtable;      // SUB테이블명
    private String keyValue;      // Key Value
    private String subKeyValue;   // Sub Key
    private String comments;      // 주석/설명
    private String qValue;        // API_Q 요청값

    // CUD 상태 관리 필드 (규정 02-3)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;     // C: 등록, U: 수정, D: 삭제

    public ApiParamsDto() {
    }

    public String getTrCoCd() {
        return trCoCd;
    }

    public void setTrCoCd(String trCoCd) {
        this.trCoCd = trCoCd;
    }

    public String getGrCd() {
        return grCd;
    }

    public void setGrCd(String grCd) {
        this.grCd = grCd;
    }

    public String getXxGrCd() {
        return xxGrCd;
    }

    public void setXxGrCd(String xxGrCd) {
        this.xxGrCd = xxGrCd;
    }

    public String getScd() {
        return scd;
    }

    public void setScd(String scd) {
        this.scd = scd;
    }

    public String getSnm() {
        return snm;
    }

    public void setSnm(String snm) {
        this.snm = snm;
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

    public String getHeaders() {
        return headers;
    }

    public void setHeaders(String headers) {
        this.headers = headers;
    }

    public String getQueryparams() {
        return queryparams;
    }

    public void setQueryparams(String queryparams) {
        this.queryparams = queryparams;
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

    public String getKeyValue() {
        return keyValue;
    }

    public void setKeyValue(String keyValue) {
        this.keyValue = keyValue;
    }

    public String getSubKeyValue() {
        return subKeyValue;
    }

    public void setSubKeyValue(String subKeyValue) {
        this.subKeyValue = subKeyValue;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public String getQValue() {
        return qValue;
    }

    public void setQValue(String qValue) {
        this.qValue = qValue;
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
