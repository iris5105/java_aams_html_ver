package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for d_shm1pg (현금신용등급 관리)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Shm1pgDto {
    private String corpGr;     // 회사그룹
    private String jmCd;       // 종목코드
    private String ksdJmCd;    // KSD종목코드
    private String hjNm;       // 종목명
    private String pgCd;       // 적용등급 (신용등급코드)
    private String pgNm;       // 적용등급명 (드롭다운 코드명)
    private String fundCd;     // 매수계좌
    private String fundNm;     // 계좌명

    private String rowStatus;  // U: 수정
}
