package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 예상배당 확정등록 좌측 회사 목록 DTO (dl_corp_gr)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja021bCorpDto {

    private String corpGr;
    private String corpNm;
    private Integer dataCount; // 해당 월 배당데이터 건수
}
