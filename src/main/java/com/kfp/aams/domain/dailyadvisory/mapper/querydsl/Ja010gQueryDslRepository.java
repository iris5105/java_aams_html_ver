package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * JPA Repository for w_ja010g (자산보유잔액비교 점검)
 * - Pure JPA Entity (Sht0ye) update without hardcoded native SQL
 */
@Repository
@RequiredArgsConstructor
public class Ja010gQueryDslRepository {

    private final EntityManager em;

    public int updateConfirmYmd(String corpGr, LocalDate trYmd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null) return 0;

        String jpql = "UPDATE Sht0ye y SET y.confYmd = :now WHERE y.corpGr = :corpGr AND y.trYmd = :trYmd";
        return em.createQuery(jpql)
                .setParameter("now", LocalDateTime.now())
                .setParameter("corpGr", corpGr.trim())
                .setParameter("trYmd", trYmd)
                .executeUpdate();
    }
}
