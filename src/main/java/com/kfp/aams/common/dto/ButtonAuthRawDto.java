package com.kfp.aams.common.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

/**
 * 파워빌더 fw_d_commbtnauth.srd 쿼리 결과 매핑 DTO
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ButtonAuthRawDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String roleNo;
    private String pgmNo;
    private String commBtnAuthYn;
    private String cancelAuthYn;
    private String retrieveAuthYn;
    private String inputAuthYn;
    private String ext1AuthYn;
    private String updateAuthYn;
    private String deleteAuthYn;
    private String printAuthYn;
    private String excelAuthYn;
    private String executeAuthYn;
    private String indivBtnAuthYn;
}
