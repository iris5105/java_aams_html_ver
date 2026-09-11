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
public class Ja010m3SaveDto {
    private List<Ja010m3ItemSaveDto> updatedList;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Ja010m3ItemSaveDto {
        private String corpGr;
        private String gyulYmd;
        private String fundCd;
        private BigDecimal basicBosu;
        private BigDecimal successBosu;
        private BigDecimal totalBosu;
        private BigDecimal recontractAek;
        private BigDecimal wmSeoljAek;
        private BigDecimal wmSonik;
        private String docNo;
        private String haejiSayu;
        private String sendMailAddr;
        private String sendCcAddr;
        private String productNm;
        private String contractCondition;
        private String tblGb;
    }
}
