package com.kfp.aams.domain.dailyadvisory.dto;

import lombok.Getter;
import lombok.Setter;

/** Security lookup result used while importing broker trade files for W_JA010E. */
@Getter
@Setter
public class Ja010eImportSecurityDto {

    private String jmCd;
    private String jjNm;
    private String koscomCd;
    private String dancGb;
}
