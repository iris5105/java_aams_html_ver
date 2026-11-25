package com.kfp.aams.domain.foreignassetmanagement.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class Ja036j2SaveRequest {
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate ymd;
    private List<Ja036j2Dto> rows;
}
