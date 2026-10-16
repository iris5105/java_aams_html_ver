package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * USPM 포트폴리오 모델 변동성분석 (W_JA032C)
 * 2. 포트 내 종목 상세 현황 DTO (d_ja032c2.srd / d_ja032c2_krx.srd 기반)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja032cDetailDto {

    private String corpGr;
    private String ymd;
    private String fundCd;
    private String portNum;
    private String yjCd;        // 종목코드 (t1.jm_cd)
    private String jmCd;
    private String xxYjCd;      // 종목명
    private String jmNm;
    private String srsCd;       // 블룸버그 티커 등
    private Integer col;
    private BigDecimal jonga;         // 기준일 종가
    private BigDecimal putPrice;      // 기준PUT 행사가격
    private BigDecimal ttVolatility;  // 기준 변동성
    private BigDecimal d30Volatility; // 단기(30) 변동성
    private BigDecimal g30Volatility; // 기준(30) 변동성
    private Long maxJusu;             // 최대 수량
    private Long minJusu;             // 최소 수량
    private Long stockJusu;           // 보유 주수
    private BigDecimal stockChui;     // 주식취득액 (해외 USD, 국내 KRW)
    private Long optQty;              // 옵션 보유수량
    private String fymd;
    private String lineColor;

    // CUD 상태 관리 필드 (표준 규정 02)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    // 양방향 프로퍼티 표준 (Zero-Serialization-Loss)
    public String getXxYjCd() {
        return xxYjCd != null ? xxYjCd : jmNm;
    }

    public void setXxYjCd(String xxYjCd) {
        this.xxYjCd = xxYjCd;
        if (this.jmNm == null) {
            this.jmNm = xxYjCd;
        }
    }

    public String getJmNm() {
        return jmNm != null ? jmNm : xxYjCd;
    }

    public void setJmNm(String jmNm) {
        this.jmNm = jmNm;
        if (this.xxYjCd == null) {
            this.xxYjCd = jmNm;
        }
    }

    public String getYjCd() {
        return yjCd != null ? yjCd : jmCd;
    }

    public void setYjCd(String yjCd) {
        this.yjCd = yjCd;
        if (this.jmCd == null) {
            this.jmCd = yjCd;
        }
    }

    public String getJmCd() {
        return jmCd != null ? jmCd : yjCd;
    }

    public void setJmCd(String jmCd) {
        this.jmCd = jmCd;
        if (this.yjCd == null) {
            this.yjCd = jmCd;
        }
    }
}
