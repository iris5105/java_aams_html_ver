package com.kfp.aams.domain.subscriptionrights.dto;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDate;
@Getter @Setter
public class Ja021eBondDto {
    private BigDecimal chgGa;
    private String chgJmCd;
    private String chgStartIl;
    private LocalDate lockEnd;
}
