package com.kfp.aams.domain.assetmanagement.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 원리금 상환 명세표 저장 요청 DTO (2402 리셋자산운용 수령이자/세금/수령액 수정용)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja030kSaveRequest {
    private String corpGr;
    private List<Ja030kDto> updatedList;
}

