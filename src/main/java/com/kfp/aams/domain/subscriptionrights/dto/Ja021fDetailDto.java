package com.kfp.aams.domain.subscriptionrights.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

/** W_JA021F 펀드별 상세 조회 DTO. */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja021fDetailDto {
    private String corpGr;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate ymd;
    private String balhCo;
    private String jeungjMth;
    private String fundCd;
    private String oldJmCd;
    private String newJmCd;
    private BigDecimal krakJusu;
    private BigDecimal krakChuiAek;
    private BigDecimal baejJusu;
    private BigDecimal baejRt;
    private BigDecimal balhGa;
    private BigDecimal chuiAek;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate gosiJekyngYmd;
    private BigDecimal chgBfJusu;
    private BigDecimal chgBfRt;
    private BigDecimal chgBfBalhGa;
    private BigDecimal chgChuiAek;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate chgBfYmd;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate suryYmd;
    private BigDecimal suryJusu;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate chengYmd;
    private BigDecimal chengJusu;
    private String haejiFund;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate haejiYmd;
    private String typeTrench;
    private String bsType;
    private String updUser;
    private String fundNm;
}
