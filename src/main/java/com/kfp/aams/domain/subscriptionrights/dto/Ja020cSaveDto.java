package com.kfp.aams.domain.subscriptionrights.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class Ja020cSaveDto {
    private Ja020cFilterDto filter;
    private List<Ja020cDto> rows;
}

