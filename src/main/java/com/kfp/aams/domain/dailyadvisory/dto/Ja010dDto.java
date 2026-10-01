package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class Ja010dDto {
    private String corpGr;
    private String fundCd;
    private String fundNm;
    private String trYmd;
    private BigDecimal inAek;
    private BigDecimal outAek;
    private BigDecimal ioJo;
    private BigDecimal wonbonAek;
    private Integer pVisible;

    @JsonProperty("isNew")
    private Boolean isNew;

    @JsonProperty("isUpdated")
    private Boolean isUpdated;

    public boolean isNew() {
        return Boolean.TRUE.equals(this.isNew);
    }

    public boolean isUpdated() {
        return Boolean.TRUE.equals(this.isUpdated);
    }
}
