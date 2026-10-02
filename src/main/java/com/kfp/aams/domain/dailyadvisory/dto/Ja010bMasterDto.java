package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010bMasterDto {
    private String corpGr;
    private String encAcctNo;
    private String fundCd;
    private String fundNm;
    private String typeGb;
    private String typeGbNm;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate fstSeoljYmd;

    private Integer sintakGigan;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate bfGyulYmd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate afGyulYmd;

    private BigDecimal preBasic;
    private BigDecimal basicPer;
    private BigDecimal bmPer;
    private BigDecimal successPer;
    private String seriesGb;
    private String targetJasan;
    private Integer gyulGi;
    private String haejiGb;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate haejiYmd;

    private Integer reSeoljYear;
    private BigDecimal reSeoljAek;
    private String mgCd;
    private String mgNm;
    private BigDecimal susuRt;
    private String email1;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate reSeoljYmd;

    private String unyongSabun;
    private String orderSend;
    private String expenseYn;
    private String aliasCode;
    private String specialNote;
    private String noteText;
    private String acctNo;
    private Integer pVisible;
    private Boolean isNew;
    private Boolean isUpdated;
}
