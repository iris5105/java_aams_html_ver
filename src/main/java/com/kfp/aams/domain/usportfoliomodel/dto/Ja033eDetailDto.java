package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 포트/종목별 종가대비 행사가격 상세 DTO (d_ja033e2.srd)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja033eDetailDto {
    private Integer fseq;              // 순번
    private String tt;                 // 변동성 계산기준
    private Integer instDays;          // 설정일수
    private String mangi;              // 만기일 (yyyy년 mm월 dd일만기)
    private Integer dt;                // 잔존일수
    private BigDecimal yearBeta;       // 전략베타 1년
    private BigDecimal monBeta;        // 전략베타 1개월
    private String portNum;            // 포트번호
    private String jmCd;               // 종목코드
    private String srsCd;              // 시리즈/블룸버그티커
    private String xxYjCd;             // 종목명
    private String jmNm;               // 종목명 (호환)
    private BigDecimal jonga;          // 기준일 종가
    private BigDecimal clearance;      // 이격율(%)
    private BigDecimal pricePer;       // 행사비율(%)
    private String priceStatus;        // 행사여부 (LOW, HIGH, UNDECIDED)
    private String currency;           // 통화
    private String optJmCd;            // 옵션종목코드
    private String optJmNm;            // 옵션종목명
    private BigDecimal qty;            // 옵션 보유수량
    private BigDecimal hangsaGa;       // 보유옵션 행사가격
    private BigDecimal riskValue;      // 옵션 위험값
    private String sebuNm;             // 세부명칭 (변동성 계산기준 명칭)
    private String ttNm;               // 변동성 계산기준 명칭 (호환)

    public String getSebuNm() {
        return sebuNm != null ? sebuNm : ttNm;
    }

    public void setSebuNm(String sebuNm) {
        this.sebuNm = sebuNm;
        if (this.ttNm == null) this.ttNm = sebuNm;
    }

    public String getTtNm() {
        return ttNm != null ? ttNm : sebuNm;
    }

    public void setTtNm(String ttNm) {
        this.ttNm = ttNm;
        if (this.sebuNm == null) this.sebuNm = ttNm;
    }

    // 양방향 프로퍼티 매핑 (Zero-Serialization-Loss)
    public String getXxYjCd() {
        return xxYjCd != null ? xxYjCd : jmNm;
    }

    public void setXxYjCd(String xxYjCd) {
        this.xxYjCd = xxYjCd;
        if (this.jmNm == null) this.jmNm = xxYjCd;
    }

    public String getJmNm() {
        return jmNm != null ? jmNm : xxYjCd;
    }

    public void setJmNm(String jmNm) {
        this.jmNm = jmNm;
        if (this.xxYjCd == null) this.xxYjCd = jmNm;
    }

    public String getYjCd() {
        return jmCd;
    }

    public void setYjCd(String yjCd) {
        this.jmCd = yjCd;
    }
}
