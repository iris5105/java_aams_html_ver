package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja010m3 (결산현황)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010m3Dto {
    private String corpGr;
    private String gyulYmd;
    private String fundCd;
    private String xxFundCd;         // 고객명(펀드명)
    private String mrdNm;            // RD 리포트 파일명

    private BigDecimal tujaAek;      // 투자원금
    private BigDecimal tujaPj;       // 평잔액
    private BigDecimal nav;          // 순자산액
    private BigDecimal sonik;        // 손익액
    private BigDecimal pjSuikPer;    // 수익률(%)

    private BigDecimal totalBosu;    // 보수합계
    private BigDecimal basicBosu;    // 투자일임수수료 (기본보수)
    private BigDecimal successBosu;  // 성과수수료 (성과보수)

    private BigDecimal preBasic;     // 선취
    private BigDecimal basicPer;     // 기본보수율
    private BigDecimal bmPer;        // BM (%)
    private BigDecimal successPer;   // 성과보수율(%)

    private String docNo;            // 재계약 공문서번호
    private String productNm;        // 상품명
    private String contractCondition;// 계약조건 (메모)
    private String sendMailAddr;     // 발송메일주소
    private String sendCcAddr;       // 참조메일주소
    private String sendDt;           // 발송일시
    private String sendUser;         // 발송자

    private BigDecimal contractAek;  // 계약액 (skt1gs.contract_aek)
    private BigDecimal recontractAek;// 재계약액
    private BigDecimal wmSeoljAek;   // 워터마크 투자일임액
    private BigDecimal wmSonik;      // 워터마크 손익액
    private String haejiSayu;        // 해지사유
    private String tblGb;            // 'a': SKT1GS_INDATA, 'b': SKT1GS
}
