package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * 관심종목 변동성 추이 (d_ja032b_ya.srd) DTO
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja032bYaStockDto {

    private String chk;                  // 선택 체크박스 ('1' or '0')
    private String corpGr;               // 회사그룹
    private String ymd;                  // 기준일자 (YYYY-MM-DD)
    private String yjCd;                 // 종목코드 (JM_CD)
    private String xxYjCd;               // 종목명
    private String jmNm;                 // 종목명 (호환용)
    private String srs_cd;               // 블룸버그 티커 (BLBG_TCKR)
    private BigDecimal syt0lpJonga;      // 기준일 종가 (JONGA)
    private BigDecimal shortPrice;       // 단기(30) 평균가
    private BigDecimal gijunPrice;       // 기준(30) 평균가
    private BigDecimal d30Volatility;    // 단기(30) 변동성
    private BigDecimal g30Volatility;    // 기준(30) 변동성
    private BigDecimal ma50;             // 50일 이동평균
    private BigDecimal ma200;            // 200일 이동평균
    private String ovrsExcgCd;           // 해외거래소코드
    private BigDecimal jongaChgPct;      // 당일 등락율(%)
    private BigDecimal chgPct5d;         // 등락율 5일(%)
    private BigDecimal chgPct10d;        // 등락율 10일(%)
    private BigDecimal chgPct15d;        // 등락율 15일(%)
    private BigDecimal chgPct20d;        // 등락율 20일(%)
    private String highValue;            // 최고가
    private String highYmd;              // 최고일자 (YYYY-MM-DD)
    private String lowValue;             // 최저가
    private String lowYmd;               // 최저일자 (YYYY-MM-DD)
    private String tujaYn;               // 기준정보등록여부 ('Y' or 'N')

    // 상태 관리 필드 (02-dto-and-models.md)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    // 명칭 컬럼 양방향 프로퍼티 표준 (Zero-Serialization-Loss)
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
}
