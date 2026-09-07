package com.kfp.aams.domain.daily.dto;

import lombok.*;

/**
 * Master Grid DTO for w_ja010h (d_szm0ia.srd / SZM0IA + UZM0UI UNION SKT0GS)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja010hMasterDto {
    private String corpGr;       // 회사그룹코드
    private String fundCd;       // 관리코드 / 펀드코드
    private String fundNm;       // 고객명 / 펀드명
    private String workGb;       // 작업구분 (결산 등)
    private String bfYmd;        // 이전기준일자 (yyyy.mm.dd 또는 yyyy-mm-dd)
    private String afGyulYmd;    // 만기일자 / 결산일자
    private String secCd;        // 증권사 코드 (d_dddwctl 연동)
    private String ymd;          // 기준일자
    private String secNm;        // 증권사명 (코드명 표출용)
}
