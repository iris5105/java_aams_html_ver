package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * DTO for w_ja020n LOAD잔고내역 (d_ja020n_siga.srd)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja020nSigaDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String s1;
    private String jasanNm;
    private String fundCd;
    private String fundNm;
    private String jmCd;
    private String jmNm;
    private BigDecimal aekm;
    private BigDecimal chuiAek;
    private BigDecimal sigaAek;
    private String loadOk;
}
