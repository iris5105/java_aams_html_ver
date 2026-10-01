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
public class Ja010bSaveRequestDto {
    private String corpGr;
    private List<Ja010bMasterDto> masterList;
    private List<Ja010bDetailDto> detailList;
    private List<Ja010bIoDto> ioList;
    private List<Ja010bDetailDto> deletedDetailList;
    private List<Ja010bIoDto> deletedIoList;
    private List<Ja010bMasterDto> deletedMasterList;
}
