package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class Ja031cSaveRequest {
    private String corpGr;
    private LocalDate ymd;
    private String trCd;
    private List<Ja031cDto> rows;
    private List<Ja031cDto> deletedRows;
}
