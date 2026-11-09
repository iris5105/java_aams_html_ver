package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

@Data
public class Ja031bDto {
    private String corpGr;
    private String grCd = "PP";
    private String trCoCd;
    private String xxTrCoCd;
    private String trCoNm;
    private String susuTrCoCd;
    private String xxSusuTrCoCd;
    private String susuTrCoNm;
    private String susuTrCoCd1;
    private String xxSusuTrCoCd1;
    private String susuTrCoNm1;
    private Integer pVisible = 1;

    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public String getXxTrCoCd() {
        return xxTrCoCd != null ? xxTrCoCd : trCoNm;
    }

    public void setXxTrCoCd(String xxTrCoCd) {
        this.xxTrCoCd = xxTrCoCd;
        if (this.trCoNm == null) this.trCoNm = xxTrCoCd;
    }

    public String getTrCoNm() {
        return trCoNm != null ? trCoNm : xxTrCoCd;
    }

    public void setTrCoNm(String trCoNm) {
        this.trCoNm = trCoNm;
        if (this.xxTrCoCd == null) this.xxTrCoCd = trCoNm;
    }

    public String getXxSusuTrCoCd() {
        return xxSusuTrCoCd != null ? xxSusuTrCoCd : susuTrCoNm;
    }

    public void setXxSusuTrCoCd(String xxSusuTrCoCd) {
        this.xxSusuTrCoCd = xxSusuTrCoCd;
        if (this.susuTrCoNm == null) this.susuTrCoNm = xxSusuTrCoCd;
    }

    public String getSusuTrCoNm() {
        return susuTrCoNm != null ? susuTrCoNm : xxSusuTrCoCd;
    }

    public void setSusuTrCoNm(String susuTrCoNm) {
        this.susuTrCoNm = susuTrCoNm;
        if (this.xxSusuTrCoCd == null) this.xxSusuTrCoCd = susuTrCoNm;
    }

    public String getXxSusuTrCoCd1() {
        return xxSusuTrCoCd1 != null ? xxSusuTrCoCd1 : susuTrCoNm1;
    }

    public void setXxSusuTrCoCd1(String xxSusuTrCoCd1) {
        this.xxSusuTrCoCd1 = xxSusuTrCoCd1;
        if (this.susuTrCoNm1 == null) this.susuTrCoNm1 = xxSusuTrCoCd1;
    }

    public String getSusuTrCoNm1() {
        return susuTrCoNm1 != null ? susuTrCoNm1 : xxSusuTrCoCd1;
    }

    public void setSusuTrCoNm1(String susuTrCoNm1) {
        this.susuTrCoNm1 = susuTrCoNm1;
        if (this.xxSusuTrCoCd1 == null) this.xxSusuTrCoCd1 = susuTrCoNm1;
    }
}

