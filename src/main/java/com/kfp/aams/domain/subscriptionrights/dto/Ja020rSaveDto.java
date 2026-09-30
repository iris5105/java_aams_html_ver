package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020rSaveDto {
    private String corpGr;
    private String ymd;
    private String dwType; // "d_ja020r2c" | "d_ja020r2h" | "d_ja020r2j"
    private List<Ja020rDetailDto> updatedList;
}
