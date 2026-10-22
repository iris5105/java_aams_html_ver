package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA032F 해외주식 마스터 및 USPM 등록 종목 DTO (d_ja032f1)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032fMasterDto {
    private Integer used;           // 등록여부 (1: 미등록, 2: 등록)
    private String ncod;            // 국가코드
    private String exid;            // 거래소ID
    private String excd;            // 거래소코드
    private String exnm;            // 거래소명
    private String symb;            // 종목코드 (티커)
    private String rsym;            // 거래종목코드
    private String knam;            // 한글종목명
    private String enam;            // 영문종목명
    private String stis;            // Security Type
    private String curr;            // 통화
    private String zdiv;            // 소수점단위
    private String ztyp;            // Data Type
    private BigDecimal basePrice;   // 기초가
    private String bnit;            // 매수단위
    private String anit;            // 매도단위
    private String mstm;            // 거래시작시간
    private String metm;            // 거래종료시간
    private String isdr;            // DR여부
    private String drcd;            // DR국가
    private String icod;            // 업종분류
    private Integer sjong;          // 지수구성종목 (0: 없음, 1: 있음)
    private String ttyp;            // Tick size Type
    private String etyp;            // TYPE
    private String ttypSb;

    // SYM0YA 테이블 매핑 컬럼
    private String corpGr;
    private String jmCd;
    private String jmNm;
    private String jasanGb;
    private Integer seqNo;
    private String balhNation;
    private String currency;
    private String sangjYmd;
    private BigDecimal sangjJusu;
    private String blbgTckr;
    private String isinCd;
    private String sedol;
    private String stockGb;
    private String sjGb;
    private String blbgTckrText;
    private String srsCd;
    private String sym0yaExcd;
    private String uspmYmd;
    private BigDecimal optUnit;     // 월옵션 가격단위
    private BigDecimal opt1unit;    // 주옵션 가격단위
    private BigDecimal opt2unit;
    private BigDecimal opt4unit;
    private BigDecimal opt5unit;

    // CUD 상태 플래그
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
