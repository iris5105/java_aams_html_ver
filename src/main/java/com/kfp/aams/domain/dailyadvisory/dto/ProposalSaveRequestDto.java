package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class ProposalSaveRequestDto {
    private String corpGr;
    private List<ProposalMasterDto> masterList;
    private List<ProposalMasterDto> deletedMasterList;
    private List<ProposalCommentDto> commentList;
    private List<ProposalCommentDto> deletedCommentList;
}
