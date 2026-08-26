package com.kfp.aams.domain.home.repository;

import com.kfp.aams.domain.home.dto.CompanyDto;
import com.kfp.aams.domain.home.dto.DayTrDto;
import com.kfp.aams.domain.home.dto.ProposalDto;
import com.kfp.aams.domain.home.entity.QFwDayTr;
import com.kfp.aams.domain.home.entity.QProposal;
import com.kfp.aams.domain.home.entity.QSzx0aa;
import com.kfp.aams.util.QueryDslUtils;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.StringTemplate;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class HomeQueryDslRepository {

        private final JPAQueryFactory queryFactory;

        /**
         * SZX0AA: Single Table query on SZX0AA via QueryDSL
         */
        public List<CompanyDto> findCompanyList() {
                QSzx0aa szx0aa = QSzx0aa.szx0aa;

                return queryFactory
                                .select(Projections.fields(CompanyDto.class,
                                                szx0aa.corpGr,
                                                szx0aa.companyName,
                                                szx0aa.hyunYmd,
                                                szx0aa.gijungaYmd,
                                                szx0aa.junyongYmd,
                                                szx0aa.ikyongYmd,
                                                szx0aa.thikyongYmd,
                                                szx0aa.symd,
                                                szx0aa.eymd,
                                                szx0aa.depositDd,
                                                szx0aa.depositAccount,
                                                szx0aa.bigo,
                                                szx0aa.customerGr,
                                                szx0aa.expenseYn))
                                .from(szx0aa)
                                .orderBy(szx0aa.corpGr.asc())
                                .fetch();
        }

        /**
         * d_home01: Single Table query on FW_DAY_TR via QueryDSL using f_open_ymd
         * custom DB function
         */
        public List<DayTrDto> findDayTrList(String corpGr, String ymd) {
                QFwDayTr dayTr = QFwDayTr.fwDayTr;
                StringTemplate openYmd = QueryDslUtils.fOpenYmd();

                return queryFactory
                                .select(Projections.constructor(DayTrDto.class,
                                                dayTr.corpGr,
                                                dayTr.jasanGb,
                                                dayTr.trCd,
                                                dayTr.trCount,
                                                dayTr.trAek,
                                                dayTr.fundCount,
                                                openYmd.as("titleYmd")))
                                .from(dayTr)
                                .where(dayTr.corpGr.eq(corpGr)
                                                .and(dayTr.ymd.eq(openYmd)))
                                .orderBy(dayTr.jasanGb.asc(), dayTr.trCd.asc())
                                .fetch();
        }

        /**
         * d_home06: Single Table query on PROPOSAL via QueryDSL
         */
        public List<ProposalDto> findProposalList(String corpGr) {
                QProposal proposal = QProposal.proposal;

                return queryFactory
                                .select(Projections.constructor(ProposalDto.class,
                                                proposal.corpGr,
                                                proposal.ymd,
                                                proposal.proposer,
                                                proposal.title,
                                                proposal.matter,
                                                proposal.contentYmd,
                                                proposal.content))
                                .from(proposal)
                                .where(proposal.corpGr.eq(corpGr))
                                .orderBy(proposal.ymd.desc())
                                .fetch();
        }
}
