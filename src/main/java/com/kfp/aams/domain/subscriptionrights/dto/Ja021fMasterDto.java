package com.kfp.aams.domain.subscriptionrights.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

/** W_JA021F 증자 기준정보 조회 DTO. */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja021fMasterDto {
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate trYmd;
    private String trCd;
    private String balhCo;
    private String jeungjMth;
    private String baejMth;
    private BigDecimal balhGa;
    private BigDecimal woosBalhGa;
    private BigDecimal jekyngRt;
    private BigDecimal woosJekyngRt;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate baedGisanYmd;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate chengYmd;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate krakYmd;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate baejGijunYmd;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate jukmNabibYmd;
    private String sinjJaew;
    private BigDecimal ilbanBalhJusu;
    private BigDecimal woosBalhJusu;
    private String xxBalhCo;
    private String jkBaejMth;
    private BigDecimal jkBalhGa;
    private BigDecimal jkJekyngRt;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate closeYmd;
    private Integer pVisible;
}
