package com.kfp.aams.domain.subscriptionrights.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Sjt0jkId implements Serializable {
    private String trCd;
    private String balhCo;
    private String jeungjMth;
    private LocalDate krakYmd;
}
