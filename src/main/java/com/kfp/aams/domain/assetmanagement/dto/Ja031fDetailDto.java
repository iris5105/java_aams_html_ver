package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.math.BigDecimal;

/**
 * d_ja031f1.srd 매핑 DTO (채권 매매내역 상세 목록)
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja031fDetailDto {
    private String trYmd;
    private String fundCd;
    private String fundNm;
    private String trCd;
    private String trNm;
    private BigDecimal meibAekm;
    private BigDecimal meibTrAek;
    private BigDecimal medoAekm;
    private BigDecimal medoTrAek;
    private BigDecimal susu;
    private BigDecimal ijaTax;
    private BigDecimal gyulAek;
    private String jmCd;
    private String cjNm;
    private BigDecimal suikPer;
    private String balhYmd;
    private String sanghwYmd;
    private BigDecimal pyomPer;
    private String trCoCd;
    private String trCoNm;
    private String sudoYmd;
    private BigDecimal mmSonik;
    private String trColor;

    // 합계 행 구분을 위한 플래그
    private Boolean isSummaryRow;
}

