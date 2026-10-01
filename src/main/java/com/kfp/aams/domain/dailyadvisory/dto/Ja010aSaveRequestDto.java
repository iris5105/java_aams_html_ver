package com.kfp.aams.domain.dailyadvisory.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010aSaveRequestDto {
    private List<Ja010aMasterDto> masterList;
    private List<Ja010aDetailDto> detailList;
    private List<Ja010aMasterDto> deletedMasterList;
    private List<Ja010aDetailDto> deletedDetailList;
}
