package com.kfp.aams.domain.dailyadvisory.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Sjt1jgId implements Serializable {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String trCoCd;
    private Long offerNo;
}
