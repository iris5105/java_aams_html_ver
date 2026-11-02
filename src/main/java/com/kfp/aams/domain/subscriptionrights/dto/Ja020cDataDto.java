package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class Ja020cDataDto {
    private List<Ja020cDto> rows;
    private LocalDate workDate;
    private Boolean canManage;
    private String resolvedJmCd;
}

