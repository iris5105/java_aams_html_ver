package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020rDetailDto {
    private String corpGr;
    private String ymd;
    private String fundCd;
    private String jmCd;
    private String jmNm;
    private String buyDate;         // 채권용 매입일자 (YYYY.MM.DD 또는 YYYYMMDD)
    private BigDecimal bfilAekm;    // 보유액면 (채권, 현금)
    private BigDecimal bfilBoyuJusu; // 보유주수 (주식)
    private BigDecimal bfilChuiAek; // 취득액
    private BigDecimal alterAek;    // 수정취득액 (수정 가능)
    private BigDecimal chaAek;      // 수정차액
    private String typeTrench;      // 주식 트렌치
    private BigDecimal bsType;      // 주식 BS타입
    private String ipUser;          // 입력자
    private Boolean isUpdated;      // 화면 수정 여부 플래그
}
