package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010oMasterDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sjm0jmColl;
import com.kfp.aams.domain.dailyadvisory.entity.Sjm0jmCollId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;

/**
 * JPA Repository for w_ja010o (주식 신용/대출잔고 LOAD)
 * - SJM0JM_COLL C/U/D 및 Merge 영속화 (순수 JPA Entity 기반)
 */
@Repository
@RequiredArgsConstructor
public class Ja010oQueryDslRepository {

    private final EntityManager em;

    public int updateCollateral(Ja010oMasterDto dto) {
        Sjm0jmCollId id = buildId(dto);
        Sjm0jmColl entity = em.find(Sjm0jmColl.class, id);
        if (entity != null) {
            entity.setCollJusu(dto.getCollJusu());
            entity.setCollateral(dto.getCollateral());
            entity.setCollStart(parseLocalDate(dto.getCollStart()));
            entity.setCollEnd(parseLocalDate(dto.getCollEnd()));
            return 1;
        }
        return 0;
    }

    public void insertCollateral(Ja010oMasterDto dto) {
        Sjm0jmColl entity = Sjm0jmColl.builder()
                .corpGr(dto.getCorpGr())
                .ymd(parseLocalDate(dto.getYmd()))
                .fundCd(dto.getFundCd())
                .jmCd(dto.getJmCd())
                .collJusu(dto.getCollJusu())
                .collateral(dto.getCollateral())
                .collStart(parseLocalDate(dto.getCollStart()))
                .collEnd(parseLocalDate(dto.getCollEnd()))
                .build();
        em.persist(entity);
    }

    public void mergeCollateral(Ja010oMasterDto dto) {
        int updated = updateCollateral(dto);
        if (updated == 0) {
            insertCollateral(dto);
        }
    }

    public int deleteCollateral(Ja010oMasterDto dto) {
        Sjm0jmCollId id = buildId(dto);
        Sjm0jmColl entity = em.find(Sjm0jmColl.class, id);
        if (entity != null) {
            em.remove(entity);
            return 1;
        }
        return 0;
    }

    private Sjm0jmCollId buildId(Ja010oMasterDto dto) {
        return new Sjm0jmCollId(
                dto.getCorpGr(),
                parseLocalDate(dto.getYmd()),
                dto.getFundCd(),
                dto.getJmCd()
        );
    }

    private LocalDate parseLocalDate(String text) {
        if (text == null || text.isBlank()) return null;
        String digits = text.replaceAll("\\D", "");
        if (digits.length() == 8) {
            return LocalDate.of(
                    Integer.parseInt(digits.substring(0, 4)),
                    Integer.parseInt(digits.substring(4, 6)),
                    Integer.parseInt(digits.substring(6, 8))
            );
        }
        return LocalDate.parse(text.substring(0, 10).replace('.', '-').replace('/', '-'));
    }
}
