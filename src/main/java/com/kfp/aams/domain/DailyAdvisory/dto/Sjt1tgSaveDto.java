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
public class Sjt1tgSaveDto {
    private String corpGr;
    private String ymd;
    private List<Sjt1tgDto> createdRows;
    private List<Sjt1tgDto> updatedRows;
    private List<Sjt1tgDto> deletedRows;
}
