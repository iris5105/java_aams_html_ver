package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class Ja030hSaveRequest {
    private LocalDate trYmd;
    private String trCd;
    private List<Ja030hDto> items;
    private List<Ja030hDto> deletedList;
}
