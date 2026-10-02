package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010kSaveDto {
    private List<Ja010kItemSaveDto> updatedList;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Ja010kItemSaveDto {
        private String corpGr;

        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
        private LocalDate ymd;

        private String fundCd;
        private String jmGr;
        private String jmCd;
        private String buyDate;
        private BigDecimal chasu;
        private BigDecimal vcOld;
    }
}
