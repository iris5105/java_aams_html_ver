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
@com.fasterxml.jackson.annotation.JsonIgnoreProperties(ignoreUnknown = true)
public class Ja010dSaveRequestDto {
    private String corpGr;
    private String trYmd;
    private List<Ja010dDto> itemList;
    private List<Ja010dDto> deletedList;
}
