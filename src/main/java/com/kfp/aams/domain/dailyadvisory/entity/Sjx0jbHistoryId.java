package com.kfp.aams.domain.dailyadvisory.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Sjx0jbHistoryId implements Serializable {
    private String balhCo;
    private LocalDateTime ymd;
    private String chgColumn;
}
