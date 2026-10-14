package com.kfp.aams.domain.usportfoliomodel.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

/**
 * USPM CALL 설정 저장 요청 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032eCallSaveRequestDto {
    private String corpGr;
    private String ymd;

    @Builder.Default
    private List<Ja032eCallFundDto> fundList = new ArrayList<>();

    @Builder.Default
    private List<Ja032eCallPortDto> portList = new ArrayList<>();
}
