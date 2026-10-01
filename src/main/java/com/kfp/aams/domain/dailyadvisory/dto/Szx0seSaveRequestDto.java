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
public class Szx0seSaveRequestDto {
    private String corpGr;
    private List<Szx0seDto> insertList;
    private List<Szx0seDto> updateList;
    private List<Szx0seDto> deleteList;
}
