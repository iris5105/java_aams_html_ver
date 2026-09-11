package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for d_ja990c2 (발행기관 변경이력 디테일)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja990cDetailDto {
    private String balhCo;         // 발행기관코드
    private String ymd;            // 변경일시
    private String chgColumn;      // 변경컬럼명
    private String bfData;         // 변경전 데이터
    private String afData;         // 변경후 데이터
    private String skt0bu;         // 보유계정변경(정정분개) 여부 ('Y'/'N')
    private String updUser;        // 작업자명
}
