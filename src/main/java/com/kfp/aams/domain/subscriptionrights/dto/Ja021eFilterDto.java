package com.kfp.aams.domain.subscriptionrights.dto;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDate;
@Getter @Setter
public class Ja021eFilterDto {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String cjCd;
    private String koscomCd;
    private String ijaBaedGb;
    private String dancGb;
}
