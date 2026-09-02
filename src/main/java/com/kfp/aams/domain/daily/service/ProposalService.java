package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.ProposalCommentDto;
import com.kfp.aams.domain.daily.dto.ProposalMasterDto;
import com.kfp.aams.domain.daily.repository.ProposalQueryDslRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_proposal (건의사항 및 개선요청)
 * - Single-table queries on PROPOSAL and PROPOSAL_APPEND via QueryDSL (Guideline 4)
 * - Strictly adheres to Guideline 1 (no default value fallback)
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ProposalService {

    private final ProposalQueryDslRepository proposalQueryDslRepository;

    public List<ProposalMasterDto> getProposalMasterList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return proposalQueryDslRepository.findProposalMasterList(corpGr.trim());
    }

    public List<ProposalCommentDto> getProposalCommentList(String corpGr, String ymd, String proposer, String gsUser) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank() || proposer == null || proposer.isBlank()) {
            return Collections.emptyList();
        }
        return proposalQueryDslRepository.findProposalCommentList(corpGr.trim(), ymd.trim(), proposer.trim(), gsUser);
    }
}
