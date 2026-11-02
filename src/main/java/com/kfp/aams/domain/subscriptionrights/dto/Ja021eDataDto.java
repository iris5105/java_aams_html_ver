package com.kfp.aams.domain.subscriptionrights.dto;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDate;
@Getter @Setter
public class Ja021eDataDto {
    private Ja021eBondDto bond;
    private java.util.List<Ja021eDetailDto> rows;
    private BigDecimal closePrice;
    private LocalDate systemDate;
    private LocalDate workDate;
    private Boolean canManage;
}
