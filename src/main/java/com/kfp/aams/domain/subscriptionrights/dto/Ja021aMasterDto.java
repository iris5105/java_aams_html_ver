package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * 예상배당 공시등록 마스터 DTO (d_ja021a1)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja021aMasterDto {

    private String corpGr;
    private String trYmd;        // YYYY-MM-DD
    private String trCd;         // 거래코드 (예: G10)
    private String balhCo;       // 발행기관코드 (5자리)
    private String baedMth;      // 배당방법
    private String baejMth;      // 배정방법
    private BigDecimal cashIlbanRt;
    private BigDecimal cashWoosRt;
    private BigDecimal stockIlbanRt;
    private BigDecimal stockWoosRt;
    private String brokYmd;      // 배당락일 (YYYY-MM-DD)
    private String juchongYmd;   // 주총일 (YYYY-MM-DD)
    private String balhNm;       // 발행기관명
    private String xxBalhCo;     // 발행기관명 별칭
    private BigDecimal stockWoosPer;
    private BigDecimal stockIlbanPer;
    private BigDecimal cashWoosPer;
    private BigDecimal cashIlbanPer;
    private BigDecimal ilbanAek; // 보통주당 현금배당금
    private BigDecimal woosAek;  // 우선주당 현금배당금
    private Integer pVisible;    // 편집 가능 여부 (1: 가능, 0: 불가)

    // CUD 상태 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public String getXxBalhCo() {
        return (xxBalhCo != null && !xxBalhCo.isBlank()) ? xxBalhCo : balhNm;
    }

    public void setXxBalhCo(String xxBalhCo) {
        this.xxBalhCo = xxBalhCo;
        if (this.balhNm == null) {
            this.balhNm = xxBalhCo;
        }
    }

    public String getBalhNm() {
        return (balhNm != null && !balhNm.isBlank()) ? balhNm : xxBalhCo;
    }

    public void setBalhNm(String balhNm) {
        this.balhNm = balhNm;
        if (this.xxBalhCo == null) {
            this.xxBalhCo = balhNm;
        }
    }
}
