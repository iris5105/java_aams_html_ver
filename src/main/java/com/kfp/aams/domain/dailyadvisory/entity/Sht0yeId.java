package com.kfp.aams.domain.dailyadvisory.entity;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class Sht0yeId implements Serializable {

    private String corpGr;
    private LocalDate trYmd;
    private String fundCd;
    private String trCoCd;
}
