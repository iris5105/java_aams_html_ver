package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja030jDto {

    private String ymd;             // 일자 (YYYY-MM-DD)
    private String jmCd;            // 종목코드
    private String hjNm;            // 종목명
    private String sanghwYmd;       // 상환일자 (YYYY-MM-DD)
    private String afIjaYmd;        // 차기이자일자 (YYYY-MM-DD)
    private BigDecimal pyomIyul;    // 표면이율
    private BigDecimal pyomPer;     // 표면이율(%) (pyomIyul * 100)
    private String fundCd;          // 펀드코드 / 관리번호
    private String fundNm;          // 펀드명 / 계좌명
    private BigDecimal comAekm;     // 액면(만)
    private BigDecimal comChuiAek;  // 계산 취득액
    private BigDecimal chuiAek;     // 실제 표출 취득액 (cashCd='90'이면 meibAek, 아니면 comChuiAek)
    private BigDecimal misuIja;     // 미수이자
    private BigDecimal dayIja;      // 당일이자
    private BigDecimal sunsuIja;    // 선수이자잔액
    private BigDecimal dwSunsuIja;  // 당일선수이자
    private BigDecimal pyungaAek;   // 평가액
    private BigDecimal sigaAek;     // 시가평가액
    private BigDecimal yuhyoRt;     // 유효이자율
    private String cashCd;          // 현금종류
    private BigDecimal meibAek;     // 매입액
    private String mgCd;            // 운용구분
    private String typeGb;          // 유형구분
    private Long nowIjaHoicha;      // 현재 이자회차
    private Long fundColor;         // 색상

    // CUD 및 합계 행 상태 관리 필드 (Rule 02, Rule 06)
    private Boolean isSummaryRow;
}

