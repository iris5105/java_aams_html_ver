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

    public long getNextOfferNo(String corpGr, LocalDate trYmd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null) return 1L;
        try {
            Long maxOfferNo = em.createQuery(
                    "SELECT COALESCE(MAX(j.offerNo), 0) + 1 " +
                            "  FROM Sjt1jg j " +
                            " WHERE j.corpGr = :corpGr AND j.trYmd = :trYmd", Long.class)
                    .setParameter("corpGr", corpGr.trim())
                    .setParameter("trYmd", trYmd)
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
                .trYmd(dto.getTrYmd())
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
                .sudoYmd(dto.getSudoYmd())
                .loadTime(LocalDateTime.now())
                .loadUser("JA010E")
                .build();
        em.persist(entity);
    }

    public void updateSjt1jg(Ja010eDto dto) {
        Sjt1jgId id = new Sjt1jgId(
                dto.getCorpGr(),
                dto.getTrYmd(),
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
            entity.setSudoYmd(dto.getSudoYmd());
        }
    }

    public void deleteSjt1jg(Ja010eDto dto) {
        Sjt1jgId id = new Sjt1jgId(
                dto.getCorpGr(),
                dto.getTrYmd(),
                dto.getTrCd(),
                dto.getTrCoCd(),
                dto.getOfferNo()
        );
        Sjt1jg entity = em.find(Sjt1jg.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    /**
     * PowerBuilder w_ja010e::cb_del clicked:
     * deletes only broker-loaded rows. Manually entered rows have no encrypted
     * account number and must remain available for the user to save.
     */
    public int deleteLoadedSjt1jg(String corpGr, LocalDate trYmd, String trCoCd) {
        return em.createQuery(
                        "DELETE FROM Sjt1jg j " +
                        " WHERE j.corpGr = :corpGr " +
                        "   AND j.trYmd = :trYmd " +
                        "   AND j.trCoCd = :trCoCd " +
                        "   AND j.encAcctNo IS NOT NULL")
                .setParameter("corpGr", corpGr)
                .setParameter("trYmd", trYmd)
                .setParameter("trCoCd", trCoCd)
                .executeUpdate();
    }

    /** PB w_ja010e::wf_load duplicate predicate before dw_list.update(). */
    public boolean existsImportedTrade(String corpGr, LocalDate trYmd, String trCd,
                                       String fundCd, String jmCd, String trCoCd, Long offerNo) {
        Long count = em.createQuery(
                        "SELECT COUNT(j) FROM Sjt1jg j "
                                + "WHERE j.corpGr = :corpGr AND j.trYmd = :trYmd "
                                + "AND j.trCd = :trCd AND j.fundCd = :fundCd "
                                + "AND j.jmCd = :jmCd AND j.trCoCd = :trCoCd "
                                + "AND j.offerNo = :offerNo", Long.class)
                .setParameter("corpGr", corpGr)
                .setParameter("trYmd", trYmd)
                .setParameter("trCd", trCd)
                .setParameter("fundCd", fundCd)
                .setParameter("jmCd", jmCd)
                .setParameter("trCoCd", trCoCd)
                .setParameter("offerNo", offerNo)
                .getSingleResult();
        return count != null && count > 0;
    }
}
