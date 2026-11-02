package com.kfp.aams.domain.assetmanagement.mapper.querydsl;

import com.kfp.aams.domain.assetmanagement.dto.Ja030aDto;
import com.kfp.aams.domain.assetmanagement.entity.Sjt5j1;
import com.kfp.aams.domain.assetmanagement.entity.Sjt5j1Id;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/** SJT5J1 단일 테이블 날짜 조회 및 CUD를 담당하는 JPA 저장소. */
@Repository
@RequiredArgsConstructor
public class Ja030aLedgerRepository {
    private final EntityManager em;

    public List<LocalDate> findTransactionDates(String corpGr) {
        return em.createQuery("SELECT DISTINCT s.trYmd FROM Sjt5j1 s WHERE s.corpGr = :corpGr ORDER BY s.trYmd DESC", LocalDate.class)
                .setParameter("corpGr", corpGr)
                .getResultList();
    }

    public void insert(Ja030aDto dto) {
        em.persist(toEntity(dto));
    }

    public boolean update(Ja030aDto dto) {
        Sjt5j1Id oldId = idOf(dto, dto.getOriginalFundCd());
        Sjt5j1 entity = em.find(Sjt5j1.class, oldId);
        if (entity == null) return false;

        // FUND_CD는 PB에서 TabOrder 10의 수정 가능 키 컬럼이다. 키 변경은 기존 행을 제거한 뒤 새 키로 저장한다.
        if (!entity.getFundCd().equals(dto.getFundCd())) {
            em.remove(entity);
            em.flush();
            em.persist(toEntity(dto));
            return true;
        }

        entity.setTrJusu(zero(dto.getTrJusu()));
        entity.setTrDanga(zero(dto.getTrDanga()));
        entity.setTrAek(amount(dto));
        entity.setSusu(zero(dto.getSusu()));
        entity.setGyulAek(amount(dto).add(zero(dto.getSusu())));
        return true;
    }

    public boolean delete(Ja030aDto dto) {
        Sjt5j1 entity = em.find(Sjt5j1.class, idOf(dto, dto.getOriginalFundCd()));
        if (entity == null) return false;
        em.remove(entity);
        return true;
    }

    private Sjt5j1 toEntity(Ja030aDto dto) {
        BigDecimal tradeAmount = amount(dto);
        return Sjt5j1.builder()
                .corpGr(dto.getCorpGr()).trYmd(dto.getTrYmd()).trCd(dto.getTrCd()).jmCd(dto.getJmCd())
                .fundCd(dto.getFundCd()).balhCo(dto.getBalhCo())
                .typeTrench(blankTo(dto.getTypeTrench(), "00:")).bsType(dto.getBsType() == null ? BigDecimal.ZERO : dto.getBsType())
                .krakYmd(dto.getKrakYmd()).balhGa(dto.getBalhGa()).chengYmd(dto.getChengYmd()).trCoCd(dto.getTrCoCd())
                .trJusu(zero(dto.getTrJusu())).trDanga(zero(dto.getTrDanga())).trAek(tradeAmount)
                .susu(zero(dto.getSusu())).gyulAek(tradeAmount.add(zero(dto.getSusu())))
                .build();
    }

    private Sjt5j1Id idOf(Ja030aDto dto, String originalFundCd) {
        return new Sjt5j1Id(dto.getCorpGr(), dto.getTrYmd(), dto.getTrCd(), dto.getJmCd(),
                blankTo(originalFundCd, dto.getFundCd()), dto.getBalhCo(), blankTo(dto.getTypeTrench(), "00:"),
                dto.getBsType() == null ? BigDecimal.ZERO : dto.getBsType());
    }

    private BigDecimal amount(Ja030aDto dto) { return zero(dto.getTrJusu()).multiply(zero(dto.getTrDanga())); }
    private BigDecimal zero(BigDecimal value) { return value == null ? BigDecimal.ZERO : value; }
    private String blankTo(String value, String fallback) { return value == null || value.isBlank() ? fallback : value; }
}
