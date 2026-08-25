package com.kfp.aams.domain.common.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

/**
 * DropDownDataWindow DTO (WDDDWCTL query result item)
 * First column: code (코드값)
 * Second column: name (화면 표출명)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DddwDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String code; // 1st column (코드값)
    private String name; // 2nd column (화면 표출 명칭)
    private String fkey; // 3rd column (추가 키)
}