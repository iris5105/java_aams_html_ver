package com.kfp.aams.domain.dailyadvisory.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Skt1gsIndataId implements Serializable {
    private String corpGr;
    private LocalDate gyulYmd;
    private String fundCd;
}
