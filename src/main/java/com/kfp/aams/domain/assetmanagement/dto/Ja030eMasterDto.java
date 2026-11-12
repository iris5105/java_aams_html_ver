package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * W_JA030E 상단 보유 채권 종목 목록 DTO (d_ja030e1 메타데이터 기준)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja030eMasterDto {

    private String jmCd;     // 종목코드 (scm0cj.jm_cd)
    private String cjNm;     // 종목명 (scm0cj.cj_nm)
    private String sigaYn;   // 시가평가대상여부 (Y / N)

    // 상태 관리 필드 (Rule 02)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}

