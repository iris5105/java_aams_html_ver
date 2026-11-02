package com.kfp.aams.domain.assetmanagement.mapper.querydsl;

import com.kfp.aams.domain.assetmanagement.dto.Ja030hDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sht0hg;
import com.kfp.aams.domain.dailyadvisory.entity.Sht0hgId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;

@Repository
@RequiredArgsConstructor
public class Ja030hLedgerRepository {
    private final EntityManager em;

    public void insert(Ja030hDto dto) {
        dto.setSeqNo(nextSeqNo(dto));
        em.persist(toEntity(dto));
    }

    public boolean update(Ja030hDto dto) {
        Sht0hg entity = em.find(Sht0hg.class, oldId(dto));
        if (entity == null) return false;
        copyValues(entity, dto);
        return true;
    }

    public boolean delete(Ja030hDto dto) {
        Sht0hg entity = em.find(Sht0hg.class, oldId(dto));
        if (entity == null) return false;
        em.remove(entity);
        return true;
    }

    private BigDecimal nextSeqNo(Ja030hDto dto) {
        BigDecimal max = em.createQuery("SELECT MAX(s.seqNo) FROM Sht0hg s WHERE s.corpGr = :corpGr "
                        + "AND s.trYmd = :trYmd AND s.trCd = :trCd AND s.fundCd = :fundCd AND s.jmCd = :jmCd", BigDecimal.class)
                .setParameter("corpGr", dto.getCorpGr()).setParameter("trYmd", dto.getTrYmd())
                .setParameter("trCd", dto.getTrCd()).setParameter("fundCd", dto.getFundCd())
                .setParameter("jmCd", dto.getJmCd()).getSingleResult();
        return max == null ? BigDecimal.ONE : max.add(BigDecimal.ONE);
    }

    private Sht0hgId oldId(Ja030hDto dto) {
        return new Sht0hgId(dto.getCorpGr(), dto.getTrYmd(), dto.getTrCd(),
                blankTo(dto.getOriginalFundCd(), dto.getFundCd()), blankTo(dto.getOriginalJmCd(), dto.getJmCd()), dto.getSeqNo());
    }

    private Sht0hg toEntity(Ja030hDto dto) {
        Sht0hg entity = Sht0hg.builder().corpGr(dto.getCorpGr()).trYmd(dto.getTrYmd()).trCd(dto.getTrCd())
                .fundCd(dto.getFundCd()).jmCd(dto.getJmCd()).seqNo(dto.getSeqNo()).build();
        copyValues(entity, dto);
        return entity;
    }

    private void copyValues(Sht0hg entity, Ja030hDto dto) {
        entity.setAekm(zero(dto.getAekm()));
        entity.setTrAek(zero(dto.getTrAek()));
        entity.setMijigubTax(zero(dto.getMijigubTax()));
        entity.setTrCoCd(dto.getTrCoCd());
        entity.setMkSuikRt(zero(dto.getMkSuikRt()));
        entity.setSusuGa(zero(dto.getSusuGa()));
        entity.setTaxOfferGb(dto.getTaxOfferGb());
        entity.setJajunGb(dto.getJajunGb());
    }

    private BigDecimal zero(BigDecimal value) { return value == null ? BigDecimal.ZERO : value; }
    private String blankTo(String value, String fallback) { return value == null || value.isBlank() ? fallback : value; }
}
