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
public class Scm1pgSaveDto {
    private String corpGr;
    private String jmCd;
    private List<Scm1pgDetailDto> createdRows;
    private List<Scm1pgDetailDto> updatedRows;
    private List<Scm1pgDetailDto> deletedRows;
}
