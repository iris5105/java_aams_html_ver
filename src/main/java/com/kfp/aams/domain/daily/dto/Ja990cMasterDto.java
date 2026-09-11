package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO for d_ja990c1 (발행기관 기본정보 마스터)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja990cMasterDto {
    private String balhCo;         // 발행기관코드 (PK)
    private String balhNm;         // 발행기관명
    private String trStopGb;       // 거래정지구분
    private String sosokGb;        // 소속구분
    private BigDecimal aekm;       // 액면
    private String grBalhGb;       // 발행기관분류
    private String budoYmd;        // 부도일자
    private String compCd;         // KOSCOM코드
    private String gyulMm;         // 결산월
    private String isinCd;         // ISIN코드
    private String compBu;         // 부서코드
    private String balhNation;     // 발행국가 (기본 KR)
    private String encBubinNo;     // 암호화 법인번호
    private String delYn;          // 삭제여부 ('Y'/'0')
    private String bubinNo;        // 복호화 법인번호
    private Integer pVisible;
    private Boolean isNew;         // 신규 행 여부
}
