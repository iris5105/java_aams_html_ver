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
public class Ja030cSaveRequestDto {
    private String corpGr;
    private String trYmd;
    private String trCd;
    private List<Ja030cDto> items;
    private List<Ja030cDto> deletedList;
}
