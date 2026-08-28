package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.ProposalCommentDto;
import com.kfp.aams.domain.daily.dto.ProposalMasterDto;
import com.kfp.aams.domain.daily.mapper.ProposalMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ProposalService {

    private final ProposalMapper proposalMapper;

    public List<ProposalMasterDto> getProposalMasterList(String corpGr) {
        return proposalMapper.selectProposalMasterList(corpGr);
    }

    public List<ProposalCommentDto> getProposalCommentList(String corpGr, String ymd, String proposer) {
        return proposalMapper.selectProposalCommentList(corpGr, ymd, proposer);
    }
}
