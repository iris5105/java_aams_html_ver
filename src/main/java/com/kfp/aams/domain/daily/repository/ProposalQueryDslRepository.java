package com.kfp.aams.domain.daily.repository;

import com.kfp.aams.domain.daily.dto.ProposalCommentDto;
import com.kfp.aams.domain.daily.dto.ProposalMasterDto;
import com.kfp.aams.domain.daily.entity.ProposalAppend;
import com.kfp.aams.domain.daily.entity.QProposalAppend;
import com.kfp.aams.domain.home.entity.Proposal;
import com.kfp.aams.domain.home.entity.QProposal;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * QueryDSL Repository for PROPOSAL and PROPOSAL_APPEND single-table queries
 * - d_proposal_list.srd (PROPOSAL)
 * - d_proposal_2.srd (PROPOSAL_APPEND)
 * Adheres strictly to Guideline 1 & Guideline 4.
 */
@Repository
@RequiredArgsConstructor
public class ProposalQueryDslRepository {

    private final JPAQueryFactory queryFactory;

    private static final DateTimeFormatter DATETIME_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public List<ProposalMasterDto> findProposalMasterList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }

        QProposal q = QProposal.proposal;
        LocalDate today = LocalDate.now();

        List<Proposal> entities = queryFactory
                .selectFrom(q)
                .where(q.corpGr.eq(corpGr.trim()))
                .orderBy(q.ymd.desc())
                .fetch();

        return entities.stream().map(e -> {
            boolean isToday = e.getYmd() != null && today.equals(e.getYmd().toLocalDate());
            return ProposalMasterDto.builder()
                    .corpGr(e.getCorpGr())
                    .ymd(e.getYmd() != null ? e.getYmd().format(DATETIME_FMT) : null)
                    .proposer(e.getProposer())
                    .title(e.getTitle())
                    .matter(e.getMatter())
                    .contentYmd(e.getContentYmd() != null ? e.getContentYmd().format(DATETIME_FMT) : null)
                    .content(e.getContent())
                    .fexp(e.getFexp())
                    .orgFname(e.getOrgFname())
                    .saveVisible(isToday ? 1 : 0)
                    .build();
        }).collect(Collectors.toList());
    }

    public List<ProposalCommentDto> findProposalCommentList(String corpGr, String ymdStr, String proposer, String gsUser) {
        if (corpGr == null || corpGr.isBlank() || ymdStr == null || ymdStr.isBlank() || proposer == null || proposer.isBlank()) {
            return Collections.emptyList();
        }

        LocalDateTime pYmd = parseDateTime(ymdStr.trim());
        if (pYmd == null) {
            return Collections.emptyList();
        }

        QProposalAppend q = QProposalAppend.proposalAppend;

        List<ProposalAppend> entities = queryFactory
                .selectFrom(q)
                .where(
                        q.corpGr.eq(corpGr.trim()),
                        q.pYmd.eq(pYmd),
                        q.pProposer.eq(proposer.trim())
                )
                .orderBy(q.ymd.desc())
                .fetch();

        return entities.stream().map(e -> {
            boolean isCurrentUser = gsUser != null && gsUser.equals(e.getSbNm());
            int color = isCurrentUser ? 16711680 : 33554432;
            return ProposalCommentDto.builder()
                    .corpGr(e.getCorpGr())
                    .pYmd(e.getPYmd() != null ? e.getPYmd().format(DATETIME_FMT) : null)
                    .pProposer(e.getPProposer())
                    .ymd(e.getYmd() != null ? e.getYmd().format(DATETIME_FMT) : null)
                    .sbNm(e.getSbNm())
                    .appending(e.getAppending())
                    .color(color)
                    .build();
        }).collect(Collectors.toList());
    }

    private LocalDateTime parseDateTime(String text) {
        try {
            return LocalDateTime.parse(text, DATETIME_FMT);
        } catch (Exception e1) {
            try {
                return LocalDate.parse(text, DateTimeFormatter.ofPattern("yyyy-MM-dd")).atStartOfDay();
            } catch (Exception e2) {
                return null;
            }
        }
    }
}
