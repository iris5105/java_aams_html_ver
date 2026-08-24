package com.kfp.aams.entity;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import java.io.Serializable;

@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class FwDayTrId implements Serializable {
    private String corpGr;
    private String ymd;
    private String trCd;
}
