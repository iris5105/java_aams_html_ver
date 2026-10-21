package com.kfp.aams.domain.usportfoliomodel.dto;

import java.math.BigDecimal;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 해외파생 종목코드 (d_fostkcode.srd / W_FOSTKCODE) DTO
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FostkcodeDto {

    private Integer used;           // 등록종목 (1 / 0)
    private String srscd;          // 종목코드 (SRSCD)
    private String autoordgnrlyn;  // 일반자동주문여부
    private String autoordtwapyn;  // TWAP자동주문여부
    private String autoordecnmyn;  // ECNM자동주문여부
    private String exchsubcd;      // 서브코드
    private String serieskrnm;     // 종목한글명
    private String exchcd;         // 거래소코드
    private String mrktcd;         // 품목코드
    private String clascd;         // 품목종류
    private Integer dispdesz;      // 출력소수점
    private Integer calcdesz;      // 계산소수점
    private BigDecimal ticksz;     // 틱사이즈
    private BigDecimal tickval;    // 틱가치
    private BigDecimal ctrtsz;     // 계약크기
    private Integer dispdigit;     // 가격표시진법
    private BigDecimal multiplier; // 환산승수
    private String symbol;         // 옵션구분 (C: CALL, P: PUT)
    private BigDecimal stkprc;     // 행사가격
    private String undrinstr;      // 관련선물코드
    private String undrasset;      // 관련주식종목
    private String refrasset;      // 참조자산(Index등)
    private BigDecimal inctickprc; // 틱증가기준가
    private BigDecimal incticksz;  // 틱증가배수
    private String mangi;          // 만기일 (YYYYMMDD)
    private String yearmon;        // 만기월 (YYYYMM)
    private String atmflg;         // 행사가위치 (A: ATM, I: ITM, O: OTM)
    private String nearflg;        // 근월물여부 (0: 원월물, 1: 근월물)

    // 상태 관리 필드 (규정 02-3)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
