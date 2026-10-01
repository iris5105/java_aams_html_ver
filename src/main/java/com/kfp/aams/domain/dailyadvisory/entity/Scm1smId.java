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
public class Scm1smId implements Serializable {

    private String corpGr;
    private LocalDate ymd;
    private String jmCd;
}
