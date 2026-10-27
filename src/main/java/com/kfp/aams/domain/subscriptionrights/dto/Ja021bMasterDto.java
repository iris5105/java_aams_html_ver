package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * 예상배당 확정등록 마스터 DTO (d_ja021b_t11, t21, t31, t41, t51)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja021bMasterDto {

    private String corpGr;
    private String trYmd;        // YYYY-MM-DD
    private String trCd;         // 거래코드 (G10, G20, G25)
    private String balhCo;       // 발행기관코드
    private String balhNm;       // 발행기관명
    private String xxBalhCo;     // 발행기관명 별칭
    private String baedMth;      // 배당방법 (1: 현금, 2: 주식, 3: 현금+주식 등)
    private String baejMth;      // 배정방법
    private BigDecimal cashIlbanRt;
    private BigDecimal cashWoosRt;
    private BigDecimal stockIlbanRt;
    private BigDecimal stockWoosRt;
    private BigDecimal cashIlbanPer;
    private BigDecimal cashWoosPer;
    private BigDecimal stockIlbanPer;
    private BigDecimal stockWoosPer;
    private BigDecimal ilbanAek; // 보통주당 배당금
    private BigDecimal woosAek;  // 우선주당 배당금
    private String brokYmd;      // 배당락일 (YYYY-MM-DD)
    private String juchongYmd;   // 주총일 (YYYY-MM-DD)

    // 기준(공통: %) 비교 데이터 (bk_*)
    private String bkTrYmd;
    private String bkTrCd;
    private String bkBalhCo;
    private String bkBaedMth;
    private String bkBaejMth;
    private BigDecimal bkCashIlbanRt;
    private BigDecimal bkCashWoosRt;
    private BigDecimal bkStockIlbanRt;
    private BigDecimal bkStockWoosRt;
    private BigDecimal bkCashIlbanPer;
    private BigDecimal bkCashWoosPer;
    private BigDecimal bkStockIlbanPer;
    private BigDecimal bkStockWoosPer;
    private BigDecimal bkIlbanAek;
    private BigDecimal bkWoosAek;
    private String bkBrokYmd;
    private String bkJuchongYmd;

    // 부가 및 상태 제어
    private Integer trSort;
    private Integer fontColor;   // 255: 빨강(차이 발생), 2960685: 기본
    private Integer pVisible;    // 1: 편집가능, 0: 불가
    private String pSjt0bj;      // 1: 종목별 배당 존재, 0: 없음

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
