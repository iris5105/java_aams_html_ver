package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

/**
 * W_JA032B_YA 선택종목일괄등록 요청 DTO
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja032bYaBulkRegisterRequest {

    private String corpGr;          // 회사그룹
    private String ymd;             // 작업기준일자 (YYYY-MM-DD)
    private String fundCd;          // 등록 대상 펀드코드
    private String portNum;         // 포트번호
    private List<StockItem> items;  // 등록 대상 종목 목록

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class StockItem {
        private String jmCd;        // 종목코드
        private String ovrsExcgCd;  // 거래소구분
    }
}
