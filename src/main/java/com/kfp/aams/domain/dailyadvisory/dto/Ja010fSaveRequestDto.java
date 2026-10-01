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
public class Ja010fSaveRequestDto {
    private String corpGr;
    private String ymd;
    private List<Ja010fDto> itemList;
    private List<Ja010fDto> deletedList;
}
