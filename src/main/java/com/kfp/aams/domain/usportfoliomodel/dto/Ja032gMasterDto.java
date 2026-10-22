package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA032G 해외 파생종목 마스터 DTO (d_ja032g1)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032gMasterDto {
    private String corpGr;          // 회사그룹
    private String jmCd;            // 종목코드 (종목KEY)
    private String jmNm;            // 종목명
    private String stockGb;         // 거래소 (시장구분)
    private String jasanGb;         // 자산구분 (기본: 'A')
    private Integer seqNo;          // 일련번호 (기본: 1)
    private String balhNation;      // 발행국가
    private String currency;        // 통화
    private BigDecimal ijaPer;      // 이자율
    private String balhYmd;         // 발행일자
    private String sanghwYmd;       // 상환일자
    private BigDecimal aekm;        // 액면가
    private String sangjYmd;        // 상장일자
    private BigDecimal sangjJusu;   // 상장주수
    private String gyuljeJm;        // 결제종목여부
    private String blbgTckr;        // 블룸버그코드
    private String isinCd;          // ISIN 코드
    private String ijaBdc;          // 이자계산구분
    private String ijaDcf;          // 일수계산방식
    private String jasanAttr;       // 자산속성
    private String sjGb;            // 종목구분 (선물/옵션 등)
    private String lsyYmd;          // 최종결제일 (만기일자)
    private BigDecimal unitAek;     // 단위승수
    private BigDecimal hangsaGa;    // 행사가격
    private String jasan;           // 자산종류
    private String sedol;           // SEDOL
    private String sigaAgent;       // 시가평가기관 (기본: 'B')
    private String changeCurrency;  // 매도통화
    private BigDecimal changeExRt;  // 환율
    private String changeJmCd;      // 매도결제종목
    private String xxChangeJmCd;    // 매도결제종목명 (F_JM_NM)
    private Integer pVisible;       // 표출여부

    // CUD 상태 관리 필드 (규정 02-3 준수)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
