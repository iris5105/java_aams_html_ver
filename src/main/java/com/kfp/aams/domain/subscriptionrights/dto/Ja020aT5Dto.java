package com.kfp.aams.domain.subscriptionrights.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * W_JA020A 탭3: 수요예측참여총괄표 목록 DTO (d_ja020a_t5)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020aT5Dto {

    private String corpGr;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate ymd;

    private String jcJoin;
    private String sjJmCd;
    private String jgTrCoCd;
    private String jmNm;
    private String cyGb;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate scYmd;
    private BigDecimal scJusu;
    private BigDecimal scDanga;

    private BigDecimal cyJusu;
    private BigDecimal cyDanga;
    private String bigo;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate lockEnd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate cyYmd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate nabibYmd;
}
