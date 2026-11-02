package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.Data;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.LocalDate;
import java.math.BigDecimal;
import com.kfp.aams.domain.subscriptionrights.entity.Sjt0hkId;

@Data
public class Ja021gMasterDto {
    private LocalDate trYmd;
    private String trCd;
    private String habCo;
    private String piHabCo;
    private BigDecimal habIlbanRt;
    private BigDecimal habWoosRt;
    private BigDecimal habIlbanAek;
    private BigDecimal habWoosAek;
    private BigDecimal gamIlbanRt;
    private BigDecimal gamWoosRt;
    private BigDecimal gamIlbanAek;
    private BigDecimal gamWoosAek;
    private BigDecimal piHabIlbanRt;
    private BigDecimal piHabWoosRt;
    private BigDecimal piHabIlbanAek;
    private BigDecimal piHabWoosAek;
    private String xxHabCo;
    private String xxPiHabCo;
    /** PowerBuilder P_VISIBLE: 공시일자가 작업일 이상이면 1 */
    private Integer pVisible;
    private Sjt0hkId original;
    @JsonProperty("isNew")
    private boolean isNew;
    @JsonProperty("isUpdated")
    private boolean isUpdated;
    @JsonProperty("isDeleted")
    private boolean isDeleted;
}

