package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Scm1smDto;
import com.kfp.aams.domain.dailyadvisory.entity.Scm1sm;
import com.kfp.aams.domain.dailyadvisory.entity.Scm1smId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * JPA Repository for w_scm1sm (채권 단가 관리)
 * - Pure JPA Entity (Scm1sm) persistence without hardcoded native SQL
 */
@Repository
@RequiredArgsConstructor
public class Scm1smQueryDslRepository {

    private final EntityManager em;

    public void insertScm1sm(Scm1smDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getYmd() == null || dto.getJmCd() == null) return;

        LocalDate ymd = dto.getYmd();
        Scm1smId id = new Scm1smId(dto.getCorpGr().trim(), ymd, dto.getJmCd().trim());
        Scm1sm entity = em.find(Scm1sm.class, id);

        BigDecimal jySuikRt = calculateJySuikRt(dto);
        String asCjCd = (dto.getAsCjCd() != null && !dto.getAsCjCd().isBlank()) ? dto.getAsCjCd().trim() : dto.getJmCd().trim();

        if (entity == null) {
            entity = Scm1sm.builder()
                    .corpGr(dto.getCorpGr().trim())
                    .ymd(ymd)
                    .jmCd(dto.getJmCd().trim())
                    .asCjCd(asCjCd)
                    .danga(dto.getDanga())
                    .jySuikRt(jySuikRt)
                    .chgtime(LocalDateTime.now())
                    .build();
            em.persist(entity);
        } else {
            entity.setAsCjCd(asCjCd);
            entity.setDanga(dto.getDanga());
            entity.setJySuikRt(jySuikRt);
            entity.setChgtime(LocalDateTime.now());
        }
    }

    public int updateScm1sm(Scm1smDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getYmd() == null || dto.getJmCd() == null) return 0;

        LocalDate ymd = dto.getYmd();
        Scm1smId id = new Scm1smId(dto.getCorpGr().trim(), ymd, dto.getJmCd().trim());
        Scm1sm entity = em.find(Scm1sm.class, id);

        if (entity != null) {
            String asCjCd = (dto.getAsCjCd() != null && !dto.getAsCjCd().isBlank()) ? dto.getAsCjCd().trim() : dto.getJmCd().trim();
            entity.setAsCjCd(asCjCd);
            entity.setDanga(dto.getDanga());
            entity.setJySuikRt(calculateJySuikRt(dto));
            entity.setChgtime(LocalDateTime.now());
            return 1;
        }
        return 0;
    }

    public int deleteScm1sm(Scm1smDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getYmd() == null || dto.getJmCd() == null) return 0;

        LocalDate ymd = dto.getYmd();
        Scm1smId id = new Scm1smId(dto.getCorpGr().trim(), ymd, dto.getJmCd().trim());
        Scm1sm entity = em.find(Scm1sm.class, id);

        if (entity != null) {
            em.remove(entity);
            return 1;
        }
        return 0;
    }

    public int mergeScm1sm(Scm1smDto dto) {
        int updated = updateScm1sm(dto);
        if (updated == 0) {
            insertScm1sm(dto);
            return 1;
        }
        return updated;
    }

    private BigDecimal calculateJySuikRt(Scm1smDto dto) {
        if (dto.getJySuikPer() != null) {
            return dto.getJySuikPer().divide(BigDecimal.valueOf(100), 8, RoundingMode.HALF_UP);
        }
        return dto.getJySuikRt();
    }
}
