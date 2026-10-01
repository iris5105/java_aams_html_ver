package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Sjt1tgDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sjt1tg;
import com.kfp.aams.domain.dailyadvisory.entity.Sjt1tgId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * JPA Repository for w_sjt1tg (주식 시간외/단일가 체결내역 등록(주식체결))
 * - C/U/D persistence on SJT1TG via Pure JPA Entity
 */
@Repository
@RequiredArgsConstructor
public class Sjt1tgQueryDslRepository {

    private final EntityManager em;

    public void insertSjt1tg(Sjt1tgDto dto) {
        BigDecimal change = dto.getChange();
        if (change == null && dto.getClose() != null && dto.getPreclose() != null) {
            change = dto.getClose().subtract(dto.getPreclose());
        }

        Sjt1tg entity = Sjt1tg.builder()
                .koscomCd(dto.getSjCd())
                .ymd(parseLocalDate(dto.getYmd()))
                .close(dto.getClose())
                .volume(dto.getVolume())
                .value(dto.getValue())
                .preclose(dto.getPreclose())
                .spotPrice(dto.getSpotPrice())
                .calcPrice(dto.getCalcPrice())
                .change(change)
                .build();
        em.persist(entity);
    }

    public int updateSjt1tg(Sjt1tgDto dto) {
        Sjt1tgId id = new Sjt1tgId(dto.getSjCd(), parseLocalDate(dto.getYmd()));
        Sjt1tg entity = em.find(Sjt1tg.class, id);
        if (entity != null) {
            BigDecimal change = dto.getChange();
            if (change == null && dto.getClose() != null && dto.getPreclose() != null) {
                change = dto.getClose().subtract(dto.getPreclose());
            }

            entity.setClose(dto.getClose());
            entity.setVolume(dto.getVolume());
            entity.setValue(dto.getValue());
            entity.setPreclose(dto.getPreclose());
            entity.setSpotPrice(dto.getSpotPrice());
            entity.setCalcPrice(dto.getCalcPrice());
            entity.setChange(change);
            return 1;
        }
        return 0;
    }

    public void deleteSjt1tg(String ymd, String sjCd) {
        Sjt1tgId id = new Sjt1tgId(sjCd, parseLocalDate(ymd));
        Sjt1tg entity = em.find(Sjt1tg.class, id);
        if (entity != null) {
            em.remove(entity);
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
