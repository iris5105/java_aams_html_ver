package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * 종목별 배당권리 상세/등록 DTO (d_ja021b_t12, d_ja021b_p1)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja021bItemDto {

    private String corpGr;
    private String trYmd;
    private String trCd;
    private String balhCo;
    private String jmCd;         // jj_cd
    private String jjCd;
    private String jmNm;         // xx_jj_cd
    private String xxJjCd;
    private BigDecimal cashRt;
    private BigDecimal stockRt;
    private BigDecimal baedAek;
    private BigDecimal cashPer;
    private BigDecimal stockPer;

    // CUD 상태 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public String getJmCd() {
        return (jmCd != null && !jmCd.isBlank()) ? jmCd : jjCd;
    }

    public void setJmCd(String jmCd) {
        this.jmCd = jmCd;
        if (this.jjCd == null) this.jjCd = jmCd;
    }

    public String getJjCd() {
        return (jjCd != null && !jjCd.isBlank()) ? jjCd : jmCd;
    }

    public void setJjCd(String jjCd) {
        this.jjCd = jjCd;
        if (this.jmCd == null) this.jmCd = jjCd;
    }

    public String getJmNm() {
        return (jmNm != null && !jmNm.isBlank()) ? jmNm : xxJjCd;
    }

    public void setJmNm(String jmNm) {
        this.jmNm = jmNm;
        if (this.xxJjCd == null) this.xxJjCd = jmNm;
    }

    public String getXxJjCd() {
        return (xxJjCd != null && !xxJjCd.isBlank()) ? xxJjCd : jmNm;
    }

    public void setXxJjCd(String xxJjCd) {
        this.xxJjCd = xxJjCd;
        if (this.jmNm == null) this.jmNm = xxJjCd;
    }
}
