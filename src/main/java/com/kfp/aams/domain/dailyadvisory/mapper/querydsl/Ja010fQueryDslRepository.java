package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010fDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sht0ye;
import com.kfp.aams.domain.dailyadvisory.entity.Sht0yeId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * JPA Repository for w_ja010f (예수금잔액LOAD)
 * - C/U/D persistence on SHT0YE via Pure JPA Entity
 */
@Repository
@RequiredArgsConstructor
public class Ja010fQueryDslRepository {

    private final EntityManager em;

    public void insertSht0ye(Ja010fDto dto) {
        Sht0ye entity = Sht0ye.builder()
                .corpGr(dto.getCorpGr())
                .trYmd(dto.getTrYmd())
                .fundCd(dto.getFundCd())
                .trCoCd(dto.getTrCoCd() != null ? dto.getTrCoCd() : "")
                .t0Aek(dto.getT0Aek() != null ? dto.getT0Aek() : BigDecimal.ZERO)
                .t1Aek(dto.getT1Aek() != null ? dto.getT1Aek() : BigDecimal.ZERO)
                .t2Aek(dto.getT2Aek() != null ? dto.getT2Aek() : BigDecimal.ZERO)
                .stockAek(dto.getStockAek() != null ? dto.getStockAek() : BigDecimal.ZERO)
                .bondAek(dto.getBondAek() != null ? dto.getBondAek() : BigDecimal.ZERO)
                .rpAek(dto.getRpAek() != null ? dto.getRpAek() : BigDecimal.ZERO)
                .totAek(dto.getTotAek() != null ? dto.getTotAek() : BigDecimal.ZERO)
                .encAcctNo(dto.getEncAcctNo())
                .bigo(dto.getBigo() != null ? dto.getBigo() : "w_ja010f")
                .build();
        em.persist(entity);
    }

    public void updateSht0ye(Ja010fDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getTrYmd() == null || dto.getFundCd() == null) {
            return;
        }

        String trCoCd = dto.getTrCoCd() != null ? dto.getTrCoCd().trim() : "";
        Sht0yeId id = new Sht0yeId(dto.getCorpGr().trim(), dto.getTrYmd(), dto.getFundCd().trim(), trCoCd);
        Sht0ye entity = em.find(Sht0ye.class, id);

        if (entity != null) {
            entity.setT0Aek(dto.getT0Aek() != null ? dto.getT0Aek() : BigDecimal.ZERO);
            entity.setT1Aek(dto.getT1Aek() != null ? dto.getT1Aek() : BigDecimal.ZERO);
            entity.setT2Aek(dto.getT2Aek() != null ? dto.getT2Aek() : BigDecimal.ZERO);
            entity.setStockAek(dto.getStockAek() != null ? dto.getStockAek() : BigDecimal.ZERO);
            entity.setBondAek(dto.getBondAek() != null ? dto.getBondAek() : BigDecimal.ZERO);
            entity.setRpAek(dto.getRpAek() != null ? dto.getRpAek() : BigDecimal.ZERO);
            entity.setTotAek(dto.getTotAek() != null ? dto.getTotAek() : BigDecimal.ZERO);
            if (dto.getBigo() != null) {
                entity.setBigo(dto.getBigo());
            }
        }
    }

    public void deleteSht0ye(Ja010fDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getTrYmd() == null || dto.getFundCd() == null) {
            return;
        }

        String trCoCd = dto.getTrCoCd() != null ? dto.getTrCoCd().trim() : "";
        Sht0yeId id = new Sht0yeId(dto.getCorpGr().trim(), dto.getTrYmd(), dto.getFundCd().trim(), trCoCd);
        Sht0ye entity = em.find(Sht0ye.class, id);

        if (entity != null) {
            em.remove(entity);
        } else {
            List<Sht0ye> list = em.createQuery("SELECT y FROM Sht0ye y WHERE y.corpGr = :corpGr AND y.trYmd = :trYmd AND y.fundCd = :fundCd", Sht0ye.class)
                    .setParameter("corpGr", dto.getCorpGr().trim())
                    .setParameter("trYmd", dto.getTrYmd())
                    .setParameter("fundCd", dto.getFundCd().trim())
                    .getResultList();
            for (Sht0ye item : list) {
                em.remove(item);
            }
        }
    }
}
