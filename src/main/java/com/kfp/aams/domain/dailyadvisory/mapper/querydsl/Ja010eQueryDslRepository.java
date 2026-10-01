package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010eDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sjt1jg;
import com.kfp.aams.domain.dailyadvisory.entity.Sjt1jgId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * JPA Repository for w_ja010e (주식체결LOAD(입고))
 * - C/U/D persistence on SJT1JG via Pure JPA Entity & JPQL
 * - PB script-based offer_no sequencing
 */
@Repository
@RequiredArgsConstructor
public class Ja010eQueryDslRepository {

    private final EntityManager em;

    public long getNextOfferNo(String corpGr, String trYmd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trYmd.isBlank()) return 1L;
        try {
            LocalDate parsedTrYmd = parseLocalDate(trYmd);
            Long maxOfferNo = em.createQuery(
                    "SELECT COALESCE(MAX(j.offerNo), 0) + 1 " +
                            "  FROM Sjt1jg j " +
                            " WHERE j.corpGr = :corpGr AND j.trYmd = :trYmd", Long.class)
                    .setParameter("corpGr", corpGr.trim())
                    .setParameter("trYmd", parsedTrYmd)
                    .getSingleResult();
            if (maxOfferNo != null) {
                return maxOfferNo;
            }
        } catch (Exception ignored) {}
        return 1L;
    }

    public void insertSjt1jg(Ja010eDto dto) {
        Sjt1jg entity = Sjt1jg.builder()
                .corpGr(dto.getCorpGr())
                .trYmd(parseLocalDate(dto.getTrYmd()))
                .trCd(dto.getTrCd())
                .trCoCd(dto.getTrCoCd())
                .offerNo(dto.getOfferNo())
                .encAcctNo(dto.getEncAcctNo())
                .jmCd(dto.getJmCd())
                .koscomCd(dto.getKoscomCd())
                .trJusu(dto.getTrJusu() != null ? dto.getTrJusu() : BigDecimal.ZERO)
                .trAek(dto.getTrAek() != null ? dto.getTrAek() : BigDecimal.ZERO)
                .fundCd(dto.getFundCd())
                .dancGb(dto.getDancGb() != null ? dto.getDancGb() : "A")
                .susu(dto.getSusu() != null ? dto.getSusu() : BigDecimal.ZERO)
                .tax(dto.getTax() != null ? dto.getTax() : BigDecimal.ZERO)
                .sudoYmd(parseLocalDate(dto.getSudoYmd()))
                .loadTime(LocalDateTime.now())
                .loadUser("JA010E")
                .build();
        em.persist(entity);
    }

    public void updateSjt1jg(Ja010eDto dto) {
        Sjt1jgId id = new Sjt1jgId(
                dto.getCorpGr(),
                parseLocalDate(dto.getTrYmd()),
                dto.getTrCd(),
                dto.getTrCoCd(),
                dto.getOfferNo()
        );
        Sjt1jg entity = em.find(Sjt1jg.class, id);
        if (entity != null) {
            entity.setTrJusu(dto.getTrJusu() != null ? dto.getTrJusu() : BigDecimal.ZERO);
            entity.setTrAek(dto.getTrAek() != null ? dto.getTrAek() : BigDecimal.ZERO);
            entity.setSusu(dto.getSusu() != null ? dto.getSusu() : BigDecimal.ZERO);
            entity.setTax(dto.getTax() != null ? dto.getTax() : BigDecimal.ZERO);
            entity.setSudoYmd(parseLocalDate(dto.getSudoYmd()));
        }
    }

    public void deleteSjt1jg(Ja010eDto dto) {
        Sjt1jgId id = new Sjt1jgId(
                dto.getCorpGr(),
                parseLocalDate(dto.getTrYmd()),
                dto.getTrCd(),
                dto.getTrCoCd(),
                dto.getOfferNo()
        );
        Sjt1jg entity = em.find(Sjt1jg.class, id);
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
