package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.util.List;

@Data
public class Ja031bSaveRequest {
    private String corpGr;
    private List<Ja031bDto> rows;
    private List<Ja031bDto> deletedRows;
}

