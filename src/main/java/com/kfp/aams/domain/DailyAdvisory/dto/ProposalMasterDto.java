package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProposalMasterDto {
    private String corpGr;
    private String ymd;
    private String proposer;
    private String title;
    private String matter;
    private String contentYmd;
    private String content;
    private String fexp;
    private String orgFname;
    private Integer saveVisible;
}
