package com.kfp.aams.domain.assetmanagement.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 원리금 상환 명세표 DTO (d_ja030k1 & d_ja030k1_2402 매핑)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja030kDto {

    private String corpGr;

    /** 상환일자 (YYYY-MM-DD) */
    private String sanghwYmd;

    /** 관리번호 (fundCd - Rule 04 및 화면 표준) */
    private String fundCd;

    /** 계좌명 / 고객명 */
    private String fundNm;

    /** 분류 / 종목구분코드 (H: 현금, C: 채권) */
    private String jmGr;

    /** 종목구분명 (채권, 현금) */
    private String jmGu;

    /** 종목코드 */
    private String jmCd;

    /** 종목명 */
    private String jmNm;

    /** 선후구분 (1: 선급, 2: 후급) */
    private String sunhuGb;

    /** 매입일자 */
    private String buyDate;

    /** 액면 / 상환액면 */
    private BigDecimal aekm;

    /** 원금 / 취득액 */
    private BigDecimal wonGm;

    /** 취득액 (2402용) */
    private BigDecimal chuiAek;

    /** 수입이자 / 수령이자액 (2402에서 인라인 편집 대상) */
    private BigDecimal misuIja;

    /** 선급비용 */
    private BigDecimal sungCost;

    /** 세금 (선납세금 + 예수세금) (2402에서 인라인 편집 대상) */
    private BigDecimal sunnTax;

    /** 이자세금 (2402용) */
    private BigDecimal ijaTax;

    /** 수령액 / 원리금 */
    private BigDecimal wonRiGm;

    /** 수령액 (2402용) */
    private BigDecimal suryAek;

    /** 휴일선수이자 */
    private BigDecimal holSunsuIja;

    /** 상환경과수입이자 */
    private BigDecimal holSuibIja;

    /** 수탁사 */
    private String trustee;

    /** 통화 */
    private String currency;

    /** 수정자 */
    private String modUser;

    /** 수정일시 */
    private String modDt;

    // CUD 상태 관리 필드 (Rule 02)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}

