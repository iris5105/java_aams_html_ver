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
public class Ja990dSaveDto {
    private List<Ja990dDto> insertedList;
    private List<Ja990dDto> updatedList;
    private List<Ja990dDto> deletedList;
}
