package com.kfp.aams.domain.usportfoliomodel.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

/** d_ja036j2b.srd 1:1 최근 환율 이력 DTO. */
@Data
public class Ja036j2HistoryDto {
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate gijunYmd;
    private BigDecimal gijunRt;
    private BigDecimal transRt;
    private BigDecimal gijun;
    private BigDecimal trans;
}
