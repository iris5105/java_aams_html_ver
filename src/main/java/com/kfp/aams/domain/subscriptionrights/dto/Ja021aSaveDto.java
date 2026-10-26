package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

/**
 * 예상배당 공시등록 일괄 저장 DTO
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja021aSaveDto {

    private String corpGr;
    private String ymd;
    private String trCd;
    private List<Ja021aMasterDto> masterList;
    private List<Ja021aDetailDto> detailList;
}
