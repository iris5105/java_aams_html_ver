package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 현금/단기금융 매매내역 상세 DTO (d_ja031g1.srd 1:1 매핑)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja031gDetailDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 매매일자 (YYYY-MM-DD) */
    private String trYmd;

    /** 펀드번호 (관리번호) */
    private String fundCd;

    /** 계좌명 */
    private String fundNm;

    /** 거래코드 */
    private String trCd;

    /** 매매구분명 (F_TR_NM) */
    private String trNm;

    /** 종목코드 */
    private String jmCd;

    /** 종목명 (shm0hj.hj_nm) */
    private String hjNm;

    /** 매매액면 */
    private BigDecimal aekm;

    /** 상환액 */
    private BigDecimal sanghwAek;

    /** 매매금액 */
    private BigDecimal trAek;

    /** 수익률 (%) */
    private BigDecimal suikPer;

    /** 수수료 */
    private BigDecimal susu;

    /** 취득원가 (매도 시) */
    private BigDecimal chuiAek;

    /** 수입이자 (매도 시) */
    private BigDecimal suipIja;

    /** 매매손익 */
    private BigDecimal mmSonik;

    /** 제세금 */
    private BigDecimal mijigubTax;

    /** 정산금액 */
    private BigDecimal jungsanAek;

    /** 발행일자 */
    private String balhYmd;

    /** 상환일자 */
    private String sanghwYmd;

    /** 표면이율 (%) */
    private BigDecimal pyomPer;

    /** 거래색상 구분 (J: 매입-파랑, K: 매도-빨강) */
    private String trColor;

    /** Rule 06: Data Summary Row 구분 플래그 */
    private Boolean isSummaryRow;

    /** 그리드 행 순번 (No.) */
    private Integer fseq;
}

