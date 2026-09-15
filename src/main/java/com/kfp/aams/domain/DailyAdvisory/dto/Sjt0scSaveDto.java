package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Sjt0scSaveDto {
    private String corpGr;
    private String ymd;
    private List<Sjt0scDto> createdRows;
    private List<Sjt0scDto> updatedRows;
    private List<Sjt0scDto> deletedRows;
}
