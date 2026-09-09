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
public class Scm1smSaveDto {
    private String corpGr;
    private String ymd;
    private List<Scm1smDto> insertList;
    private List<Scm1smDto> updateList;
    private List<Scm1smDto> deleteList;
}
