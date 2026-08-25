package com.kfp.aams.domain.home.dto;

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
public class CompanyDto {
    private String corpGr;
    private String companyName;
    private String hyunYmd;
    private String gijungaYmd;
    private String junyongYmd;
    private String ikyongYmd;
    private String thikyongYmd;
    private String lastYmd;
    private String symd;
    private String eymd;
    private String checkYmd;
    private String h2o;
    private Integer depositDd;
    private String depositAccount;
    private String bigo;
    private String customerGr;
    private String expenseYn;
}
