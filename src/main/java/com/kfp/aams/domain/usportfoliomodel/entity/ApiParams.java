package com.kfp.aams.domain.usportfoliomodel.entity;

import jakarta.persistence.*;

/**
 * API 파라미터 엔티티 (단일 테이블 API_PARAMS)
 */
@Entity
@Table(name = "API_PARAMS")
@IdClass(ApiParamsId.class)
public class ApiParams {

    @Id
    @Column(name = "TR_CO_CD", length = 5, nullable = false)
    private String trCoCd;

    @Id
    @Column(name = "GR_CD", length = 2, nullable = false)
    private String grCd;

    @Id
    @Column(name = "SCD", length = 2, nullable = false)
    private String scd;

    @Id
    @Column(name = "COMPANY", length = 16, nullable = false)
    private String company;

    @Column(name = "SNM", length = 80)
    private String snm;

    @Column(name = "URL", length = 256)
    private String url;

    @Column(name = "HEADERS", length = 512)
    private String headers;

    @Column(name = "QUERYPARAMS", length = 256)
    private String queryparams;

    @Column(name = "TABLENAME", length = 128)
    private String tablename;

    @Column(name = "SUBTABLE", length = 128)
    private String subtable;

    @Column(name = "KEY_VALUE", length = 10)
    private String keyValue;

    @Column(name = "SUB_KEY_VALUE", length = 10)
    private String subKeyValue;

    @Column(name = "COMMENTS", length = 2048)
    private String comments;

    @Column(name = "Q_VALUE", length = 1024)
    private String qValue;

    public ApiParams() {
    }

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private String trCoCd;
        private String grCd;
        private String scd;
        private String company;
        private String snm;
        private String url;
        private String headers;
        private String queryparams;
        private String tablename;
        private String subtable;
        private String keyValue;
        private String subKeyValue;
        private String comments;
        private String qValue;

        public Builder trCoCd(String trCoCd) { this.trCoCd = trCoCd; return this; }
        public Builder grCd(String grCd) { this.grCd = grCd; return this; }
        public Builder scd(String scd) { this.scd = scd; return this; }
        public Builder company(String company) { this.company = company; return this; }
        public Builder snm(String snm) { this.snm = snm; return this; }
        public Builder url(String url) { this.url = url; return this; }
        public Builder headers(String headers) { this.headers = headers; return this; }
        public Builder queryparams(String queryparams) { this.queryparams = queryparams; return this; }
        public Builder tablename(String tablename) { this.tablename = tablename; return this; }
        public Builder subtable(String subtable) { this.subtable = subtable; return this; }
        public Builder keyValue(String keyValue) { this.keyValue = keyValue; return this; }
        public Builder subKeyValue(String subKeyValue) { this.subKeyValue = subKeyValue; return this; }
        public Builder comments(String comments) { this.comments = comments; return this; }
        public Builder qValue(String qValue) { this.qValue = qValue; return this; }

        public ApiParams build() {
            ApiParams entity = new ApiParams();
            entity.trCoCd = this.trCoCd;
            entity.grCd = this.grCd;
            entity.scd = this.scd;
            entity.company = this.company;
            entity.snm = this.snm;
            entity.url = this.url;
            entity.headers = this.headers;
            entity.queryparams = this.queryparams;
            entity.tablename = this.tablename;
            entity.subtable = this.subtable;
            entity.keyValue = this.keyValue;
            entity.subKeyValue = this.subKeyValue;
            entity.comments = this.comments;
            entity.qValue = this.qValue;
            return entity;
        }
    }

    public String getTrCoCd() { return trCoCd; }
    public void setTrCoCd(String trCoCd) { this.trCoCd = trCoCd; }

    public String getGrCd() { return grCd; }
    public void setGrCd(String grCd) { this.grCd = grCd; }

    public String getScd() { return scd; }
    public void setScd(String scd) { this.scd = scd; }

    public String getCompany() { return company; }
    public void setCompany(String company) { this.company = company; }

    public String getSnm() { return snm; }
    public void setSnm(String snm) { this.snm = snm; }

    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }

    public String getHeaders() { return headers; }
    public void setHeaders(String headers) { this.headers = headers; }

    public String getQueryparams() { return queryparams; }
    public void setQueryparams(String queryparams) { this.queryparams = queryparams; }

    public String getTablename() { return tablename; }
    public void setTablename(String tablename) { this.tablename = tablename; }

    public String getSubtable() { return subtable; }
    public void setSubtable(String subtable) { this.subtable = subtable; }

    public String getKeyValue() { return keyValue; }
    public void setKeyValue(String keyValue) { this.keyValue = keyValue; }

    public String getSubKeyValue() { return subKeyValue; }
    public void setSubKeyValue(String subKeyValue) { this.subKeyValue = subKeyValue; }

    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }

    public String getQValue() { return qValue; }
    public void setQValue(String qValue) { this.qValue = qValue; }
}
