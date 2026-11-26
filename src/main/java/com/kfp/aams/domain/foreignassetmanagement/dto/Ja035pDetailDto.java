package com.kfp.aams.domain.foreignassetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * W_JA035P 디테일 DTO (DataWindow: d_ja035p2, 테이블: SYT9MG_TR)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja035pDetailDto {

    private String corpGr;
    private String trYmd;
    private String trCd;
    private String fundCd;
    private String trustee;
    private String hjCd;        // syt9mg_tr.jm_cd
    private Long trSeq;
    private String aekGb;
    private String currency;
    private String trCoCd;
    private BigDecimal sanghwAek;
    private BigDecimal wonSanghwAek;
    private BigDecimal gijunRt;
    private BigDecimal janAek;
    private BigDecimal wonJanAek;
    private BigDecimal wonHwanCha;
    private BigDecimal fcurJanAek;
    private BigDecimal fcurHwanCha;
    private String sanghwYmd;
    private Integer pVisible;

    // 수정/삭제 시 원본 키 보존용
    private String origSanghwYmd;

    // 양방향 명칭 프로퍼티
    private String xxFundCd;
    private String xxJmNm;

    // CUD 상태 관리 필드
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
