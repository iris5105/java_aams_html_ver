package com.kfp.aams.domain.daily.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class Shj0igId implements Serializable {
    private String corpGr;
    private String jmCd;
    private BigDecimal guganNo;
}
