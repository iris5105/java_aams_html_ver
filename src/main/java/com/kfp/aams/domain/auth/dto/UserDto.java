package com.kfp.aams.dto;

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
    private String userId;
    private String userNm;
    private String outYmd;
    private String deptCd;
    private String deptNm;
    private String inYmd;
    private String corpGr;
    private String adminYn;
    private String managerYn;
    private String watchmanYn;
    private String bookmarkStart;
    private String lastConnect;
    private String encEMail;
    private String companyName;
    private String hyunYmd;
    private String customerGr;
}
