package com.kfp.aams.dto;

import lombok.*;

@Data
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
    private String symd;
    private String eymd;
    private Integer depositDd;
    private String depositAccount;
    private String bigo;
    private String customerGr;
    private String expenseYn;
}
