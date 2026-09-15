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
public class Shm1pgSaveDto {
    private String corpGr;
    private String ymd;
    private List<Shm1pgDto> updatedRows;
}
