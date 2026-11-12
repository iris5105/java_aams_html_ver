package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA030E 하단 채권 종목정보 및 펀드별 보유현황 DTO (d_ja030e2 / SR_JA030E 기준)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja030eDetailDto {

    // --- 1. 종목 기본 헤더 정보 ---
    private String jmCd;             // 종목코드
    private String cjFnm;            // 종목전칭
    private String cjNm;             // 종목명칭(약칭)
    private String cjEnm;            // 종목영문명칭
    private String balhYmd;          // 발행일
    private String sanghwYmd;        // 상환일(만기일)
    private String medoYmd;          // 매출일자
    private String sunmeIjaYmd;      // 선매출이자수령일(선이자일)
    private String bfIjaYmd;         // 전이자일
    private String afIjaYmd;         // 후이자일
    private String budoYmd;          // 부도일자
    private String jmCreDt;          // 종목등록일자

    private String sangjGb;          // 상장구분
    private String sunhuGb;          // 선후취구분
    private String halinGb;          // 할인구분
    private String bunhalGb;         // 분할구분(특이채)
    private String ydongGb;          // 연동구분
    private String bondAttr;         // 채권속성(채권구분)
    private String ijaJigubGb;       // 이자지급방법 구분
    private String bondCd;           // 채권종류코드
    private String balhGa;           // 발행단위(가)
    private String balhCo;           // 발행기관 코드
    private String bojngCo;          // 보증기관 코드
    private BigDecimal balhAek;      // 발행액

    private String codeNm2;          // 보증기관 명
    private String codeNm3;          // 채권종류 명
    private String codeNm5;          // 발행기관 명

    private String ijaYySu;          // 이자지급연수
    private String yyIjaHoisu;       // 이자지급연횟수 (연지급)
    private String totIjaHoicha;     // 총이자지급회차 (총지급)
    private String nowGuganNo;       // 현이자구간 번호 (현구간)

    private BigDecimal pyomIyul;     // 표면이율
    private BigDecimal halinIyul;    // 할인율
    private BigDecimal haljIyul;     // 할증율

    private String chgJmCd;          // 전환대상 종목코드 (전환주)
    private BigDecimal chgGa;        // 전환가격
    private String chgStart;         // 전환시작일
    private String chgEnd;           // 전환종료일
    private String asCjCd;           // 구종목코드(AS)
    private String sigaGb;           // 시가평가구분
    private String husunwiGb;        // 후순위채권구분

    // 평가사 정보
    private String kisGrade;         // KIS 등급
    private BigDecimal kisSuikRt;    // KIS 수익률(적용이율)
    private BigDecimal kisDanga;     // KIS 단가(적용단가)

    private String kapGrade;         // KAP 등급
    private BigDecimal kapSuikRt;    // KAP 수익률(적용이율)
    private BigDecimal kapDanga;     // KAP 단가(적용단가)

    private String niceGrade;        // NICE 등급
    private BigDecimal niceSuikRt;   // NICE 수익률(적용이율)
    private BigDecimal niceDanga;    // NICE 단가(적용단가)

    private BigDecimal jySuikRt;     // 평균(적용) 수익률
    private BigDecimal jyDanga;      // 평균(적용) 단가
    private String sutakNm;          // 수탁사 명

    // --- 2. 펀드별 보유현황 (디테일 그리드 행) ---
    private String ymd;              // 처리일자
    private String fundCd;           // 펀드번호 (관리번호)
    private String fundNm;           // 계좌명
    private String xxFundCd;         // 명칭 호환 프로퍼티

    private BigDecimal aekm;         // 액면
    private BigDecimal chuiAek;      // 취득가
    private BigDecimal sungCost;     // 선급비용
    private BigDecimal prSungCost;   // P 선급비용(할인 선급비용)
    private BigDecimal scSungCost;   // 선매출 선급비용

    private BigDecimal misuIja;      // 미수이자
    private BigDecimal prMisuIja;    // P 미수이자(할증 미수이자)
    private BigDecimal scMisuIja;    // 선매출 미수이자

    private BigDecimal dayMisuIja;   // 하루이자
    private BigDecimal dayPrIja;     // P 하루이자
    private BigDecimal scDayIja;     // 선매출 하루이자

    private BigDecimal guganMisuIja; // 구간이자
    private BigDecimal guganPrIja;   // P 구간이자
    private BigDecimal scGuganIja;   // 선매출 구간이자

    private BigDecimal sungTax;      // 선급원천세
    private BigDecimal prSungTax;    // 할증 선급원천세
    private BigDecimal scSungTax;    // 선매출 선급원천세

    private BigDecimal sunnTax;      // 선납원천세
    private BigDecimal prSunnTax;    // 할증 선납원천세

    private BigDecimal dayAnbunAek;  // 하루손익안분
    private BigDecimal guganAnbunAek;// 구간손익안분
    private BigDecimal anbunAek;     // 누적손익안분

    // Rule 02: 양방향 프로퍼티
    public String getXxFundCd() {
        return xxFundCd != null ? xxFundCd : fundNm;
    }
    public void setXxFundCd(String xxFundCd) {
        this.xxFundCd = xxFundCd;
        if (this.fundNm == null) this.fundNm = xxFundCd;
    }
    public String getFundNm() {
        return fundNm != null ? fundNm : xxFundCd;
    }
    public void setFundNm(String fundNm) {
        this.fundNm = fundNm;
        if (this.xxFundCd == null) this.xxFundCd = fundNm;
    }

    // 상태 관리 필드 (Rule 02)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}

