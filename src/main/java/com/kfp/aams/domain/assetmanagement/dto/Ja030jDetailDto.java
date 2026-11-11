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
public class Ja030jDetailDto {

    private String hjBalhYmd;       // 발행일자
    private String hjSanghwYmd;     // 상환일자
    private String hjAfIjaYmd;      // 차기이자일자
    private BigDecimal hjPyomIyul;  // 표면이율

    private BigDecimal hmDayIja;    // 하루이자
    private BigDecimal hmMisuIja;   // 미수이자
    private BigDecimal hmGuganIja;  // 구간이자
    private BigDecimal hmSungCost;  // 선급비용
    private BigDecimal hmSungTax;   // 선급법인세
    private BigDecimal hmSunnTax;   // 선급농특세
    private BigDecimal hmYesuTax;   // 예수세

    private BigDecimal dwSunsuIja;  // 하루선수이자
    private BigDecimal sunsuIja;    // 선수이자잔액

    private BigDecimal hmAekm;      // 액면
    private BigDecimal hmSanghwAek; // 상환액
    private BigDecimal hmAnbunAek;  // 안분액
    private BigDecimal hmChuiAek;   // 취득가
    private BigDecimal hmPyungaAek; // 평가액
    private BigDecimal hmSigaAek;   // 시가평가액
}

