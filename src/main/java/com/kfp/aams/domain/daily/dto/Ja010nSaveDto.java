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
public class Ja010nSaveDto {
    private List<Ja010nDto> createdRows;
    private List<Ja010nDto> updatedRows;
    private List<Ja010nDto> deletedRows;
}
