package com.kfp.aams.domain.foreignassetmanagement.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/** d_ja036j2a.srd 1:1 환율 관리 DTO. */
@Data
public class Ja036j2Dto {
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate gijunYmd;
    private String currency;
    private BigDecimal gijunRt;
    private BigDecimal transRt;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime ipYmd;
    private BigDecimal crossRate;
    private String crossCurrency;
    private String currencyGb;
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;
}
