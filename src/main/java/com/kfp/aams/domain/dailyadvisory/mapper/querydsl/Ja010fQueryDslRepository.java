package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010fDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sht0ye;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * JPA Repository for w_ja010f (예수금잔액LOAD)
 * - C/U/D persistence on SHT0YE via Pure JPA Entity & JPQL
 */
@Repository
@RequiredArgsConstructor
public class Ja010fQueryDslRepository {

    private final EntityManager em;

    public void insertSht0ye(Ja010fDto dto) {
        Sht0ye entity = Sht0ye.builder()
                .corpGr(dto.getCorpGr())
                .trYmd(parseLocalDate(dto.getTrYmd()))
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
        em.createQuery("UPDATE Sht0ye y SET " +
                        "  y.t0Aek = :t0Aek, " +
                        "  y.t1Aek = :t1Aek, " +
                        "  y.t2Aek = :t2Aek, " +
                        "  y.stockAek = :stockAek, " +
                        "  y.bondAek = :bondAek, " +
                        "  y.rpAek = :rpAek, " +
                        "  y.totAek = :totAek, " +
                        "  y.bigo = :bigo " +
                        "WHERE y.corpGr = :corpGr " +
                        "  AND y.trYmd = :trYmd " +
                        "  AND y.fundCd = :fundCd")
                .setParameter("corpGr", dto.getCorpGr())
                .setParameter("trYmd", parseLocalDate(dto.getTrYmd()))
                .setParameter("fundCd", dto.getFundCd())
                .setParameter("t0Aek", dto.getT0Aek() != null ? dto.getT0Aek() : BigDecimal.ZERO)
                .setParameter("t1Aek", dto.getT1Aek() != null ? dto.getT1Aek() : BigDecimal.ZERO)
                .setParameter("t2Aek", dto.getT2Aek() != null ? dto.getT2Aek() : BigDecimal.ZERO)
                .setParameter("stockAek", dto.getStockAek() != null ? dto.getStockAek() : BigDecimal.ZERO)
                .setParameter("bondAek", dto.getBondAek() != null ? dto.getBondAek() : BigDecimal.ZERO)
                .setParameter("rpAek", dto.getRpAek() != null ? dto.getRpAek() : BigDecimal.ZERO)
                .setParameter("totAek", dto.getTotAek() != null ? dto.getTotAek() : BigDecimal.ZERO)
                .setParameter("bigo", dto.getBigo())
                .executeUpdate();
    }

    public void deleteSht0ye(Ja010fDto dto) {
        em.createQuery("DELETE FROM Sht0ye y " +
                        "WHERE y.corpGr = :corpGr " +
                        "  AND y.trYmd = :trYmd " +
                        "  AND y.fundCd = :fundCd")
                .setParameter("corpGr", dto.getCorpGr())
                .setParameter("trYmd", parseLocalDate(dto.getTrYmd()))
                .setParameter("fundCd", dto.getFundCd())
                .executeUpdate();
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
