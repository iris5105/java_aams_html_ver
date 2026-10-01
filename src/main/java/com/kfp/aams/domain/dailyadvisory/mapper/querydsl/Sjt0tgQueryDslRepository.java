package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Sjt0tgDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sjt0tg;
import com.kfp.aams.domain.dailyadvisory.entity.Sjt0tgId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * JPA Repository for w_sjt0tg (주식 시간외/단일가 체결내역 등록)
 * - C/U/D persistence on SJT0TG via Pure JPA Entity
 */
@Repository
@RequiredArgsConstructor
public class Sjt0tgQueryDslRepository {

    private final EntityManager em;

    public void insertSjt0tg(Sjt0tgDto dto) {
        BigDecimal change = dto.getChange();
        if (change == null && dto.getClose() != null && dto.getPreclose() != null) {
            change = dto.getClose().subtract(dto.getPreclose());
        }

        Sjt0tg entity = Sjt0tg.builder()
                .corpGr(dto.getCorpGr())
                .ymd(parseLocalDate(dto.getYmd()))
                .koscomCd(dto.getKoscomCd())
                .close(dto.getClose())
                .volume(dto.getVolume())
                .value(dto.getValue())
                .preclose(dto.getPreclose())
                .change(change)
                .aekm(dto.getAekm())
                .sangjJusu(dto.getSangjJusu())
                .modDt(LocalDateTime.now())
                .build();
        em.persist(entity);
    }

    public int updateSjt0tg(Sjt0tgDto dto) {
        Sjt0tgId id = new Sjt0tgId(dto.getCorpGr(), parseLocalDate(dto.getYmd()), dto.getKoscomCd());
        Sjt0tg entity = em.find(Sjt0tg.class, id);
        if (entity != null) {
            BigDecimal change = dto.getChange();
            if (change == null && dto.getClose() != null && dto.getPreclose() != null) {
                change = dto.getClose().subtract(dto.getPreclose());
            }

            entity.setClose(dto.getClose());
            entity.setVolume(dto.getVolume());
            entity.setValue(dto.getValue());
            entity.setPreclose(dto.getPreclose());
            entity.setChange(change);
            entity.setAekm(dto.getAekm());
            entity.setSangjJusu(dto.getSangjJusu());
            entity.setModDt(LocalDateTime.now());
            return 1;
        }
        return 0;
    }

    public void deleteSjt0tg(Sjt0tgDto dto) {
        Sjt0tgId id = new Sjt0tgId(dto.getCorpGr(), parseLocalDate(dto.getYmd()), dto.getKoscomCd());
        Sjt0tg entity = em.find(Sjt0tg.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    public void mergeSjt0tg(Sjt0tgDto dto) {
        int updated = updateSjt0tg(dto);
        if (updated == 0) {
            insertSjt0tg(dto);
        }
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
