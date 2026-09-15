package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010aMasterDto {
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
    private Integer pVisible;
}
