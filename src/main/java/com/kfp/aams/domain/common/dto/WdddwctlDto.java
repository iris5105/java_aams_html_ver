package com.kfp.aams.domain.common.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

/**
 * WDDDWCTL metadata table DTO
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WdddwctlDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String dddwId;
    private Integer seq;
    private String sqlColumns;
    private String sqlTables;
    private String sqlWhere;
    private String sqlRemark;
}
