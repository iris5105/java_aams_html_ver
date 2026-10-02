package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Shj0igDetailDto;
import com.kfp.aams.domain.dailyadvisory.entity.QShj0ig;
import com.kfp.aams.domain.dailyadvisory.entity.Shj0ig;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * QueryDSL Repository for single-table query on SHJ0IG (d_shj0ig.srd)
 * Adheres to Guideline 1 (no default value fallbacks) and Guideline 4 (QueryDSL for single table).
 */
@Repository
@RequiredArgsConstructor
public class Shj0igQueryDslRepository {

    private final JPAQueryFactory queryFactory;

    /**
     * d_shj0ig.srd single table query
     */
    public List<Shj0igDetailDto> findDetailList(String corpGr, String jmCd, BigDecimal nowNo) {
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank()) {
            return Collections.emptyList();
        }

        QShj0ig q = QShj0ig.shj0ig;

        List<Shj0ig> entities = queryFactory
                .selectFrom(q)
                .where(
                        q.corpGr.eq(corpGr),
                        q.jmCd.eq(jmCd)
                )
                .orderBy(q.guganNo.asc())
                .fetch();

        return entities.stream().map(e -> Shj0igDetailDto.builder()
                .corpGr(e.getCorpGr())
                .jmCd(e.getJmCd())
                .guganNo(e.getGuganNo())
                .guganIlsu(e.getGuganIlsu())
                .guganIja(e.getGuganIja())
                .bfIjaYmd(e.getBfIjaYmd())
                .afIjaYmd(e.getAfIjaYmd())
                .ipUser(e.getIpUser())
                .ipYmd(e.getIpYmd())
                .otherCost(e.getOtherCost())
                .otherCostEndYmd(e.getOtherCostEndYmd())
                .platformFee(e.getPlatformFee())
                .platformYmd(e.getPlatformYmd())
                .fixIjaAek(e.getFixIjaAek())
                .nowNo(nowNo)
                .pVisible(1)
                .build()
        ).collect(Collectors.toList());
    }
}
