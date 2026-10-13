package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 일괄 저장 요청 DTO (마스터, 포트, 종목 상세)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032aSaveRequestDto {

    private String corpGr;
    private String trYmd;
    private String fundCd;
    private String portNum;

    // 마스터 변경 목록
    private List<Ja032aMasterDto> masterList;

    // 포트 목록 (CUD)
    private List<Ja032aPortDto> portList;

    // 종목 상세 목록 (CUD)
    private List<Ja032aDetailDto> detailList;
}
