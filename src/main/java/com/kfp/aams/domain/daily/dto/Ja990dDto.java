package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for SJM0JJ (주식 및 신주인수권 종목)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja990dDto {
    private String jmCd;           // 종목코드 (PK)
    private String koscomCd;       // 단축코드
    private String jjFnm;          // 종목전명
    private String jjNm;           // 종목명
    private String jjEnm;          // 영문종목명
    private String balhCo;         // 발행기관코드
    private String woosIlbanGb;    // 우선/일반구분
    private String chgGb;          // 전환구분
    private String newOldGb;       // 신/구주구분
    private String dancGb;         // 시장구분 (A:거래소, C:코스닥, D:코넥스, B:비상장, X:신주인수권)
    private BigDecimal balhGa;     // 발행가
    private String kweonriYmd;     // 권리발생일
    private String sangjYmd;       // 상장일
    private BigDecimal sangjJusu;  // 상장주수
    private String upjCd;          // 업종코드
    private String createdYmd;     // 생성일
    private String delYn;          // 삭제여부
    private String balhNm;         // 발행기관명 (sjx0jb.balh_nm)
    private String upjFnm;         // 업종명 (szx0uj.upj_fnm)
    private String capsize;        // 규모
    private String kospigubun;     // KOSPI200 구분
    private String woosVoteYmd;    // 우선주 의결권일자
    private String under;          // 관리/감리 여부
    private String balhNation;     // 발행국가 (sjx0jb.balh_nation)
    private String baedGisanYmd;   // 배당기산일
    private String isinCd;         // ISIN
    private String a0231;          // 과표
    private String deposit;        // 예탁
    private BigDecimal chgRt;      // 전환비율
    private Boolean isNew;         // 신규 행 여부
}
