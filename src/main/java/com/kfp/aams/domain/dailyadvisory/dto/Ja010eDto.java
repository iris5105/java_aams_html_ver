package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * DTO for w_ja010e 주식체결LOAD(입고) (d_ja010e1.srd / SJT1JG)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties(ignoreUnknown = true)
public class Ja010eDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String corpGr;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate trYmd;

    private String trCd;
    private String trCoCd;
    private Long offerNo;
    private String encAcctNo;
    private String jmCd;
    private String koscomCd;
    private BigDecimal trJusu;
    private BigDecimal trAek;
    private String fundCd;
    private String fundNm;
    private String jjNm;
    private String dancGb;
    private BigDecimal susu;
    private BigDecimal tax;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate sudoYmd;

    private String acctNo;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime loadTime;

    private Integer pVisible;
    private BigDecimal danga;

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
