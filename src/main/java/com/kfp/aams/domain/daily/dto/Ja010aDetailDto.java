package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010aDetailDto {
    private String corpGr;
    private String ymd;
    private String companyName;
    private String idno;
    private String contractYmd;
    private String post;
    private String juso;
    private String ceoNm;
    private String telNo;
    private String faxNo;
    private String email;
    private Integer pVisible;
}
