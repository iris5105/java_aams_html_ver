package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

/**
 * 예상배당 확정등록 일괄 저장 DTO
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja021bSaveDto {

    private String tabId; // t1, t2, t3, t4, t5, popup
    private List<Ja021bMasterDto> masterList;
    private List<Ja021bItemDto> itemList;
}
