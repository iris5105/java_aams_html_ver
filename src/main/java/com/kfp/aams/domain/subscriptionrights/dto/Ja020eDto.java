package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

/**
 * W_JA020E (미수령 권리내역 조회) 그리드 DTO (d_ja020e1.srd 1:1 매핑)
 */
@Getter
@Setter
@NoArgsConstructor
public class Ja020eDto {
    private String balhNm;
    private String trNm;
    private LocalDate trYmd;
    private LocalDate krakYmd;
    private LocalDate baejGijunYmd;
    private LocalDate chengYmd;
    private LocalDate suryYmd;
}

