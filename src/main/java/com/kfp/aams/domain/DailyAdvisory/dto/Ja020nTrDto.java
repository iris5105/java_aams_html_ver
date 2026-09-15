package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * DTO for w_ja020n LOAD체결내역 (d_ja020n_tr.srd)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja020nTrDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String trCd;
    private String fundCd;
    private String fundNm;
    private String trCoCd;
    private String jmCd;
    private String jmNm;
    private Long offerNo;
    private BigDecimal trJusu;
    private BigDecimal trAek;
    private String encAcctNo;
    private String koscomCd;
    private String dancGb;
    private BigDecimal susu;
    private BigDecimal tax;
    private String sudoYmd;
    private String status;
    private String loadOk;
}
