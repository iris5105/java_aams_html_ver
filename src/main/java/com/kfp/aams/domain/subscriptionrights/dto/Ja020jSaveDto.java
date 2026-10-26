package com.kfp.aams.domain.subscriptionrights.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

/**
 * W_JA020J 시가평가액 저장 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020jSaveDto {

    private String corpGr;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate ymd;

    private List<Ja020jDto> updatedList;
}
