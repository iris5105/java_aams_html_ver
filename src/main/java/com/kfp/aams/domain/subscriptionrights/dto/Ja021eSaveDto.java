package com.kfp.aams.domain.subscriptionrights.dto;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDate;
@Getter @Setter
public class Ja021eSaveDto {
    private Ja021eFilterDto filter;
    private java.util.List<Ja021eDetailDto> rows;
}
