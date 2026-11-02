package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;
import java.time.LocalDate;
import java.util.List;

@Data
public class Ja030dSaveRequest {
    private LocalDate ymd;
    private String trCd;
    private List<Ja030dDto> items;
    private List<Ja030dDto> deletedList;
}
