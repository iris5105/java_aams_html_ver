package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Szx0seDto;
import com.kfp.aams.domain.dailyadvisory.entity.QSzx0se;
import com.kfp.aams.domain.dailyadvisory.entity.Szx0se;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * QueryDSL Repository for single-table query on SZX0SE (d_szx0se.srd)
 * Adheres strictly to Guideline 1 (no default value fallbacks) and Guideline 4 (QueryDSL for single table).
 */
@Repository
@RequiredArgsConstructor
public class Szx0seQueryDslRepository {

    private final JPAQueryFactory queryFactory;
    private final jakarta.persistence.EntityManager em;

    public List<Szx0seDto> findSzx0seList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }

        QSzx0se q = QSzx0se.szx0se;

        List<Szx0se> entities = queryFactory
                .selectFrom(q)
                .where(q.corpGr.eq(corpGr))
                .orderBy(q.used.desc(), q.seriesG1.asc(), q.seriesG2.asc())
                .fetch();

        return entities.stream().map(e -> Szx0seDto.builder()
                .corpGr(e.getCorpGr())
                .seriesG1(e.getSeriesG1())
                .seriesG2(e.getSeriesG2())
                .seriesGb(e.getSeriesGb())
                .seriesNm(e.getSeriesNm())
                .retSusu(e.getRetSusu())
                .retSusuGb(e.getRetSusuGb())
                .futuresInclude(e.getFuturesInclude())
                .used(e.getUsed())
                .reSeoljYear(e.getReSeoljYear())
                .sintakGigan(e.getSintakGigan())
                .bosuGigan(e.getBosuGigan())
                .mokpyoSuikPer(e.getMokpyoSuikPer())
                .preBasic(e.getPreBasic())
                .basicPer(e.getBasicPer())
                .successPer(e.getSuccessPer())
                .magamUsed(e.getMagamUsed())
                .dpUsed(e.getDpUsed())
                .bmGr(e.getBmGr())
                .gugan(e.getGugan())
                .ga(e.getGa())
                .bigo(e.getBigo())
                .originalSeriesGb(e.getSeriesGb())
                .build()
        ).collect(Collectors.toList());
    }

    public void saveEntity(Szx0se entity) {
        if (entity != null) {
            em.merge(entity);
        }
    }

    public long deleteEntity(String corpGr, String seriesGb) {
        QSzx0se q = QSzx0se.szx0se;
        return queryFactory.delete(q)
                .where(
                        q.corpGr.eq(corpGr),
                        q.seriesGb.eq(seriesGb)
                )
                .execute();
    }

    public int syncSzm0iaSeriesGb(String corpGr, String oldSeriesGb, String newSeriesGb) {
        if (oldSeriesGb == null || newSeriesGb == null || oldSeriesGb.equals(newSeriesGb)) {
            return 0;
        }
        try {
            return em.createQuery("UPDATE Szm0ia m SET m.seriesGb = :newSeriesGb WHERE m.corpGr = :corpGr AND m.seriesGb = :oldSeriesGb")
                    .setParameter("newSeriesGb", newSeriesGb)
                    .setParameter("corpGr", corpGr)
                    .setParameter("oldSeriesGb", oldSeriesGb)
                    .executeUpdate();
        } catch (Exception e) {
            return 0;
        }
    }
}
