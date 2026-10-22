package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 해외 업종/지수/환율 코드 DTO (d_ja032h.srd 매핑)
 * 테이블: API_FRGNCODE
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032hDto implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 구분 (FRID) - 기본키 */
    private String frid;

    /** 코드 (FRGN) - 기본키 */
    private String frgn;

    /** 영문명 (ENAM) */
    private String enam;

    /** 한글명 (KNAM) */
    private String knam;

    /** SYMB */
    private String symb;

    /** EXID */
    private String exid;

    /** MKCD */
    private String mkcd;

    /** MKID */
    private String mkid;

    // --- CUD 상태 관리 필드 ---
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus; // C: 등록, U: 수정, D: 삭제
}
