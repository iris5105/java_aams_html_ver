package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Scm1pgDetailDto;
import com.kfp.aams.domain.dailyadvisory.entity.Scm1j;
import com.kfp.aams.domain.dailyadvisory.entity.Scm1jId;
import com.kfp.aams.domain.dailyadvisory.entity.Scm1pg;
import com.kfp.aams.domain.dailyadvisory.entity.Scm1pgId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;

/**
 * JPA Repository for w_scm1pg (채권 신용등급 관리)
 * - C/U/D persistence on SCM1PG & SCM1J sync via Pure JPA Entity
 */
@Repository
@RequiredArgsConstructor
public class Scm1pgQueryDslRepository {

    private final EntityManager em;

    public void insertDetail(Scm1pgDetailDto dto) {
        Scm1pg entity = Scm1pg.builder()
                .corpGr(dto.getCorpGr())
                .ymd(dto.getYmd())
                .jmCd(dto.getJmCd())
                .pgCd(dto.getPgCd())
                .build();
        em.persist(entity);
    }

    public int updateDetail(Scm1pgDetailDto dto) {
        Scm1pgId id = new Scm1pgId(dto.getCorpGr(), dto.getYmd(), dto.getJmCd());
        Scm1pg entity = em.find(Scm1pg.class, id);
        if (entity != null) {
            entity.setPgCd(dto.getPgCd());
            return 1;
        }
        return 0;
    }

    public void deleteDetail(String corpGr, String jmCd, LocalDate ymd) {
        Scm1pgId id = new Scm1pgId(corpGr, ymd, jmCd);
        Scm1pg entity = em.find(Scm1pg.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    /**
     * PowerBuilder itemchanged & doubleclicked:
     * UPDATE SCM1J SET pg_cd = :pgCd WHERE corp_gr = :corpGr AND jm_cd = :jmCd AND buy_date = :buyDate
     */
    public void syncScm1j(Scm1pgDetailDto dto) {
        String cleanYmd = dto.getYmd() != null ? dto.getYmd().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd")) : "";
        Scm1jId id = new Scm1jId(dto.getCorpGr(), dto.getJmCd(), cleanYmd);
        Scm1j entity = em.find(Scm1j.class, id);
        if (entity != null) {
            entity.setPgCd(dto.getPgCd());
        }
    }
}
