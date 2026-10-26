package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

/**
 * W_JA020A 일괄 저장 요청 DTO
 */
@Getter
@Setter
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020aSaveDto {

    private String corpGr;
    private String activeTab; // "t1" | "t4"

    // 탭1: 공모종목 등록/수정
    private Ja020aT1Dto t1Data;

    // 탭2: 청약정보 및 펀드별 배정 목록
    private Ja020aT4aDto t4aData;
    private List<Ja020aT4bDto> t4bList;
}
