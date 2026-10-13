package com.kfp.aams.domain.usportfoliomodel.entity;

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
public class UspmPortId implements Serializable {

    private String corpGr;
    private LocalDate tymd;
    private String fundCd;
    private String portNum;
}
