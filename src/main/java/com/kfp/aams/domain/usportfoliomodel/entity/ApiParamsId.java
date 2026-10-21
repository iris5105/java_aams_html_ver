package com.kfp.aams.domain.usportfoliomodel.entity;

import java.io.Serializable;
import java.util.Objects;

/**
 * API_PARAMS 복합 기본키 클래스
 */
public class ApiParamsId implements Serializable {

    private String trCoCd;
    private String grCd;
    private String scd;
    private String company;

    public ApiParamsId() {
    }

    public ApiParamsId(String trCoCd, String grCd, String scd, String company) {
        this.trCoCd = trCoCd;
        this.grCd = grCd;
        this.scd = scd;
        this.company = company;
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

    public String getScd() {
        return scd;
    }

    public void setScd(String scd) {
        this.scd = scd;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ApiParamsId that = (ApiParamsId) o;
        return Objects.equals(trCoCd, that.trCoCd) &&
                Objects.equals(grCd, that.grCd) &&
                Objects.equals(scd, that.scd) &&
                Objects.equals(company, that.company);
    }

    @Override
    public int hashCode() {
        return Objects.hash(trCoCd, grCd, scd, company);
    }
}
