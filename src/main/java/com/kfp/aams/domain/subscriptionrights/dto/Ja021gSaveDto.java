package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.Data;
import java.util.List;

@Data
public class Ja021gSaveDto {
    private String tab;
    private List<Ja021gMasterDto> master = List.of();
    private List<Ja021gDetailDto> detail = List.of();
}

