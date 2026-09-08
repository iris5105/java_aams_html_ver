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
public class Sjt0tgSaveDto {
    private String corpGr;
    private String ymd;
    private List<Sjt0tgDto> insertList;
    private List<Sjt0tgDto> updateList;
    private List<Sjt0tgDto> deleteList;
}
