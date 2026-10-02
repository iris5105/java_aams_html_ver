package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Sjt1tgSaveDto {
    private String corpGr;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate ymd;

    private List<Sjt1tgDto> createdRows;
    private List<Sjt1tgDto> updatedRows;
    private List<Sjt1tgDto> deletedRows;
}
