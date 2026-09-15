package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja010g1_common (입력자료 대비 순자산점검)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010gDto {
    private String corpGr;          // 회사그룹
    private String trYmd;           // 점검일자 (YYYY-MM-DD)
    private String fundCd;          // 관리번호 (fund_cd)
    private String trCoCd;          // 증권사 코드
    private String trCoNm;          // 증권사 명
    private String encAcctNo;       // 암호화 계좌번호
    private String acctNo;          // 계좌번호 (복호화)
    private String fundNm;          // 고객명 (fund_nm)

    private BigDecimal yeStockAek;      // (LOAD) 주식시가액
    private BigDecimal yeBondAek;       // (LOAD) 채권시가액
    private BigDecimal cashAek;         // 현금자산 시가액
    private BigDecimal yeTotAek;        // (LOAD) 순자산액
    private BigDecimal uhStockAek;      // (원장생성) 주식시가액
    private BigDecimal uhStockGongmo;   // 공모 미상장주식
    private BigDecimal uhBondAek;       // (원장생성) 채권시가액
    private BigDecimal uhNav;           // (원장생성) 순자산액
    private String confYmd;             // 확정일자 (conf_ymd)

    private BigDecimal misuBaedAek;     // (계산배당) 미수배당
    private BigDecimal mijigubAek;      // 미수입(지급)액
    private BigDecimal gaek;            // 가액
    private BigDecimal gsonik;          // 손익

    // 2402 전용 필드
    private BigDecimal yeFundAek;       // (LOAD) 펀드액
    private BigDecimal uhSjAek;         // (원장) 설정환매액
    private BigDecimal uhCashAek;       // (원장) 현금자산액

    // 계산식 필드
    private BigDecimal navCha;          // 순자산차액
    private BigDecimal stockCha;        // 주식차액
    private BigDecimal bondCha;         // 채권차액
}
