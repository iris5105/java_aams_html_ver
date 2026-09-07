package com.kfp.aams.domain.common.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

/**
 * WDCS01M dynamic code search master DTO
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DynamicCodeSearchDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String columnNm;
    private Integer columnSeq;
    private String headerNm;
    private String returnColumn;
    private String windowNm;
    private String cmnt;
    private String codeSelect;
    private String editSelect;
    private String columnSize;
}
