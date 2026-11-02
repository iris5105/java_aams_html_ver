package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
public class Ja020cFilterDto {
    private String corpGr;

    @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"})
    private LocalDate ymd;

    private String dddw;
    private String dancGb;
    private String koscomCd;
    private String xxKoscomCd;
    private String xxJmCd;

    @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"})
    private LocalDate baedGisanYmd;
}

