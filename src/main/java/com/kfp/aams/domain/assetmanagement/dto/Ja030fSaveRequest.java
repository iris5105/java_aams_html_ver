package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class Ja030fSaveRequest {
    private LocalDate trYmd;
    private List<Ja030fDto> items;
    private List<Ja030fDto> deletedList;
}
