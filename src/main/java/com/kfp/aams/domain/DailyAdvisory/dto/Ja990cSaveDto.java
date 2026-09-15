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
public class Ja990cSaveDto {
    private List<Ja990cMasterDto> insertedList;
    private List<Ja990cMasterDto> updatedList;
    private List<Ja990cMasterDto> deletedList;
    private List<Ja990cDetailDto> historyList;
}
