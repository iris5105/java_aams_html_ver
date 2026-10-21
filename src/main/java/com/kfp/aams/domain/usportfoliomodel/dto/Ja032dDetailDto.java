package com.kfp.aams.domain.usportfoliomodel.dto;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * d_ja032d2 (API 요청 상세 건별 목록) DTO
 */
public class Ja032dDetailDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String company;
    private String url;
    private String headers;
    private String queryparams;
    private String tablename;
    private String subtable;
    private String request;
    private Integer status;
    private String statustext;
    private String msgCd;
    private String msg1;
    private String errcode;
    private String apiKey;
    private String keyValue;
    private String subKeyValue;
    private String corpGr;
    private String trYmd;
    private String key1;
    private String key2;
    private BigDecimal num1;

    // CUD 상태 필드 (규정 02-3)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public Ja032dDetailDto() {
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

    public String getRequest() {
        return request;
    }

    public void setRequest(String request) {
        this.request = request;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getStatustext() {
        return statustext;
    }

    public void setStatustext(String statustext) {
        this.statustext = statustext;
    }

    public String getMsgCd() {
        return msgCd;
    }

    public void setMsgCd(String msgCd) {
        this.msgCd = msgCd;
    }

    public String getMsg1() {
        return msg1;
    }

    public void setMsg1(String msg1) {
        this.msg1 = msg1;
    }

    public String getErrcode() {
        return errcode;
    }

    public void setErrcode(String errcode) {
        this.errcode = errcode;
    }

    public String getApiKey() {
        return apiKey;
    }

    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
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

    public String getCorpGr() {
        return corpGr;
    }

    public void setCorpGr(String corpGr) {
        this.corpGr = corpGr;
    }

    public String getTrYmd() {
        return trYmd;
    }

    public void setTrYmd(String trYmd) {
        this.trYmd = trYmd;
    }

    public String getKey1() {
        return key1;
    }

    public void setKey1(String key1) {
        this.key1 = key1;
    }

    public String getKey2() {
        return key2;
    }

    public void setKey2(String key2) {
        this.key2 = key2;
    }

    public BigDecimal getNum1() {
        return num1;
    }

    public void setNum1(BigDecimal num1) {
        this.num1 = num1;
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
