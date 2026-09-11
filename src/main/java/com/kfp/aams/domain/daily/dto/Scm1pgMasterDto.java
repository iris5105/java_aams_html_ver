package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Master DTO for d_scm1pg_1 (채권신용등급 관리 마스터)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Scm1pgMasterDto {
    private String jmCd;   // 종목코드
    private String cjNm;   // 종목명
}
