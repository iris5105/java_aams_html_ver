package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_uzm0hy (계좌(종목)별 주간 운용현황 펀드 목록)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Uzm0hyDto {
    private String corpGr;
    private String encAcctNo;
    private String acctNo;
    private String fundCd;
    private String fundNm;
    private String typeGb;
    private String fstSeoljYmd;
    private BigDecimal sintakGigan;
    private String bfGyulYmd;
    private String afGyulYmd;
    private String targetJasan;
    private BigDecimal gyulGi;
    private String haejiGb;
    private String haejiYmd;
    private BigDecimal reSeoljYear;
    private BigDecimal reSeoljAek;
    private String mgCd;
    private String reSeoljYmd;
    private String seriesGb;
    private String gugan;
}
