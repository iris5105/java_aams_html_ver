package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.entity.Sht0ye;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * JPA Repository for w_ja010g (자산보유잔액비교 점검)
 * - Pure JPA Entity (Sht0ye) update via Dirty Checking
 */
@Repository
@RequiredArgsConstructor
public class Ja010gQueryDslRepository {

    private final EntityManager em;

    public int updateConfirmYmd(String corpGr, LocalDate trYmd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null) return 0;

        List<Sht0ye> list = em.createQuery("SELECT y FROM Sht0ye y WHERE y.corpGr = :corpGr AND y.trYmd = :trYmd", Sht0ye.class)
                .setParameter("corpGr", corpGr.trim())
                .setParameter("trYmd", trYmd)
                .getResultList();

        LocalDateTime now = LocalDateTime.now();
        for (Sht0ye y : list) {
            y.setConfYmd(now);
        }
        return list.size();
    }
}
