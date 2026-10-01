package com.kfp.aams.domain.dailyadvisory.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProposalSaveRequestDto {
    private String corpGr;
    private List<ProposalMasterDto> masterList;
    private List<ProposalMasterDto> deletedMasterList;
    private List<ProposalCommentDto> commentList;
    private List<ProposalCommentDto> deletedCommentList;
}
