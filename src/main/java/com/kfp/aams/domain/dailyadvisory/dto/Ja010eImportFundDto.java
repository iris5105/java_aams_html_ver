package com.kfp.aams.domain.dailyadvisory.dto;

import lombok.Getter;
import lombok.Setter;

/** Active fund account used while importing broker trade files for W_JA010E. */
@Getter
@Setter
public class Ja010eImportFundDto {

    private String fundCd;
    private String fundNm;
    private String encAcctNo;
    private String acctNo;
}
