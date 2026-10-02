package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.ProposalCommentDto;
import com.kfp.aams.domain.dailyadvisory.dto.ProposalMasterDto;
import com.kfp.aams.domain.dailyadvisory.mapper.querydsl.ProposalQueryDslRepository;
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

    /**
     * 건의사항 및 댓글 저장 (신규 INSERT, 수정 UPDATE, 댓글 DELETE)
     */
    @Transactional
    public int saveProposal(com.kfp.aams.domain.dailyadvisory.dto.ProposalSaveRequestDto requestDto, String username) {
        if (requestDto == null) return 0;
        int count = 0;

        String corpGr = requestDto.getCorpGr();
        java.time.LocalDateTime now = java.time.LocalDateTime.now();

        // 1. Master List (건의사항 본문)
        if (requestDto.getMasterList() != null) {
            for (ProposalMasterDto m : requestDto.getMasterList()) {
                String cGr = (m.getCorpGr() != null && !m.getCorpGr().isBlank()) ? m.getCorpGr() : corpGr;
                java.time.LocalDateTime ymd = m.getYmd() != null ? m.getYmd() : now;
                String proposer = (m.getProposer() != null && !m.getProposer().isBlank()) ? m.getProposer() : username;

                if (Boolean.TRUE.equals(m.getIsNew()) || Boolean.TRUE.equals(m.getIsUpdated())) {
                    java.time.LocalDateTime cYmd = m.getContentYmd();
                    if (m.getContent() != null && !m.getContent().isBlank() && cYmd == null) {
                        cYmd = now;
                    }

                    com.kfp.aams.home.entity.Proposal entity = com.kfp.aams.home.entity.Proposal.builder()
                            .corpGr(cGr)
                            .ymd(ymd)
                            .proposer(proposer)
                            .title(m.getTitle())
                            .matter(m.getMatter())
                            .content(m.getContent())
                            .contentYmd(cYmd)
                            .fexp(m.getFexp())
                            .orgFname(m.getOrgFname())
                            .build();

                    proposalQueryDslRepository.saveProposal(entity);
                    count++;
                }
            }
        }

        // 2. Deleted Comments (하위 댓글 삭제)
        if (requestDto.getDeletedCommentList() != null) {
            for (ProposalCommentDto c : requestDto.getDeletedCommentList()) {
                String cGr = (c.getCorpGr() != null && !c.getCorpGr().isBlank()) ? c.getCorpGr() : corpGr;
                java.time.LocalDateTime pYmd = c.getPYmd();
                java.time.LocalDateTime ymd = c.getYmd();
                if (cGr != null && pYmd != null && ymd != null && c.getPProposer() != null) {
                    proposalQueryDslRepository.deleteProposalAppend(cGr, pYmd, c.getPProposer(), ymd, c.getSbNm());
                    count++;
                }
            }
        }

        // 3. Deleted Masters (마스터 건의사항 삭제 - 댓글 선행 삭제 포함)
        if (requestDto.getDeletedMasterList() != null) {
            for (ProposalMasterDto m : requestDto.getDeletedMasterList()) {
                String cGr = (m.getCorpGr() != null && !m.getCorpGr().isBlank()) ? m.getCorpGr() : corpGr;
                java.time.LocalDateTime ymd = m.getYmd();
                if (cGr != null && ymd != null && m.getProposer() != null) {
                    proposalQueryDslRepository.deleteProposal(cGr, ymd, m.getProposer());
                    count++;
                }
            }
        }

        // 3. New / Updated Comments
        if (requestDto.getCommentList() != null) {
            for (ProposalCommentDto c : requestDto.getCommentList()) {
                if (Boolean.TRUE.equals(c.getIsNew()) || Boolean.TRUE.equals(c.getIsUpdated())) {
                    String cGr = (c.getCorpGr() != null && !c.getCorpGr().isBlank()) ? c.getCorpGr() : corpGr;
                    java.time.LocalDateTime pYmd = c.getPYmd();
                    java.time.LocalDateTime ymd = c.getYmd() != null ? c.getYmd() : now;
                    String sbNm = (c.getSbNm() != null && !c.getSbNm().isBlank()) ? c.getSbNm() : username;

                    com.kfp.aams.domain.dailyadvisory.entity.ProposalAppend append = com.kfp.aams.domain.dailyadvisory.entity.ProposalAppend.builder()
                            .corpGr(cGr)
                            .pYmd(pYmd)
                            .pProposer(c.getPProposer())
                            .ymd(ymd)
                            .sbNm(sbNm)
                            .appending(c.getAppending())
                            .build();

                    proposalQueryDslRepository.saveProposalAppend(append);
                    count++;
                }
            }
        }

        return count;
    }
}
