package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
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
        private String ymd;
        private String fundCd;
        private String jmGr;
        private String jmCd;
        private String buyDate;
        private BigDecimal chasu;
        private BigDecimal vcOld;
    }
}
