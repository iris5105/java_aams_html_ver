package com.kfp.aams.domain.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDto {
    private String sysId;
    private String corpGr;
    private String userId;
    private String userNm;
    private String adminYn;
    private String managerYn;
    private String watchmanYn;
    private String encEMail;
    private String inYmd;
    private String outYmd;
    private String deptCd;
    private String deptNm;
    private String regNum;
    private String unSymd;
    private String encTelNo;
    private String encPw;
    private Integer pwCnt;
    private String pwChg;
    private String lastConnect;
    private String bookmarkStart;

    // Additional UI Context attributes
    private String companyName;
    private String hyunYmd;
    private String customerGr;
}
