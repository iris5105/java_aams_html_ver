package com.kfp.aams.domain.daily.entity;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class Szx0seId implements Serializable {
    private String corpGr;
    private String seriesG1;
    private String seriesG2;
    private String seriesGb;
}
