package com.kfp.aams.domain.daily.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProposalCommentDto {
    private String corpGr;
    private String pYmd;
    private String pProposer;
    private String ymd;
    private String sbNm;
    private String appending;
    private Integer color;
}
