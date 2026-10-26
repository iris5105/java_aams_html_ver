package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * 예상배당 공시등록 디테일 DTO (d_ja021a2)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja021aDetailDto {

    private String corpGr;
    private String trYmd;     // YYYY-MM-DD
    private String trCd;      // 거래코드
    private String balhCo;    // 발행기관코드
    private String jjCd;      // 종목코드 (JM_CD)
    private String jmCd;      // 종목코드 호환 필드
    private BigDecimal cashRt;
    private BigDecimal stockRt;
    private BigDecimal baedAek;  // 배당금
    private BigDecimal cashPer;  // 현금배당(%)
    private BigDecimal stockPer; // 주식배당(%)
    private String xxJjCd;    // 종목명
    private String jmNm;      // 종목명 호환 필드
    private Integer pVisible; // 편집 가능 여부

    // CUD 상태 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public String getJjCd() {
        return (jjCd != null && !jjCd.isBlank()) ? jjCd : jmCd;
    }

    public void setJjCd(String jjCd) {
        this.jjCd = jjCd;
        if (this.jmCd == null) {
            this.jmCd = jjCd;
        }
    }

    public String getJmCd() {
        return (jmCd != null && !jmCd.isBlank()) ? jmCd : jjCd;
    }

    public void setJmCd(String jmCd) {
        this.jmCd = jmCd;
        if (this.jjCd == null) {
            this.jjCd = jmCd;
        }
    }

    public String getXxJjCd() {
        return (xxJjCd != null && !xxJjCd.isBlank()) ? xxJjCd : jmNm;
    }

    public void setXxJjCd(String xxJjCd) {
        this.xxJjCd = xxJjCd;
        if (this.jmNm == null) {
            this.jmNm = xxJjCd;
        }
    }

    public String getJmNm() {
        return (jmNm != null && !jmNm.isBlank()) ? jmNm : xxJjCd;
    }

    public void setJmNm(String jmNm) {
        this.jmNm = jmNm;
        if (this.xxJjCd == null) {
            this.xxJjCd = jmNm;
        }
    }
}
