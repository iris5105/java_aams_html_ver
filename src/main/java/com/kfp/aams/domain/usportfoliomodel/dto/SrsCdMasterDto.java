package com.kfp.aams.domain.usportfoliomodel.dto;

import java.math.BigDecimal;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 해외파생 생성종목 (d_srs_cd1.srd / SRS_CD) 마스터 DTO
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SrsCdMasterDto {

    private String srsCd;          // 파생종목코드 (PK)
    private BigDecimal stkprc;     // 행사가격
    private String blbgTckr;       // 주식종목 (Bloomberg Ticker)
    private String isinCd;         // ISIN 코드
    private String exchCd;         // 거래소코드
    private String crcCd;          // 통화코드
    private String exprDate;       // 만기일자 (YYYYMMDD)
    private String gijunStkprcYn;  // 기준행사가여부 (Y/N)
    private String week;           // 주차

    // 수정 전 원본 키 보관 (PK 변경 또는 삭제 시 사용)
    private String origSrsCd;

    // CUD 상태 관리 필드 (규정 02-3)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
