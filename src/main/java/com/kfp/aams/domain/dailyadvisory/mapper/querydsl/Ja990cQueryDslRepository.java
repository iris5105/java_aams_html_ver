package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja990cDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja990cMasterDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sjx0jb;
import com.kfp.aams.domain.dailyadvisory.entity.Sjx0jbHistory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * JPA Repository for w_ja990c (발행기관코드관리)
 * - sjx0jb C/U/D 및 sjx0jb_history 영속화 (순수 JPA Entity 기반)
 */
@Repository
@RequiredArgsConstructor
public class Ja990cQueryDslRepository {

    private final EntityManager em;

    public int checkBalhCoExists(String balhCo) {
        Long count = em.createQuery("SELECT COUNT(b) FROM Sjx0jb b WHERE b.balhCo = :balhCo", Long.class)
                .setParameter("balhCo", balhCo)
                .getSingleResult();
        return count != null ? count.intValue() : 0;
    }

    public void insertMaster(Ja990cMasterDto item) {
        String encBubinNo = encrypt(item.getBubinNo());

        Sjx0jb entity = Sjx0jb.builder()
                .balhCo(item.getBalhCo())
                .balhNm(item.getBalhNm())
                .trStopGb(item.getTrStopGb())
                .sosokGb(item.getSosokGb())
                .aekm(item.getAekm())
                .grBalhGb(item.getGrBalhGb())
                .budoYmd(item.getBudoYmd())
                .compCd(item.getCompCd())
                .gyulMm(item.getGyulMm())
                .isinCd(item.getIsinCd())
                .compBu(item.getCompBu())
                .balhNation(item.getBalhNation())
                .encBubinNo(encBubinNo)
                .delYn(item.getDelYn() != null ? item.getDelYn() : "0")
                .build();

        em.persist(entity);
    }

    public int updateMaster(Ja990cMasterDto item) {
        Sjx0jb entity = em.find(Sjx0jb.class, item.getBalhCo());
        if (entity != null) {
            entity.setBalhNm(item.getBalhNm());
            entity.setTrStopGb(item.getTrStopGb());
            entity.setSosokGb(item.getSosokGb());
            entity.setAekm(item.getAekm());
            entity.setGrBalhGb(item.getGrBalhGb());
            entity.setBudoYmd(item.getBudoYmd());
            entity.setCompCd(item.getCompCd());
            entity.setGyulMm(item.getGyulMm());
            entity.setIsinCd(item.getIsinCd());
            entity.setCompBu(item.getCompBu());
            entity.setBalhNation(item.getBalhNation());
            if (item.getBubinNo() != null && !item.getBubinNo().isBlank()) {
                entity.setEncBubinNo(encrypt(item.getBubinNo()));
            }
            entity.setDelYn(item.getDelYn() != null ? item.getDelYn() : "0");
            return 1;
        }
        return 0;
    }

    public int deleteMaster(String balhCo) {
        Sjx0jb entity = em.find(Sjx0jb.class, balhCo);
        if (entity != null) {
            em.remove(entity);
            return 1;
        }
        return 0;
    }

    public void insertHistory(Ja990cDetailDto hist) {
        Sjx0jbHistory history = Sjx0jbHistory.builder()
                .balhCo(hist.getBalhCo())
                .ymd(hist.getYmd() != null ? hist.getYmd() : LocalDateTime.now())
                .chgColumn(hist.getChgColumn())
                .bfData(hist.getBfData())
                .afData(hist.getAfData())
                .skt0bu(hist.getSkt0bu() != null ? hist.getSkt0bu() : "N")
                .updUser(hist.getUpdUser())
                .build();
        em.persist(history);
    }

    private String encrypt(String plain) {
        if (plain == null || plain.isBlank()) return null;
        try {
            return em.createQuery("SELECT function('TO_ENCRYPTS', :plain) FROM Sjx0jb b WHERE rownum = 1", String.class)
                    .setParameter("plain", plain.trim())
                    .getSingleResult();
        } catch (Exception e) {
            // fallback native if JPA function mapping requires native
            return (String) em.createNativeQuery("SELECT TO_ENCRYPTS(:plain) FROM DUAL")
                    .setParameter("plain", plain.trim())
                    .getSingleResult();
        }
    }
}
