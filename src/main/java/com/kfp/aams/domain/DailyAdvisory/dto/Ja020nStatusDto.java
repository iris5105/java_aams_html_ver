package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

/**
 * DTO for w_ja020n 처리결과조회 (d_ja020n.srd)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja020nStatusDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String corpGr;
    private String loadDate;
    private String ipUser;
    private String userNm;
    private String loadOk;
    private String loadNaye;
    private String loadYmd;
}
