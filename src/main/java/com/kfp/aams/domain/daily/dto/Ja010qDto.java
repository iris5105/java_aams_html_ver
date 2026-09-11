package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for d_ja010q (성과보수 상세내역 계좌 목록)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja010qDto {
    private String corpGr;
    private String fundCd;
    private String fundNm;
    private String bfGyulYmd;   // 전결산일 (YYYY-MM-DD)
    private String bfStart;      // bf_gyul_ymd + 1
    private String afGyulYmd;   // 후결산일
    private String haejiYmd;    // 계약해지일
    private String af;          // haeji_ymd - 1
}
