package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class Ja030aSaveRequest {
    private LocalDate trYmd;
    private String trCd;
    private String jmCd;
    private String balhCo;
    private List<Ja030aDto> items;
    private List<Ja030aDto> deletedList;
}
